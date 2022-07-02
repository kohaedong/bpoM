////
////  FCMAppDelegate.swift
////  Kolonbase
////
////  Created by mk on 2020/11/12.
////
//
//import Foundation
//import Firebase
//
//@main
//class FCMAppDelegate: UIResponder, UIApplicationDelegate {
//	
//	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//		
//		// 파이어베이스 설정
//		FirebaseApp.configure()ㅌ
//		Messaging.messaging().delegate = self
//		
//		// APNS 설정
//		UNUserNotificationCenter.current().delegate = self
//		
//		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//		UNUserNotificationCenter.current().requestAuthorization(
//			options: authOptions,
//			completionHandler: {_, _ in })
//		application.registerForRemoteNotifications()
//		
//		return true
//	}
//	
//	// MARK: UISceneSession Lifecycle
//	
//	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//		
//		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//	}
//	
//	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
//	
//}
//
//// MARK: - APNS: FCM 메시지 처리
//extension FCMAppDelegate: UNUserNotificationCenterDelegate {
//	
//	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//		
//		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//		print("==== didRegisterForRemoteNotificationsWithDeviceToken ====")
//		print(deviceTokenString)
//		
//		// 파이어베이스 - FCM 받아오기
//		Messaging.messaging().apnsToken = deviceToken
//	}
//	
//	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//		
//		print("Unable to register for remote notifications: \(error.localizedDescription)")
//	}
//	
//	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//		
//		//print(userInfo)
//		
//		// 파이어베이스 - FCM 메시지 처리
//		if let messageID = userInfo["gcm.message_id"] {
//			
//			print("didReceiveRemoteNotification: - Message ID: \(messageID)")
//		}
//		
//		if let messageType = userInfo["type"] as? String {
//			
//			print("didReceiveRemoteNotification: - Message Type: \(messageType)")
//			
//			switch messageType {
//				
//				case "logout":
//					print("didReceiveRemoteNotification: - FCM Message: Log Out")
//					
//				default:
//					break
//			}
//		}
//	}
//	
//	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//					 fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//		
//		//print(userInfo)
//		
//		if let messageID = userInfo["gcm.message_id"] as? String {
//			
//			print("fetchCompletionHandler: - Message ID: \(messageID)")
//		}
//		
//		// 파이어베이스 - FCM 알림 처리: 다른 기기에서 로그인 할 경우에 받는 메시지 처리
//		if let messageType = userInfo["type"] as? String {
//			
//			print("fetchCompletionHandler: - Message Type: \(messageType)")
//			
//			switch messageType {
//				
//				case "logout":
//					print("fetchCompletionHandler: - FCM Message: Log Out")
//					
//				default:
//					break
//			}
//		}
//		
//		completionHandler(UIBackgroundFetchResult.newData)
//	}
//	
//	func userNotificationCenter(_ center: UNUserNotificationCenter,
//								willPresent notification: UNNotification,
//								withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//		
//		let userInfo = notification.request.content.userInfo
//		//print(userInfo)
//		
//		if let messageID = userInfo["gcm.message_id"] {
//			
//			print("willPresent:withCompletionHandler: - Message ID: \(messageID)")
//		}
//		
//		completionHandler([.alert, .sound])
//	}
//	
//	func userNotificationCenter(_ center: UNUserNotificationCenter,
//								didReceive response: UNNotificationResponse,
//								withCompletionHandler completionHandler: @escaping () -> Void) {
//		
//		let userInfo = response.notification.request.content.userInfo
//		//print(userInfo)
//		
//		if let messageID = userInfo["gcm.message_id"] {
//			print("didReceive:withCompletionHandler: - Message ID: \(messageID)")
//		}
//		
//		completionHandler()
//	}
//}
//
//// MARK: - 파이어베이스: FCM 등록 메시지
//extension FCMAppDelegate: MessagingDelegate {
//	
//	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//		
//		print("Firebase registration token: \(fcmToken)")
//		
//		let dataDict: [String: String] = ["token": fcmToken]
//		NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//	}
//	
//	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//		
//		print("Firebase didReceive :", messaging)
//	}
//	
//}
