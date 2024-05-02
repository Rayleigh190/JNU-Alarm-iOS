//
//  SceneDelegate.swift
//  JNU-Alarm
//
//  Created by 우진 on 2/5/24.
//

import UIKit
import FirebaseMessaging

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = AgreeViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("SceneDelegate - sceneWillEnterForeground()")
        
        subscribeDefaultTopic()
        unsubscribeLegacyTopic()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // 기본 topic 구독
    func subscribeDefaultTopic() {
        print("SceneDelegate - subscribeDefaultTopic()")
        let defaultTopics = ["basic", "ios"]
        for topic in defaultTopics {
            if !UserDefaults.standard.bool(forKey: topic) {
                Messaging.messaging().subscribe(toTopic: topic) { error in
                    if let error = error {
                        print("Error subscribe: \(error)")
                      } else {
                          print("Subscribed to basic topic")
                          ConfigData.set(isOn: true, topic: topic)
                      }
                }
            }
        }
    }
    
    // 서비스 종료 알림 토픽 구독 취소 처리
    func unsubscribeLegacyTopic() {
        print("SceneDelegate - unsubscribeLegacyTopic()")
        let legacyTopic = ["emergency"]
        for topic in legacyTopic {
            if UserDefaults.standard.bool(forKey: topic) {
                Messaging.messaging().unsubscribe(fromTopic: topic) { error in
                    if let error = error {
                        print("Error unsubscribe: \(error)")
                      } else {
                          print("Unsubscribed to \(topic) topic")
                          ConfigData.set(isOn: false, topic: topic)
                      }
                }
            }
            
        }
    }
}

