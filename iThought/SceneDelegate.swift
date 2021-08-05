//
//  SceneDelegate.swift
//  iThought
//
//  Created by Mohamed Attar on 08/07/2021.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        UITabBar.appearance().barStyle = .default
    

        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        if Auth.auth().currentUser != nil {
            window?.rootViewController = createTabBar()
            window?.makeKeyAndVisible()
        } else {
            window?.rootViewController = createWelcomeNC()
            window?.makeKeyAndVisible()
        }
        
        
    }
    
    func createWelcomeNC() -> UINavigationController {
        let welcomeVC = WelcomeViewController()
        welcomeVC.title = "Welcome"

        return UINavigationController(rootViewController: welcomeVC)
    }
//
//    func createHomeNC() -> UINavigationController {
//        let homeVC = HomeViewController()
//        homeVC.title = "Home"
//
//        let imageIcon = UIImage(systemName: "house")
//        let selectedImageIcon = UIImage(systemName: "house.fill")
//
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: imageIcon, selectedImage: selectedImageIcon)
//        homeVC.tabBarItem.tag = 0
//
//        return UINavigationController(rootViewController: homeVC)
//    }
//
//    func createNotifNC() -> UINavigationController {
//        let notifNC = NotificationsViewController()
//        notifNC.title = "Notifications"
//
//        let imageIcon = UIImage(systemName: "bell")
//        let selectedImageIcon = UIImage(systemName: "bell.fill")
//
//        notifNC.tabBarItem = UITabBarItem(title: "Notifications", image: imageIcon, selectedImage: selectedImageIcon)
//        notifNC.tabBarItem.tag = 1
//
//        return UINavigationController(rootViewController: notifNC)
//    }
//
//    func createProfileNC() -> UINavigationController {
//        let profileVC = ProfileViewController()
//        profileVC.title = "Profile"
//
//        let imageIcon = UIImage(systemName: "person")
//        let selectedImageIcon = UIImage(systemName: "person.fill")
//
//        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: imageIcon, selectedImage: selectedImageIcon)
//        profileVC.tabBarItem.tag = 2
//
//        return UINavigationController(rootViewController: profileVC)
//    }

    func setRootViewController(_ vc: UIViewController) {
         if let window = self.window {
              window.rootViewController = vc
             UIView.transition(with: window,
                                         duration: 0.8,
                               options: .transitionFlipFromRight,
                                         animations: nil)
         }
    }
    
    func createTabBar() -> UITabBarController {
        let tabBar = HNPViewController()
//        tabBar.viewControllers = [createHomeNC(), createNotifNC(), createProfileNC()]
        
        return tabBar
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
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

