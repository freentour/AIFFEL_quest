import uvicorn
from fastapi import FastAPI, Request, HTTPException, File, UploadFile, Query
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.base import BaseHTTPMiddleware
from transformers import BlipProcessor, BlipForConditionalGeneration, BlipForQuestionAnswering
from PIL import Image
import io
import logging
import requests
from openai import OpenAI   # GPT-4o mini 사용 위해 추가

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

# 미리 약속된 secret_key
SECRET_KEY = "p2C9kROdFYHU1U-cZYInCgyk30A2QvDtwvARfRlCFEQ"

class SecretKeyMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        secret_key = request.headers.get("secret_key")
        if secret_key != SECRET_KEY:
            return JSONResponse(status_code=403, content={"detail": "Forbidden: Invalid secret key"})
        response = await call_next(request)
        return response

# 미들웨어 추가
app.add_middleware(SecretKeyMiddleware)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# 저장해 둔 모델과 프로세서를 로드
try:
    # model_caption = BlipForConditionalGeneration.from_pretrained("./blip_caption/")
    # processor_caption = BlipProcessor.from_pretrained("./blip_caption/processor/")
    model_caption = BlipForConditionalGeneration.from_pretrained("./blip_caption_large/")
    processor_caption = BlipProcessor.from_pretrained("./blip_caption_large/processor/")
    # model_vqa = BlipForQuestionAnswering.from_pretrained("./blip_vqa/")
    # processor_vqa = BlipProcessor.from_pretrained("./blip_vqa/processor/")
    model_vqa = BlipForQuestionAnswering.from_pretrained("./blip_vqa_capfilt_large/")
    processor_vqa = BlipProcessor.from_pretrained("./blip_vqa_capfilt_large/processor/")
except Exception as e:
    logger.error("Failed to load model: %s", e)
    raise

# A simple example of a GET request
@app.get("/")
async def read_root():
    logger.info("Root URL was requested")
    return "BLIP모델을 사용하는 API를 만들어 봅시다."

@app.get('/sample/')
async def generate_caption4sample():
    try:
        # 샘플 이미지
        # 이미지를 로드합니다.
        url = "https://www.cranleighmagazine.co.uk/wp-content/uploads/2017/09/Spagetti-Bolognese.jpg"  # 캡션을 생성할 이미지의 URL
        image = Image.open(requests.get(url, stream=True).raw)

        # 이미지를 전처리합니다.
        inputs = processor_caption(images=image, return_tensors="pt")

        # 캡션을 생성합니다.
        out = model_caption.generate(**inputs)
        caption = processor_caption.decode(out[0], skip_special_tokens=True)

        # 결과 반환
        return JSONResponse(content={"caption": caption})
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

@app.get('/story/')
async def generate_story(caption: str = Query(...)):
    try:
        # GPT-4o mini API 이용해 해당 캡션을 기초로 2살 어린 아이를 위한 동화 이야기 생성해서 응답
        client = OpenAI()

        completion = client.chat.completions.create(
            model="gpt-4o-mini",    # GPT 모델 지정
            messages=[
                {"role": "system", "content": "너는 의성어와 의태어를 적극적으로 사용하는 유아 전문 동화작가야."},
                {"role": "user", "content": f"{caption}를 주제로 하는 동화 이야기를 만들어줘. 2살 여자 아이가 흥미를 잃지 않도록 너무 길지 않게, 엄마 아빠가 직접 읽어주기에 좋은 문체로 작성해 줘. 설명은 최대한 줄이고 대화 문장을 많이 포함해 줘."}
            ]
        )

        story = completion.choices[0].message.content

        # 결과 반환
        return JSONResponse(content={"story": story})
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

@app.post("/caption/")
async def generate_caption(file: UploadFile = File(...)):
    try:
        # 업로드된 파일을 이미지로 변환
        image = Image.open(io.BytesIO(await file.read()))

        # 이미지를 전처리합니다.
        inputs = processor_caption(images=image, return_tensors="pt")

        # 캡션을 생성합니다.
        out = model_caption.generate(**inputs)
        caption = processor_caption.decode(out[0], skip_special_tokens=True)

        # # GPT-4o mini API 이용해 해당 캡션을 기초로 2살 어린 아이를 위한 동화 이야기 생성해서 응답
        # client = OpenAI()

        # completion = client.chat.completions.create(
        #     model="gpt-4o-mini",    # GPT 모델 지정
        #     messages=[
        #         {"role": "system", "content": "너는 의성어와 의태어를 적극적으로 사용하는 유아 전문 동화작가야."},
        #         {"role": "user", "content": f"{caption}를 주제로 하는 동화 이야기를 만들어줘. 2살 여자 아이가 흥미를 잃지 않도록 너무 길지 않게, 엄마 아빠가 직접 읽어주기에 좋은 문체로 작성해 줘. 설명은 최대한 줄이고 대화 문장을 많이 포함해 줘."}
        #     ]
        # )

        # story = completion.choices[0].message.content

        # 결과 반환
        # return JSONResponse(content={"caption": caption, "story": story})
        return JSONResponse(content={"caption": caption})
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")    

@app.post("/vqa/")
async def vqa(file: UploadFile = File(...), question: str = ""):
    try:
        # 업로드된 파일을 이미지로 변환
        image = Image.open(io.BytesIO(await file.read()))

        # 질문을 전처리합니다.
        inputs = processor_vqa(images=image, text=question, return_tensors="pt")

        # 모델을 사용하여 답변을 생성합니다.
        output = model_vqa.generate(**inputs)
        answer = processor_vqa.decode(output[0], skip_special_tokens=True)

        # 결과 반환
        return JSONResponse(content={"answer": answer})
    except Exception as e:
        logger.error("Prediction failed: %s", e)
        raise HTTPException(status_code=500, detail="Internal Server Error")

# 앱 실행
if __name__ == "__main__":
    uvicorn.run("server_fastapi_blip:app",
            reload= True,   # Reload the server when code changes
            host="127.0.0.1",   # Listen on localhost 
            port=5000,   # Listen on port 5000 
            log_level="info"   # Log level
            )