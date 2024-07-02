import 'dart:async';

class Pomodoro {
  int count = 0;
  late int work_minutes;
  late int rest_minutes_1;
  late int rest_minutes_2;
  bool check = false;
  Pomodoro(this.work_minutes, this.rest_minutes_1, this.rest_minutes_2);

  // 뽀모도로 타이머 시작 메소드
  // : 반복해서 타이머 메소드를 호출하는 역할
  void start() {
    print("Pomodoro 타이머를 시작하겠습니다. ");

    /*
    while (count <= 5) {
      count += 1;
      print("$count회차 작업을 시작하겠습니다. ");

      if (count % 4 == 0) {
        if (check == false){
          timer('w');
        }else {
          timer('r2');
        }
      }else if (count % 4 != 0){
        if (check == false){
          timer('w');
        }else {
          timer('r1');
        }
      }
    }
    */

    count += 1;
    print("$count회차 작업을 시작하겠습니다. ");

    if (count % 4 == 0) {
      if (check == false){
        timer('w');
      }else {
        timer('r2');
      }
    }else if (count % 4 != 0){
      if (check == false){
        timer('w');
      }else {
        timer('r1');
      }
    }

    // stop();
  }

  // 타이머 메소드 (매개변수 : 워크/휴식1/휴식2)
  void timer(String mode) {
    int seconds = 60;
    int minutes = 0;

    if (mode == 'w') {
      minutes = work_minutes - 1;
    } else if (mode == 'r1') {
      minutes = rest_minutes_1 - 1;
    } else if (mode == 'r2') {
      minutes = rest_minutes_2 - 1;
    }

    // 1초 간격으로 반복 실행되는 타이머 생성
    Timer.periodic(Duration(seconds: 1), (timer) {
      // print('Tick: ${timer.tick}'); // timer.tick은 타이머가 몇 번 실행되었는지 알려줍니다.

      if (seconds <= 0) {
        seconds = 59;
        if (minutes <= 0) {
          timer.cancel();

          if (mode == 'w') {
            print('작업 시간이 종료되었습니다.');
            check = true;
          } else if (mode == 'r1') {
            print('$rest_minutes_1분 휴식 시간이 종료되었습니다.');
          } else if (mode == 'r2') {
            print('$rest_minutes_2분 휴식 시간이 종료되었습니다.');
          }
        } else {
          minutes -= 1;
          print('$minutes:$seconds');
        }
      } else {
        seconds -= 1;
        print('$minutes:$seconds');
      }
    });
  }

  // 초를 분:초로 표시하는 메소드
  void printTimer() {

  }

  // 뽀모도로 타이머 종료 메소드
  void stop() {
    print("Pomodoro 타이머를 종료하겠습니다.");
  }
}

void main() {
  Pomodoro pomodoro = Pomodoro(25, 5, 15);
  pomodoro.start();


  /*
  int seconds = 60;
  int minutes = 1;

  // 1초 간격으로 반복 실행되는 타이머 생성
  Timer.periodic(Duration(seconds: 1), (timer) {
    print('Tick: ${timer.tick}'); // timer.tick은 타이머가 몇 번 실행되었는지 알려줍니다.

    if (seconds <= 0) {
      seconds = 59;
      if (minutes <= 0) {
        timer.cancel();
        print('Timer stopped');
      } else {
        minutes -= 1;
        print('$minutes:$seconds');
      }
    } else {
      seconds -= 1;
      print('$minutes:$seconds');
    }
  });
  */
}

/*
[회고]
- 임상운 :
 간단할 줄 알았는데 생각보다 어려웠고 제 실력이 떨어진다는 것을 느낄 수 있었습니다.
다음에는 준비를 더 잘해서 열심히 해봐야겠습니다. 아쉬움이 많이 남는 퀘스트 였습니다.
일단 와일문 적용이 힘들어서 중간에 시간이 모자랐습니다. ㅠㅠ

- 김주현 :
 반복문과 비동기 처리에 대한 부분이 혼동이 되어서 아직 최종 완료가 되지 못한 것이 아쉽습니다. 

*/
