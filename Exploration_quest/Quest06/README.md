# AI 앱 프로젝트 - 수식 없이도 이해할 수 있는 ChatGPT와 Stable Diffusion [프로젝트]

# FLUX.1 schnell 모델을 사용해 생성한 최종 이미지
- API 플랫폼 : fal.ai (https://fal.ai/)
- 사용한 모델 : FLUX.1 schnell (https://blackforestlabs.ai/)
- 프롬프트 : "An illustration that creating an AI model by taking in various data as input, using a coffee maker as a metaphor. brand logo is AIFFEL."
- 여러 번 생성한 것 중에서 가장 마음에 드는 이미지는 다음과 같음. 
<img src="https://fal.media/files/rabbit/Wrrjz2b0EcpK8FkThRAs0.png">

# 회고
- 김원영
  - 2024년 8월 27일에 수행한 최종 프로젝트는 ControlNet 모델 파일을 다운로드하여 로컬 환경에 저장했습니다. OpenCV를 활용해 Canny Edge Detection으로 이미지의 윤곽선을 검출했습니다. 특정 영역을 0으로 설정하여 윤곽선 검출을 조정했습니다. 검출된 윤곽선은 RGB 이미지로 변환하여 PIL 라이브러리로 시각화하였고 Openpose 모델을 로드하기 위해 OpenposeDetector를 사용했습니다. 로드한 이미지를 Openpose 모델로 처리하여 인체 자세를 검출하였는데 이 과정은 이미지의 세부적인 특징을 파악하는 데 중요한 역할을 했습니다.
  - 이미지 생성 파이프라인을 설정하기 위해 Canny와 Openpose 두 가지 ControlNet 모델을 로드하고 StableDiffusionControlNetPipeline을 사용하여 파이프라인을 설정하고, ControlNet 모델 리스트를 파이프라인에 전달했습니다.  UniPCMultistepScheduler를 사용하여 스케줄러도 설정했습니다.
  - 이미지 생성을 위해 프롬프트와 네거티브 프롬프트를 설정했습니다. Canny 이미지와 Openpose 이미지를 동일한 크기로 조정한 후, 설정된 파이프라인과 프롬프트를 사용하여 이미지를 생성했습니다.
  - 결과적으로, 어제부터 이어진 GPU 사용 한도 초과 이슈로 CPU 환경에서 위의 과정을 통한 새로운 이미지 생성을 진행하다 보니 무척 기대하고 있는 최종 이미지의 시각화가 완료될 때까지는 약 20시간 정도 더 기다려봐야 할 것 같습니다.
  - 그러나, 이번 학습을 통해 ControlNet과 Stable Diffusion을 사용하여 복합적인 이미지 생성 파이프라인을 설정하고 실행하는 방법을 익혔습니다. 특히, 윤곽선 검출과 인체 자세 검출을 결합하여 더 정교한 이미지를 생성할 수 있음을 확인했습니다.
  - 이번 프로젝트를 통해 다양한 전처리기와 모델을 결합하여 원하는 이미지를 생성하는 방법을 체계적으로 학습할 수 있었습니다. 즐겁고 흥미로웠던 이틀 간의 학습이었습니다.
- 김주현
  - 이번 프로젝트를 통해 다양한 전처리기와 모델을 결합하여 원하는 이미지를 생성하는 방법을 체계적으로 학습할 수 있었습니다. 즐겁고 흥미로웠던 이틀 간의 학습이었습니다.
  - LMS, 코랩 모두 CUDA out of memory 오류가 너무 많이 나와서 더욱 많은 실험을 해볼 수 없었던 점은 매우 아쉬운 부분입니다.
  - 이미지 생성 분야에서 최근 각광을 받고 있는 FLUX.1 모델을 간단하게나마 사용해볼 수 있었던 기회여서 재미있었습니다. 
