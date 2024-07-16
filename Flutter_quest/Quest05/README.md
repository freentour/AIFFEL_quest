## AIFFEL Campus Online Code Peer Review Templete
- 코더 : 김주현 
- 리뷰어 : 김원영 


## PRT(Peer Review Template)

- [O]  **1. 주어진 문제를 해결하는 완성된 코드가 제출되었나요?**
    - 문제에서 요구하는 최종 결과물이 첨부되었는지 확인
    - 문제를 해결하는 완성된 코드란 프로젝트 루브릭 3개 중 2개, 퀘스트 문제 요구조건 등을 지칭
      
      코드와 최종결과물 둘 다 문제에서 요구하는 조건들을 모두 만족하고 하기 이미지처럼 높은 정확성을 보이는 Output을 구현했습니다.
      
      ![image](https://github.com/user-attachments/assets/b26a6f64-80ee-4c08-b9fe-be9f6cd20325)
      ![image](https://github.com/user-attachments/assets/d4491646-ae08-43af-ab62-c2bc854fb5a0)
      ![image](https://github.com/user-attachments/assets/6a7b8626-6a42-4746-a333-cb7327e2b15f)

    
        
- [O]  **2. 전체 코드에서 가장 핵심적이거나 가장 복잡하고 이해하기 어려운 부분에 작성된 
주석 또는 doc string을 보고 해당 코드가 잘 이해되었나요?**
    - 해당 코드 블럭에 doc string/annotation이 달려 있는지 확인
    - 해당 코드가 무슨 기능을 하는지, 왜 그렇게 짜여진건지, 작동 메커니즘이 뭔지 기술.
    - 주석을 보고 코드 이해가 잘 되었는지 확인
      
      debugShowCheckedModeBanner: false 설정을 통해 디버그 모드에서 나타나는 배너를 제거하여 UI를 깔끔하게 유지하였습니다.

      ![image](https://github.com/user-attachments/assets/e47af899-a461-4a10-8b8b-0d368eac0c8f)

    
        
- [O]  **3. 에러가 난 부분을 디버깅하여 문제를 “해결한 기록을 남겼거나” 
”새로운 시도 또는 추가 실험을 수행”해봤나요?**
    - 문제 원인 및 해결 과정을 잘 기록하였는지 확인 또는
    - 문제에서 요구하는 조건에 더해 추가적으로 수행한 나만의 시도, 
    실험이 기록되어 있는지 확인

      회고에도 있지만 fetchData('label')와 fetchData('score')가 오류를 발생시키는 것을 직접 주석을 통해 상세하게 설명하였고 
      이와는 달리 콜백 함수는 () => fetchData('label')와 같이 화살표 함수 형식으로 작성한 것이 하기 코드에 대한 전반적인 이해를 도왔습니다.
      
      ![image](https://github.com/user-attachments/assets/f273398b-f196-460b-9fb3-855fddb161f5)


              
- [O]  **4. 회고를 잘 작성했나요?**
    - 주어진 문제를 해결하는 완성된 코드 내지 프로젝트 결과물에 대해 배운점과 아쉬운점, 느낀점 등이 상세히 기록되어 있는지 확인
 
     main.dart 화면 하단에 하기처럼 잘 작성되어 있습니다.
    
    "학습 템플릿에 있던 코드와 지난 번 고양이, 강아지 전환하는 퀘스트에서 사용했던 코드를 대부분 재사용할 수 있어서 크게 어려움은 없었습니다.
     다만, 버튼이 눌리웠을 때 호춣되는 콜백 함수 작성 방식에서 실수가 있어서 오류가 발생했으나 간단히 수정할 수 있었습니다"

  

- [O]  **5. 코드가 간결하고 효율적인가요?**
    - 코드 중복을 최소화하고 범용적으로 사용할 수 있도록 모듈화(함수화) 했는지
      
      ElevatedButton 위젯을 사용하여 버튼을 생성하는 코드는 간결성과 유지 관리성을 향상시키는 목적으로 구현되었습니다.  

      ![image](https://github.com/user-attachments/assets/c523c570-b22e-4f6a-9a89-fa289fe62252)



## 참고 링크 및 코드 개선
```
# 코드 리뷰 시 참고한 링크가 있다면 링크와 간략한 설명을 첨부합니다.
# 코드 리뷰를 통해 개선한 코드가 있다면 코드와 간략한 설명을 첨부합니다.
```
