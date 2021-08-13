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
    let db = Firestore.firestore()
    
    public func insertUser(user: iThoughtUser, id: String) {
        
        db.collection("users").document(id).setData([
            "bio": user.bio!,
            "overall_likes": user.overallLikes!,
            "overall_posts": user.overallPosts!,
            "picture": user.picture!,
            "username": user.username!
        ])
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
