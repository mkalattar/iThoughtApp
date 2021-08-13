//
//  HNPViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 18/07/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HNPViewController: UITabBarController {
    
    
    let userID = Auth.auth().currentUser?.uid
    let currentUsr = iThoughtUser()
    
    let profilevc = ProfileViewController()
    let composeVC = ComposePostViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        //        database.child("Users").child(userID!).observe(.value) { snapshot in
        //            guard let userDic = snapshot.value as? [String: Any] else { return }
        //
        //            self.currentUsr.username = userDic["username"] as? String
        //            self.currentUsr.bio = userDic["bio"] as? String
        //            self.currentUsr.overallLikes = userDic["overall_likes"] as? Int
        //            self.currentUsr.overallPosts = userDic["overall_posts"] as? Int
        //            self.currentUsr.picture = userDic["picture"] as? String
        //
        //            self.defaults.setValue(self.currentUsr.username, forKey: "username")
        //            self.defaults.setValue(self.currentUsr.picture, forKey: "picture")
        //            self.defaults.setValue(self.currentUsr.bio, forKey: "bio")
        //            self.defaults.setValue(self.currentUsr.overallPosts, forKey: "overall_posts")
        //            self.defaults.setValue(self.currentUsr.overallLikes, forKey: "overall_likes")
        //
        //            self.composeVC.configImages()
        //            self.composeVC.configLabel()
        //            self.profilevc.printStuff()
        //
        //        }
        
        self.viewControllers = [createHomeNC(), createNotifNC(), createBookmarksNC(), createProfileNC()]
        
    }
    
    func createHomeNC() -> UINavigationController {
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        
        
        
        let imageIcon = UIImage(systemName: "house")
        let selectedImageIcon = UIImage(systemName: "house.fill")
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: imageIcon, selectedImage: selectedImageIcon)
        homeVC.tabBarItem.tag = 0
        
        return UINavigationController(rootViewController: homeVC)
    }
    
    func createNotifNC() -> UINavigationController {
        let notifNC = NotificationsViewController()
        notifNC.title = "Notifications"
        
        let imageIcon = UIImage(systemName: "bell")
        let selectedImageIcon = UIImage(systemName: "bell.fill")
        
        notifNC.tabBarItem = UITabBarItem(title: nil, image: imageIcon, selectedImage: selectedImageIcon)
        notifNC.tabBarItem.tag = 1
        
        return UINavigationController(rootViewController: notifNC)
    }
    
    
    
    func createProfileNC() -> UINavigationController {
        let profileVC = ProfileViewController()
        profileVC.title = "Profile"
        
        profileVC.userID = self.userID!
        
        let imageIcon = UIImage(systemName: "person")
        let selectedImageIcon = UIImage(systemName: "person.fill")
        
        profileVC.tabBarItem = UITabBarItem(title: nil, image: imageIcon, selectedImage: selectedImageIcon)
        profileVC.tabBarItem.tag = 3
        
        return UINavigationController(rootViewController: profileVC)
    }
    
    func createBookmarksNC() -> UINavigationController {
        let bookmarksVC = BookmarksViewController()
        bookmarksVC.title = "Bookmarks"
        
        let imageIcon = UIImage(systemName: "bookmark")
        let selectedImageIcon = UIImage(systemName: "bookmark.fill")
        
        bookmarksVC.tabBarItem = UITabBarItem(title: nil, image: imageIcon, selectedImage: selectedImageIcon)
        bookmarksVC.tabBarItem.tag = 2
        
        return UINavigationController(rootViewController: bookmarksVC)
    }
    
}
