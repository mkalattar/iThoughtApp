//
//  DatabaseManager.swift
//  iThought
//
//  Created by Mohamed Attar on 21/07/2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import Firebase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let database = Database.database().reference()
    let currentUsr = iThoughtUser()
    let userID = Auth.auth().currentUser?.uid
    
    public func insertUser(user: iThoughtUser, id: String) {
        database.child("Users").child(id).setValue([
            "bio": user.bio!,
            "overall_likes": user.overallLikes!,
            "overall_posts": user.overallPosts!,
            "picture": user.picture!,
            "username": user.username!
        ])
    }
    
    public func getCurrentUsr() -> iThoughtUser {
        database.child("Users").child(userID!).observe(.value) { snapshot in
            if let userInfo = snapshot.value as? [String:Any] {
                self.currentUsr.username = userInfo["username"] as? String
                self.currentUsr.picture = userInfo["picture"] as? String
                self.currentUsr.bio = userInfo["bio"] as? String
                self.currentUsr.overallLikes = userInfo["overall_likes"] as? Int
                self.currentUsr.overallPosts = userInfo["overall_posts"] as? Int
            }
        }
        return currentUsr
    }
    
    public func getCurrentUser(vc: ProfileViewController) {
        database.child("Users").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? NSDictionary
            
            vc.bio = value?["bio"] as? String ?? "error"
            vc.overallLikes = value?["overall_likes"] as? Int ?? -1
            vc.overallPosts = value?["overall_posts"] as? Int ?? -1
            vc.picture = value?["picture"] as? String ?? "error"
            vc.username = value?["username"] as? String ?? "error"
        })
    }
    
}


class iThoughtUser {
    var bio: String?
    var overallLikes: Int?
    var overallPosts: Int?
    var picture: String?
    var username: String?
    
    init(bio: String, overallLikes: Int, overallPosts: Int, picture: String, username: String) {
        self.bio = bio
        self.username = username
        self.overallPosts = overallPosts
        self.overallLikes = overallLikes
        self.picture = picture
    }
    init() {}
}



class iThoughtPost {
    
    init(){}
    
    var text: String?
    var likes: Int?
    var anonymous: Bool?
    var createdAt: Timestamp?
    var disableReplies: Bool?
    var picture: String?
    var senstive: Bool?
    var userID: String?
    var username: String?
    var postID: String?
}
