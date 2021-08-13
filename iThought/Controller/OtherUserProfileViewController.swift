//
//  OtherUserProfileViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 12/08/2021.
//

import UIKit
import Firebase

class OtherUserProfileViewController: ProfileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData { _ in
            //
        }
    }
    
    override func setupView() {
        view.backgroundColor = K.bColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissProfile))
    }
    
    @objc func dismissProfile() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func fetchData(completion: @escaping (Bool) -> ()) {
        let now = Date()
        db.collection("posts")
            .whereField("uid", isEqualTo: userID!)
            .whereField("endAt", isGreaterThan: now)
            .order(by: "endAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let e = error {
                    print("ERROR: \(e.localizedDescription)")
                } else {
                    var likes = 0
                    var posts = 0
                    self.postsArray.removeAll()
                    if let snapshotDoc = snapshot?.documents {
                        for document in snapshotDoc {
                            
                            let post = iThoughtPost()
                            
                            posts+=1
                            
                            post.postID = document.documentID
                            post.anonymous = document.data()["anonymous"] as? Bool
                            post.createdAt = document.data()["createdAt"] as? Timestamp
                            post.disableReplies = document.data()["disableReplies"] as? Bool
                            post.likes = document.data()["likes"] as? Int
                            post.picture = document.data()["picture"] as? String
                            post.senstive = document.data()["sensitive"] as? Bool
                            post.text = document.data()["text"] as? String
                            post.userID = document.data()["uid"] as? String
                            post.username = document.data()["username"] as? String
                            
                            likes += post.likes!
                            if !post.anonymous! {
                                self.postsArray.append(post)
                            }
                            
                        }
                    }
                    self.likesLabel.text = "\(likes)"
                    self.postsLabel.text = "\(posts)"
                }
                completion(true)
            }
    }
    
    
    
}
