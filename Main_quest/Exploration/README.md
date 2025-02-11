# [프로젝트] 의료영상 U-Net 용종검출

# 결과
- 각 모델별 평균 IoU 결과 비교
  - Encoder-Decoder 모델: 0.4755510379084097
  - U-Net 모델: 0.5158318924581786
  - Pre-trained U-Net 모델: 0.6421994433685003
- 결과 해석
  - 기본 Encoder-Decoder 모델에 비해 인코더의 Skip-connection을 활용하는 U-Net 모델이 아무래도 좀 더 좋은 판독 결과를 보여주는 것으로 해석됨. 
  - 현재의 데이터셋을 가지고 처음부터 훈련시키는 U-Net 모델에 비해 Pre-trained VGG16 모델을 사용해 인코더를 구성한 개선 모델이 좀 더 좋은 판독 결과를 보여주었는데, 이러한 결과로 볼 때 비록 훈련한 데이터셋이 전혀 다르더라도 대량의 데이터셋으로 훈련한 Pre-trained 모델이 이미지에서 특성을 추출하는 기본 능력이 더 좋고, 그것이 처음 보는 의료 데이터에 대해서도 큰 영향을 미치는 것으로 해석됨. 

# 회고
- 아주 많은 데이터는 아닐지라도 실제 의료 데이터를 사용해볼 수 있는 좋은 기회였음. 
- 특히, 데이터가 적은 경우에는 확실히 Pre-trained 모델을 적극적으로 활용하는 것이 성능 개선에 있어서 중요한 영향을 끼친다는 것을 이해할 수 있었음. 
