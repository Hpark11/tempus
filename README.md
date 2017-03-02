# tempus

### 기본정보
* Author : Hyunsoo Park
#tempus는 다양한 분야에 종사하거나 취미를 가진 사람들이 그들의 이해관계나 목적에 맞는 커뮤니티를 빠르고 쉽게 구성하고 참여하여 자신의 한정된 시간을 가치있게 만들어 줄 수 있는 어플리케이션입니다.

#자신이 현재 성취하고자 하는 목표가 있거나 경험해 보고 싶은 일, 혹은 다른 사람들과 너 나은 취미 생활을 하기 원한다면 tempus에서 함께하세요.

### 동영상 시연 : https://www.youtube.com/watch?v=ZpGM7R0znsg
[![ScreenShot](https://github.com/BoostCamp/MemeMe_hPark/blob/master/img/play.png)](https://www.youtube.com/watch?v=ZpGM7R0znsg)

### 어플리케이션 기본기능
* 커뮤니티 참여
    1. 커뮤니티 찾기
     - 자기계발을 하고자하는 사람, 입시 준비를 하는 사람, 전문기술의 습득을 원하는 사람, 단순 취미활동을 찾는 사람들이 비슷한 목적을 가진 사람들과 같이 모여서 자기증진에 힘쓸 수 있도록 각기 다른 목적의 패널에 존재하는 커뮤니티를 찾아볼 수 있습니다.
    2. 스토리
     - 자신의 목적에 부합한 커뮤니티를 찾아 모임을 개설한 호스트의 스토리와 간단한 유저 정보와 선호 지역을 확인함으로써 커뮤니티에 대한 참여 여부를 결정할 수 있습니다.
    3. 검
     - 키워드를 입력하여 자신이 찾고자 하는 커뮤니티를 각 패널에서 쉽게 찾을 수 있습니다.
    4. 신청
     - 커뮤니티 가입을 원할 시 간단한 자기소개로 가입신청을 할 수 있습니다.

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




