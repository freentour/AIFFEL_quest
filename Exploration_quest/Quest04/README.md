# AI 앱 프로젝트 - 인공지능으로 세상에 없던 새로운 패션 만들기

## 회고
- 김재이
  - GAN 모델의 학습의 어려움을 체감했다. 최적화의 최저값이 고정되지 않은 시스템(527)에 대해서 인식하고 공부할 수 있었지만 여전히 성능을 높이는 구체적인 접근을 다 이해하지는 못했다.
  - 100, 200 에포크로 학습의 효과를 보기는 어려웠고, 1000단위의 에포크를 지나자 눈에 띄는 생성 이미지의 차이가 놀라웠다.
  - GAN 모델의 학습을 조정할 때 주의할 수 있는 첫번째는 커널 사이즈.
- 김주현
  - 생성형 모델에 있어서 이정표와 같은 역할을 했던 GAN 모델에 대해 살펴볼 수 있는 좋은 기회였고, 비지도 학습 방식으로 생성자와 판별자가 서로 경쟁하듯이 학습을 진행하면서 새로운 이미지를 생성해갈 수 있다는 점이 매우 인상 깊었음.
  - 2,000 에포크까지 훈련을 진행하고 나니 완벽하진 않아도 자동차와 얼추 비슷한 이미지가 생성되는 것을 보니 좀 더 많은 에포크로 훈련하면 좀 더 좋은 결과를 얻을 수 있을 것으로 보임.
  - 케창딥 책에서 소개하고 있는 GAN 모델 훈련 시 유의할 사항을 참고해 커널 사이즈와 모델 구조를 변경한 다음 다시 훈련을 진행해 보았더니 시각적으로는 이전 모델에 비해 훨씬 안정적이고 유의미한 이미지 생성이 이루어지는 것을 확인할 수 있었던 것도 재미있었음.
  - 아울러 직접 모델을 사용해보지는 못했지만 이미지 생성 모델에 주로 활용되는 대표적인 기술의 종류와, 현재 시점을 기준으로 가장 성능이 뛰어난 이미지 생성 모델의 종류 등을 정리해 볼 수 있는 기회였음.

## 결과
- 김재이 결과
  - Fashion MNIST 데이터셋
    - **1,000 에포크**까지 진행한 후의 결과
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_history.png"> 
    - **1,000 에포크**까지 진행한 후의 결과
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_history.png"> 
  - CIFAR-10 데이터셋
    - **1,000 에포크**까지 진행한 후의 결과
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_history.png"> 
- 김주현 결과
  - [기본 실험]
    - **1,000 에포크**까지 진행한 후의 결과
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_1000epochs_history.png"> 
    - **2,000 에포크**까지 진행한 후의 결과
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_2000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case1_2000epochs_history.png">
  - [추가 실험] **커널 사이즈를 (4,4)로 변경하고 모델 구조를 케창딥 책에 있는 내용으로 변경해서 1,000 에포크까지 진행한 후의 결과**
      - 최종 생성 샘플
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case2_1000epochs_last_samples.png" width="150%" height="150%"> 
      - 최종 히스토리 그래프
        <img src="https://github.com/freentour/AIFFEL_quest/blob/main/Exploration_quest/Quest04/dcgan_cifar10_case2_1000epochs_history.png">
