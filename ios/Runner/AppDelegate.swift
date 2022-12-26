import UIKit
import Flutter
import Kolonbase
// import workmanager
enum ChannelName {
  static let channelName = "kolonbase/keychain" 
  static let eventName = "kolonbase/keychain/event"
}

enum CallMethod {
    static let enableAutologin = "enableAutologin"
    static let isAutoLogin = "isAutoLogin"
    static let saveAutoLogin = "saveAutoLogin"  
    static let isSaveId = "isSaveId"
    static let setIsSaveId = "setIsSaveId"
    static let setUserId = "setUserId"
    static let setUserPw = "setUserPw"
    static let getUserId = "userId"
    static let getUserPw = "userPw"
    static let isAllowScreenshotUser = "isAllowScreenshotUser"
    static let isShowWatermarkUser = "isShowWatermarkUser"
}
enum KolonbaseErrorCode {
  static let unavailable = "UNAVAILABLE"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
      
    let controller = window.rootViewController as! FlutterViewController

    let flavorChannel = FlutterMethodChannel(
        name: "flavor",
        binaryMessenger: controller.binaryMessenger)

    flavorChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread
        let flavor = Bundle.main.infoDictionary?["App-Flavor"]
        result(flavor)
    })
    // background prossess
    // WorkmanagerPlugin.setPluginRegistrantCallback { registry in
    //         GeneratedPluginRegistrant.register(with: registry)
    //     }
    //     WorkmanagerPlugin.registerTask(withIdentifier: "com.kolon.bpomdev.taskId")
       
//      KB.Detect.showWaterMark()
//      KB.Detect.setScreenshotDetector()  
// SSO ------- start -------------
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not type FlutterViewController")
    }
    
      
      let eventChannel = FlutterEventChannel(name: ChannelName.eventName, binaryMessenger: controller.binaryMessenger)
              eventChannel.setStreamHandler(SwiftStreamHandler())

let keychainChannel = FlutterMethodChannel(name: ChannelName.channelName,
                                              binaryMessenger: controller.binaryMessenger)
        keychainChannel.setMethodCallHandler({

      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
            print("Store userId = \(KB.KeyChain.userId)")
            print("Store userPw = \(KB.KeyChain.userPw)")
            let callMethod = call.method
            switch callMethod {
            case CallMethod.getUserId:
                result(String(KB.KeyChain.userId))
                return
            case CallMethod.getUserPw:
                result(String(KB.KeyChain.userPw))
                return
            case CallMethod.setUserId:
                if let id = call.arguments as? String{
                    print("id = \(id)")
                    KB.KeyChain.userId=id
                    
                    result(String("success"))
                }else{
                    result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                              message: "bad args",
                                              details: nil))
                }
                return 
            case CallMethod.setUserPw:
                if let password = call.arguments as? String{
                    print("password = \(password)")
                    KB.KeyChain.userPw = password
                    result(String("success"))
                }else{
                    result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                              message: "bad args",
                                              details: nil))
                }
                return
            case CallMethod.isAllowScreenshotUser:
                result(Bool(KB.Auth.isAllowScreenshotUser))
                return
            case CallMethod.isShowWatermarkUser:
                result(Bool(KB.Auth.isShowWatermarkUser))
                return
             case CallMethod.isSaveId:
               result(Bool(KB.KeyChain.isStoreUserId))
               return
            case CallMethod.setIsSaveId:
                if let args = call.arguments as? Dictionary<String, Any>,

                let value = args["value"] as? Bool {
                    KB.KeyChain.isStoreUserId = value
                    result(String("success"))
                }else{
                    result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                              message: "bad args",
                                              details: nil))
                }
                return
            case CallMethod.isAutoLogin:
                result(Bool(KB.KeyChain.isAutoUserLogin))
                return
            case CallMethod.saveAutoLogin:
                if let args = call.arguments as? Dictionary<String, Any>,
                let value = args["value"] as? Bool {
                    KB.KeyChain.isAutoUserLogin = value
                    result(String("success"))
               }else{
                   result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                             message: "bad args",
                                             details: nil))
               }
               return

            default:
                result(FlutterError(code: KolonbaseErrorCode.unavailable,
                                          message: "call Method not match",
                                          details: nil))
            }
    })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
    // SSO ------- end -------------
  
    
 
}
class SwiftStreamHandler: NSObject, FlutterStreamHandler {
    func detectScreenShot(action: @escaping () -> ()) {
        let mainQueue = OperationQueue.main
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: mainQueue) { notification in
            // executes after screenshot
            action()
        }
    }
   
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let str = arguments as? String
        if str == "screen" {
                  detectScreenShot { () -> () in
                    events(true)
                  }
        }else{
            events(FlutterError(code: "ERROR_CODE",
                                 message: "Detailed message",
                                 details: nil)) // in case of
            events(FlutterEndOfEventStream)
        }
    
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}

