

# practice3

## 소개

**practice3**는 커플을 위한 모던하고 미니멀한 Flutter 앱입니다.  
Google Maps, Kakao Places, Gemini AI 추천 등 다양한 외부 API와 연동하여,  
데이트 장소 기록, 리뷰/사진/추억 남기기, AI 기반 추천, 즐겨찾기, 카테고리별 검색,  
실시간 위치 기반 추천 등 커플의 데이트 경험을 풍부하게 만들어줍니다.

---

## 주요 기능

- **Google Maps 연동**  
  - 실시간 위치 기반 지도, 방문한 장소 마커 표시, 경로 안내
- **Kakao Places API**  
  - 카테고리별 장소 검색, 상세 정보 제공, 장소별 리뷰/사진/메모 기록
- **Gemini AI 추천**  
  - 커플의 취향/상황에 맞는 데이트 장소 AI 추천
- **리뷰/추억 기록**  
  - 각 장소별로 커플의 리뷰, 사진, 메모 남기기
- **즐겨찾기 관리**  
  - 자주 가는 장소를 즐겨찾기로 저장/관리
- **카테고리별 검색**  
  - 카페, 맛집, 관광명소 등 다양한 카테고리 지원
- **실시간 위치 기반 추천**  
  - 현재 위치를 기반으로 주변 장소 추천
- **D-Day, 갤러리, 일기 등 커플만의 기록 기능**
- **.env 기반 API 키 관리**  
  - 모든 API 키는 .env 파일로 안전하게 관리
- **Mock/Debug 모드**  
  - API 키 없이도 모든 기능을 디버깅/테스트 가능

---

## 설치 및 실행 방법

1. **저장소 클론 및 패키지 설치**
   ```bash
   git clone <your-repo-url>
   cd practice3
   flutter pub get
   ```

2. **.env 파일 설정 (루트에 .env 파일 생성)**
   ```env
   # 실제 API 사용: USE_MOCK=false, Mock(디버그) 모드: USE_MOCK=true
   USE_MOCK=true
   GOOGLE_MAPS_API_KEY=your_google_maps_api_key_here
   KAKAO_REST_API_KEY=your_kakao_rest_api_key_here
   GEMINI_API_KEY=your_gemini_api_key_here
   ```

3. **pubspec.yaml에 .env 파일이 assets로 등록되어 있는지 확인**
   ```yaml
   flutter:
     assets:
       - .env
   ```

4. **앱 실행**
   ```bash
   flutter run
   ```
   - Web, Android, iOS, Windows, macOS, Linux 모두 지원
   - USE_MOCK=true로 두면 API 키 없이도 모든 기능을 테스트할 수 있습니다.

---

## 폴더 구조


```
lib/
  main.dart           # 앱 진입점, 라우팅 및 테마 설정
  app.dart            # 전체 MaterialApp, 글로벌 설정
  models/             # 데이터 모델 정의(Place, Review, Gallery, DDay 등)
  services/           # API 연동 및 비즈니스 로직 (Google Maps, Kakao, Gemini 등)
  screens/            # 각 주요 화면(Home, Map, AI 추천, D-Day, 갤러리, 일기, 즐겨찾기 등)
  widgets/            # 여러 화면에서 재사용되는 공통 위젯(마커, 칩, 카드, 채팅버블 등)
  theme/              # 테마, 색상, 폰트 등 스타일 관련 파일(AppTheme 등)
  assets/             # 정적 리소스(폰트, 이미지, Lottie, 샘플 사진 등)
  fonts/              # 커스텀 폰트 파일
  lottie/             # Lottie 애니메이션 리소스
  gallery/            # 샘플 갤러리 이미지
test/                 # 위젯/단위 테스트 코드
```

### 폴더별 상세 설명 (개발자 참고)

- **main.dart / app.dart**: 앱의 진입점, 라우팅, 글로벌 테마 및 환경설정 담당. 앱 실행 시 가장 먼저 실행되는 파일.
- **models/**: DB/네트워크/로컬스토리지 등에서 사용하는 모든 데이터 구조(클래스, fromJson 등) 정의. 예) Place, Review, GalleryItem, DDay 등.
- **services/**: 외부 API 연동, 데이터 CRUD, 비즈니스 로직 담당. 예) GoogleMapsService, KakaoService, GeminiService 등. 화면과 분리된 순수 로직만 위치.
- **screens/**: 실제 UI 화면(페이지) 단위로 구성. 각 화면별로 필요한 상태/로직/전용 위젯을 포함할 수 있음. 예) home_screen.dart, map_screen.dart, ai_recommend_screen.dart, d_day_screen.dart 등.
- **widgets/**: 여러 화면에서 재사용되는 공통 UI 컴포넌트. 예) category_chip.dart, chat_bubble.dart, calendar_widget.dart 등. 화면 전용 위젯은 screens/에 포함.
- **theme/**: 앱 전체의 색상, 폰트, 스타일, 다크모드 등 테마 관련 파일. AppTheme.dart에서 색상/폰트/스타일을 일괄 관리.
- **assets/**: 앱에서 사용하는 모든 정적 리소스(이미지, 폰트, 샘플 데이터, Lottie 등). pubspec.yaml에 등록 필요.
- **fonts/**: NotoSansKR 등 커스텀 폰트 파일 위치.
- **lottie/**: Lottie 애니메이션 json 파일 위치.
- **gallery/**: 샘플 갤러리 이미지(assets/gallery/ 등).
- **test/**: 위젯/단위 테스트 코드. 공동 개발 시 기능별 테스트 코드 작성 권장.

> **공동 개발 가이드**
> - 화면별로만 사용하는 위젯은 screens/에, 여러 화면에서 재사용하는 위젯만 widgets/에 위치
> - 서비스(services/)는 반드시 UI와 분리, 순수 비즈니스 로직만 작성
> - 모델(models/)은 모든 데이터 구조를 명확히 정의하고, fromJson/toJson 등 직렬화 메서드 포함
> - 테마/색상/폰트는 theme/에서 일괄 관리, 직접 색상코드 사용 금지(AppTheme 활용)
> - assets/에 리소스 추가 시 pubspec.yaml에 반드시 등록
> - 테스트 코드(test/) 작성 권장, PR 시 테스트 통과 확인

---

## 개발/디버깅 팁

- `.env`의 `USE_MOCK` 값을 true/false로 바꿔 mock/실제 API 전환 가능
- API 키가 없거나 잘못된 경우에도 Mock 데이터/화면으로 앱 전체 흐름 테스트 가능
- pubspec.yaml의 assets에 .env가 반드시 포함되어야 Flutter Web에서 환경변수 사용 가능
- 주요 색상/스타일은 `lib/theme/app_theme.dart`에서 일괄 관리 (UI/UX 일관성 유지)
- 화면별로만 사용하는 위젯은 해당 화면 파일에 통합, 공통 위젯만 widgets/에 위치

---

## 확장 및 커스터마이징

- 새로운 API 연동, 기능 추가, 디자인 커스터마이징이 쉽도록 구조화
- 서비스/모델/화면/위젯/테마 분리로 유지보수 및 확장성 우수
- 각종 기능(지도, AI, 리뷰, 갤러리 등) 모듈화

---

## 기여 및 문의

이 프로젝트는 커플의 데이트 경험을 더 풍부하게 만들기 위해 개발되었습니다.  
버그 제보, 기능 제안, 코드 기여 모두 환영합니다!  
- Issue 등록 또는 Pull Request로 자유롭게 참여해 주세요.

