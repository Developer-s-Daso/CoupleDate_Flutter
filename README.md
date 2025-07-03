
# practice3

## 소개

practice3는 커플을 위한 모던하고 미니멀한 Flutter 앱입니다. Google Maps, Kakao Places, Gemini AI 추천 등 다양한 기능을 제공하며, 방문 장소 기록, 리뷰/추억 남기기, 즐겨찾기, 카테고리별 검색, 실시간 위치 기반 추천 등 커플의 데이트 경험을 풍부하게 만들어줍니다.

## 주요 기능

- **Google Maps 연동**: 실시간 위치 기반 지도, 커플이 방문한 장소 마커 표시
- **Kakao Places API**: 카테고리별 장소 검색 및 상세 정보 제공
- **Gemini AI 추천**: 커플의 취향/상황에 맞는 데이트 장소 AI 추천
- **리뷰/추억 기록**: 각 장소별로 커플의 리뷰/사진/메모 남기기
- **즐겨찾기**: 자주 가는 장소를 즐겨찾기로 저장 및 관리
- **카테고리별 검색**: 카페, 맛집, 관광명소 등 다양한 카테고리 지원
- **실시간 위치 기반 추천**: 현재 위치를 기반으로 주변 장소 추천
- **.env 기반 API 키 관리**: 모든 API 키는 .env 파일로 안전하게 관리
- **Mock/Debug 모드**: API 키 없이도 모든 기능을 디버깅/테스트 가능

## 설치 및 실행 방법

1. 저장소 클론 및 패키지 설치
   ```bash
   git clone <your-repo-url>
   cd practice3
   flutter pub get
   ```

2. .env 파일 설정 (루트에 .env 파일 생성)
   ```env
   # 실제 API 사용: USE_MOCK=false, Mock(디버그) 모드: USE_MOCK=true
   USE_MOCK=true
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
   KAKAO_REST_API_KEY=your_kakao_rest_api_key_here
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

3. pubspec.yaml에 .env 파일이 assets로 등록되어 있는지 확인
   ```yaml
   flutter:
     assets:
       - .env
   ```

4. 앱 실행
   ```bash
   flutter run
   ```
   - Web, Android, iOS, Windows, macOS, Linux 모두 지원
   - USE_MOCK=true로 두면 API 키 없이도 모든 기능을 테스트할 수 있습니다.

## 주요 폴더 구조

- `lib/screens/` : 주요 화면(Home, Map, AI 추천, 즐겨찾기, 프로필, 상세 등)
- `lib/services/` : API 연동(Google Maps, Kakao, Gemini AI 등)
- `lib/models/` : 데이터 모델(Place, Review 등)
- `lib/widgets/` : 공통 위젯(마커, 칩, 카드 등)
- `lib/theme/` : 테마 및 스타일

## 개발/디버깅 팁

- .env의 USE_MOCK 값을 true/false로 바꿔 mock/실제 API 전환 가능
- API 키가 없거나 잘못된 경우에도 Mock 데이터/화면으로 앱 흐름 전체 테스트 가능
- pubspec.yaml의 assets에 .env가 반드시 포함되어야 Flutter Web에서 환경변수 사용 가능

## 기여 및 문의

이 프로젝트는 커플의 데이트 경험을 더 풍부하게 만들기 위해 개발되었습니다. 버그 제보, 기능 제안, 기여 모두 환영합니다!
