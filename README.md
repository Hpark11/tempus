# MemeMe_hpark

### 기본정보
* Author : Hyunsoo Park
* Second assignment for boostcamp

### 동영상 시연 : https://www.youtube.com/watch?v=ZpGM7R0znsg
[![ScreenShot](https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/play.png)](https://www.youtube.com/watch?v=ZpGM7R0znsg)

### 어플리케이션 기본기능
* Meme 제작기능
    - 카메라로 직접 사진찍기
    - 포토 라이브러리에서 사진 고르기
    - 지정된 프레임으로 사진 자르기
    - 위(TOP), 아래(BOTTOM) 위치에 Meme 문자열 추가 기능
    - Meme 업로드 및 공유기능 (Activity, Share)

* Meme 관리기능
    - Meme 저장 기능 (Core Data활용으로 기존의 어플리케이션을 종료후 재실행시 저장된 Meme이 전부 사라지는 문제 해결)
    - Meme Display 기능 (Table View와 Collection View를 통해 저장된 Meme의 목록을 확인 가능)
    - Meme 삭제 기능 (Core Data에서 지정된 Meme을 삭제 후 Table 및 Collection View에 바로 업데이트)

### 나만의 Kick - MemeMe SNS
#### Backend as a Service(Baas)인 Firebase활용으로 Social Media로서 갖춰야할 기본기능(회원관리, Meme공유화면, 포스팅, 좋아요 등) 구현
1. 회원관리
    * 로그인 (이메일 로그인 - SwiftValidator로 Email, Password Validation 기능, 페이스북 로그인 - Facebook SDK활용)
    * 회원가입
    * KeyChainWrapper 활용으로 이미 로그인 했던 사용자의 uid를 키체인에 등록시켜 자동 로그인 기능 구현

2. Meme 공유화면
    * 각 사용자의 개인사진
    * 사용자 닉네임
    * 포스팅 올린 시간표시
    * 유저가 올린 Meme사진 전시
    * 좋아요를 누른 사람의 숫자
    * 좋아요 버튼

3. 포스팅
    * 각 사용자의 개인사진과 닉네임 전시
    * Table과 Collection View에서 선택한 Meme전시
    * Meme을 소개하는 짧은 글 작성기능

4. 개인 정보 화면
    * 자신의 이메일을 확인 가능한 화면 구현
    * 자신의 개인 이미지와 닉네임 수정가능

### 구현 화면
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/1.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/3.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/5.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/7.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/8.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/9.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/10.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/11.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/12.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/13.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/15.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/16.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/17.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/18.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/19.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/20.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/22.png" width="280">
<img src="https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/23.png" width="280">




