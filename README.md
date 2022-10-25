
# Step 1.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Open Xcode
Runner -> Product(Menu) -> Scheme -> Edit Scheme -> Build (Lift MenuBar) -> Pre-actions 

# Step 2.
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- Run Script(Sell) 에 이하 내용 붙쳐 넣기.
function entry_decode() { echo "${*}" | base64 --decode; }
IFS=',' read -r -a define_items <<< "$DART_DEFINES"
for index in "${!define_items[@]}"
do define_items[$index]=$(entry_decode "${define_items[$index]}");
done
printf "%s\n" "${define_items[@]}"|grep '^KOLON_' > ${SRCROOT}/Flutter/KolonBuildSettings.xcconfig


# Step 3. 
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Open IDE (Project) 
ios -> Flutter -> New file ( KolonBuildSettings-defaults.xcconfig)
이하내용 copy. 

KOLON_APP_VERSION_NAME=null
KOLON_BUNDLE_ID=null
KOLON_APP_BASE_URL=null
KOLON_APP_BUILD_TYPE=null
KOLON_APP_IOS_COMPANY_CODE=null


## 앱 실행 하기 전!!!~~ 
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
프로잭트 내에서  "빌드옵션" 검색 후 
혜당 프로잭트에 맞는 값으로 수정해주세요.

## run option 
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- 운영 
flutter run --dart-define=KOLON_BUNDLE_ID=com.kolon.medsalesportal --dart-define=KOLON_APP_VERSION_NAME=01.05.02  --dart-define=KOLON_APP_BASE_URL=https://apps.kolon.com --dart-define=KOLON_APP_BUILD_TYPE=prod

- 개발
flutter run --dart-define=KOLON_BUNDLE_ID=com.kolon.medsalesportaldev  --dart-define=KOLON_APP_VERSION_NAME=01.05.02  --dart-define=KOLON_APP_BASE_URL=https://appdev.kolon.com --dart-define=KOLON_APP_BUILD_TYPE=dev


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

firebase GoogleService-Info file 추가설명.
- Android는 수정 할 필요 없이 기본파일 세팅되면 App내에서 Dev&Prod 구분하여 각각의 FirebaseApp 적용.
- iOS는 현재 dev로 세팅되 있고 나중에 운녕 빌드시 project > environment 폴더에 저장된 GoogleService-Info-Prod.plist를 파일명 수정 후 info.plist 가 위치한 폴더에 저장한다. (Android 처럼 개발/운영 모두 한개의 파일로 묶어도 무방 할것 같습니다.)
  
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

data model 신규생성 
flutter pub run build_runner build --delete-conflicting-outputs