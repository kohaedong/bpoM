
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
flutter run --dart-define=KOLON_BUNDLE_ID=com.kolon.medsalesportal --dart-define=KOLON_APP_VERSION_NAME=02.00.28  --dart-define=KOLON_APP_BASE_URL=https://apps.kolon.com --dart-define=KOLON_APP_BUILD_TYPE=prod

- 개발
flutter run --dart-define=KOLON_BUNDLE_ID=com.kolon.medsalesportaldev  --dart-define=KOLON_APP_VERSION_NAME=02.00.28  --dart-define=KOLON_APP_BASE_URL=https://appdev.kolon.com --dart-define=KOLON_APP_BUILD_TYPE=dev


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

firebase GoogleService-Info file 추가설명.
- Android는 수정 할 필요 없이 기본파일 세팅되면 App내에서 Dev&Prod 구분하여 각각의 FirebaseApp 적용.
- iOS는 현재 dev로 세팅되 있고 나중에 운녕 빌드시 project > environment 폴더에 저장된 GoogleService-Info-Prod.plist를 파일명 수정 후 info.plist 가 위치한 폴더에 저장한다. (Android 처럼 개발/운영 모두 한개의 파일로 묶어도 무방 할것 같습니다.)
  
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

data model 신규생성 
flutter pub run build_runner build --delete-conflicting-outputs


>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

[✓] Flutter (Channel stable, 3.3.5, on macOS 12.6 21G115 darwin-x64, locale zh-Hans-KR)
    • Flutter version 3.3.5 on channel stable at /Users/bakbeom/install/flutter
    • Upstream repository https://github.com/flutter/flutter.git
    • Framework revision d9111f6402 (11 天前), 2022-10-19 12:27:13 -0700
    • Engine revision 3ad69d7be3
    • Dart version 2.18.2
    • DevTools version 2.15.0

[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0-rc4)
    • Android SDK at /Users/bakbeom/Library/Android/sdk
    • Platform android-33, build-tools 33.0.0-rc4
    • Java binary at: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin/java
    • Java version OpenJDK Runtime Environment (build 11.0.12+0-b1504.28-7817840)
    • All Android licenses accepted.

[✓] Xcode - develop for iOS and macOS (Xcode 14.0.1)
    • Xcode at /Applications/Xcode.app/Contents/Developer
    • Build 14A400
    • CocoaPods version 1.11.2

[✓] Chrome - develop for the web
    • Chrome at /Applications/Google Chrome.app/Contents/MacOS/Google Chrome

[✓] Android Studio (version 2021.2)
    • Android Studio at /Applications/Android Studio.app/Contents
    • Flutter plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/9212-flutter
    • Dart plugin can be installed from:
      🔨 https://plugins.jetbrains.com/plugin/6351-dart
    • Java version OpenJDK Runtime Environment (build 11.0.12+0-b1504.28-7817840)

[✓] VS Code (version 1.72.2)
    • VS Code at /Applications/Visual Studio Code.app/Contents
    • Flutter extension version 3.50.0

[✓] Connected device (3 available)
    • iPhone 14 Pro Max (mobile) • 0506DE30-D9DB-4EE7-A0BE-280302469C87 • ios            •
      com.apple.CoreSimulator.SimRuntime.iOS-16-0 (simulator)
    • macOS (desktop)            • macos                                • darwin-x64     • macOS 12.6 21G115 darwin-x64
    • Chrome (web)               • chrome                               • web-javascript • Google Chrome 106.0.5249.119

[✓] HTTP Host Availability
    • All required HTTP hosts are available

• No issues found!