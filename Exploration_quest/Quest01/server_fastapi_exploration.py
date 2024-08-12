import uvicorn
from fastapi import FastAPI, Request, HTTPException, File, UploadFile, Query
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from PIL import Image
import io
import logging
import requests
from openai import OpenAI   # GPT-4o mini 사용 위해 추가
from pathlib import Path    # TTS-1 오디오 파일 생성 경로 설정을 위해 추가
from pydantic import BaseModel  # Request 데이터의 유효성 검사 및 문서 자동화를 위해 추가
from typing import Optional     # Python의 타입 힌팅을 위해 추가. (Optional을 사용하면 값이 있을 수도 있고 없을 수도 있음을 의미. 즉, 필수가 아닌 선택을 의미함)
from transformers import AutoTokenizer, TFAutoModel, TFAutoModelForSequenceClassification   # KcELECTRA 모델 사용 위해 추가
import tensorflow as tf
import xmltodict    # XML 파싱을 위해 추가(maniadb.com API)
from urllib.parse import quote, urlencode, urlunparse   # URL 인코딩(특히, 한글)을 위해 추가
import random
import tensorflow_datasets as tfds      # tfds 데이터셋의 info 정보 가져오기 위해 추가
from tensorflow.keras.applications.mobilenet_v3 import preprocess_input     # MobileNetV3Large 모델 관련해서 추가
import numpy as np


# FastAPI 앱 생성
app = FastAPI()

# CORS configuration
origins = ["*"]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# tfds 데이터셋에서 실제 데이터셋은 다운로드 받거나 로드하지 않고 info 정보만 가져와 활용하는 방법
dataset_name = 'tf_flowers'     # 데이터셋 이름
builder = tfds.builder(dataset_name)    # 데이터셋 빌더 생성
info = builder.info     # 데이터셋에서 info 정보만 가져오기
# 해당 데이터셋에서 사용하는 정수형 레이블을 문자열 레이블로 변환해 주는 함수 생성
get_label_name = info.features['label'].int2str     # int2str 프로퍼티는 함수(Callable) 타입의 객체를 리턴함.
# get_label_name(1)     # 'daisy' 출력

# # 그냥 하드코딩해 둔 다음 리스트를 사용해도 됨. 
# flowers_list = ['dandelion', 'daisy', 'tulips', 'sunflowers', 'roses']


# 저장해 둔 MobileNetV3 Large 모델 로드
model_path = './mobilenet/mobilenet_v3_large_best_model.keras'

try:
    # 모델 로드
    saved_model = tf.keras.models.load_model(model_path)
except Exception as e:
    logger.error("Failed to load model: %s", e)
    raise


# A simple example of a GET request
@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "안녕하세요. 여기는 Exploration 모듈입니다."


# POST 요청 데이터의 유효성 검사와 문서 자동화를 위해 Pydantic 모델 상속받아 커스텀 클래스 정의
# 즉, POST 요청을 통해 서버로 전송될 데이터의 형식이라고 보면 됨. 
class TextRequest(BaseModel):
    text: str

# [테스트] 문자열을 전달받아 간단한 처리 후 JSON 형식으로 응답
@app.post("/exploration_test/")
async def process_text(request: TextRequest):
    text = request.text

    # 문자열 처리 로직 (예: 문자열을 대문자로 변환)
    processed_text = text.upper()

    # JSON 응답 생성
    response = {
        "original_text": text,
        "processed_text": processed_text
    }

    # [참고] FastAPI는 응답 대상이 pydantic 객체, dict, list 타입인 경우에는 JSON 직렬화를 자동으로 함. (예: 아래 return response 처럼)
    # (물론, Content-Type 헤더도 'application/json'으로, status code도 '200 OK'로 자동 설정됨)
    # 반면, FastAPI의 공식 응답 객체인 JSONResponse 클래스를 사용하면 응답 본문, 상태 코드, 헤더 등을 명시적으로 지정할 수 있음. 
    # return response
    return JSONResponse(content=response)


class ImageURL(BaseModel):
    url: str

def preprocess_image(image: Image.Image, target_size: tuple) -> np.ndarray:
    # 이미지를 모델 입력 크기로 리사이즈
    image = image.resize(target_size)
    # 이미지 배열로 변환
    image_array = np.array(image)
    # 배치 차원 추가
    image_array = np.expand_dims(image_array, axis=0)
    # 이미지 전처리
    image_array = preprocess_input(image_array)

    return image_array


@app.post("/predict/")
async def predict(image_url: ImageURL):
    try:
        # URL 주소로 넘어온 이미지 파일 다운로드
        response = requests.get(image_url.url)
        response.raise_for_status()     # HTTP 오류 발생 시 예외 발생
        image = Image.open(io.BytesIO(response.content))

        # 이미지 전처리
        processed_image = preprocess_image(image, target_size=(224, 224))

        # 예측 수행
        predictions = saved_model.predict(processed_image)
        predicted_labels = np.argmax(predictions, axis=1)    # 2D 배열의 각 행에 대해 가장 큰 값의 인덱스를 반환
        final_label = predicted_labels[0]
        final_label_str = get_label_name(final_label)
    except requests.RequestException as e:
        raise HTTPException(status_code=400, detail=f"Failed to download image: {e}")
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {e}")

    # JSON 응답 생성
    response = {
        "predicted_label": final_label_str
    }

    return JSONResponse(content=response)


# 앱 실행
if __name__ == "__main__":
    uvicorn.run("server_fastapi_exploration:app",
            reload= True,   # Reload the server when code changes
            host="127.0.0.1",   # Listen on localhost 
            port=5000,   # Listen on port 5000 
            log_level="info"   # Log level
            )