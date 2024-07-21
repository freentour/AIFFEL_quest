# '동화책 읽어줘!' 어플 만들기 - 플러터 메인 퀘스트

## 앱 정보
- **앱 이름**
  - '동화책 읽어줘!'
- **대상 고객**
  - 주변 사물에 관심이 많고 언어 발달이 한창 진행중인 어린 자녀(2~5세)를 키우고 있는 부모
- **개발 취지**
  - 어린 자녀를 키우다 보면 가장 많이 듣는 질문이 '이건 뭐야?'라는 질문이고, 가장 많이 받는 요청이 '동화책 읽어줘!'일 것입니다.
  - 그래서, 관심 있는 사물을 카메라로 촬영하면 해당 사진에 어떤 것들이 담겨있는지 자동으로 설명해 주는 기능과, 해당 사진 내용을 주제로 한 동화 이야기를 자동으로 생성해 주는 기능을 핵심 기능으로 하는 어플 '동화책 읽어줘!'를 개발하게 되었습니다.
- **주요 특징**
  - 자동 이미지 캡션: 관심 있는 사물을 카메라로 촬영하면 해당 사진에 어떤 것들이 담겨있는지 자동으로 캡션을 표시해주는 기능. (Salesforce의 BLIP 모델 사용)
  - 자동 스토리 생성: 특정 사진 내용을 주제로 한 동화 이야기를 자동으로 생성해 주는 기능. (OPENAI의 GPT-4o mini 모델 사용)
  - [참고] GPT-4o mini 모델 자체가 멀티모달을 지원하기 때문에 이미지 캡션 기능 역시 GPT-4o mini 모델을 사용해서 처리할 수 있으나, OPENAI API 외에도 허깅페이스를 통해 공개된 다양한 모델을 활용하는 방법에 대해서도 알아보기 위해 이미지 캡션 기능은 BLIP 모델을, 스토리 생성은 GPT-4o mini 모델을 각각 사용함. 

## 앱 구조도
- 계층적으로 작성
- 메인 페이지
  - 갤러리 메인 화면
    - 갤러리 상세 이미지 화면
  - 카메라 촬영 화면
  - 애셋 메인 화면: 어플에 미리 등록된 이미지 목록을 표시해 주는 화면. 
    - 애셋 상세 이미지 화면

## 페이지 구현
1. main.dart - 앱 구조도에 나열한 모든 화면들을 구성. 네비게이션 2.0을 사용해 화면 전환 처리.
2. blip_download.py - Salesforce의 BLIP 모델 다운로드용 코드. (허깅페이스의 transformers 패키지 이용)
3. server_fastapi_blip.py - BLIP 모델과 GPT-4o mini 모델을 둘 다 활용하는 FastAPI 서버 코드
4. openai_test.py - OPENAI API를 통한 GPT-4o mini 모델 테스트용 코드

## 구현 영상
### 1. 설명은 BLIP 모델을, 이야기 생성은 GPT-4o mini 모델을 사용하는 V1 동영상
<img src="https://github.com/freentour/AIFFEL_quest/blob/main/Main_quest/Flutter/flutter_mainquest.gif" width="30%" height="30%"><br>
- [동영상] : https://drive.google.com/file/d/1Ken_71IUef8b5BcUqdQ4gpUeVb8Vh-RD/view?usp=sharing
### 2. 설명도 이야기 생성도 모두 GPT-4o mini 모델을 사용하는 V2 동영상
<img src="https://file.notion.so/f/f/727f9bb2-d473-40fe-acdd-4830d179b2bc/2079fbeb-fb04-49a4-8815-3fe20e83cc80/Untitled.gif?id=1b8c05b8-af6d-4d83-aed7-df87dc2697e1&table=block&spaceId=727f9bb2-d473-40fe-acdd-4830d179b2bc&expirationTimestamp=1721692800000&signature=E0nZP2gPIAzuV4LB3o946q9MFnNePIXZT2D9ufCCaq4&downloadName=Untitled.gif" width="30%" height="30%"><br>
- [동영상] : https://drive.google.com/file/d/19UyLr9OalR2EJZA1aOIuvhXX4fjbmFCl/view?usp=sharing

## 참고 학습 자료
- BLIP: Bootstrapping Language-Image Pre-training for Unified Vision-Language Understanding and Generation
  - 허깅페이스 모델 페이지: https://huggingface.co/Salesforce/blip-image-captioning-large
- OPENAI Developer Quckstart 페이지: https://platform.openai.com/docs/quickstart
- [GeekNews] OpenAI, 가장 비용 효율적인 작은 모델 GPT-4o mini 공개: https://news.hada.io/topic?id=15917

## 회고
- 플러터를 이용해 전체 기능 대부분이 안정적으로 동작하는 어플을 처음부터 끝까지 개발할 수 있어서 매우 신선한 자극이 되었습니다.
- GET 방식의 단순 FastAPI 서버에서 클라이언트로부터 이미지 파일을 전송 받아 처리하고 응답을 제공하는 POST 방식의 엔드 포인트를 추가할 수 있었습니다.
- 무엇보다 허깅페이스에 공개된 다양한 모델 중 원하는 모델을 찾아 파이썬 코드로 활용할 수 있는 방법을 찾아보고 직접 구현해볼 수 있었던 점이 가장 큰 수확이라고 생각됩니다.
- OPENAI API를 직접 사용해보는 것 역시 처음이었는데, 공식 문서 정리가 워낙 잘 되어있어서 매우 즐거운 경험이었습니다.
- 특히, 퀘스트 첫 날에는 기본 기능만 충실히 구현하도록 노력하였는데, 어느 정도 기본 기능의 구현이 이루어진 뒤에는 VGG16 모델을 넘어서 다양한 모델을 사용해 보고 싶다는 생각이 들었고, 그로 인해 BLIP과 GPT-4o mini 모델까지 활용해 볼 수 있었습니다.
- 처음부터 계획한 것은 아니었지만, 개발 과정에서 자연스럽게 수렴하게 된 '동화책 읽어줘!' 어플의 주요 기능과 타겟 고객 선정 모두 나름의 의미가 있어 향후에도 좀 더 개선시켜나갈 계획입니다. 
