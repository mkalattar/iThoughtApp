//
//  BookmarksViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 25/07/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class BookmarksViewController: UIViewController {

    let notFoundImage = UIImageView(image: UIImage(named: "no_posts"))
    let notFoundLabel = UILabel()
    
    let userID = Auth.auth().currentUser?.uid
    let database = Database.database().reference()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.bColor
        loadBookmarks()
        configNotFoundViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }
    
    func loadBookmarks() {
        
        db.collection("bookmarks")
            .order(by: "createdAt", descending: true)
            .whereField("uid", isEqualTo: userID!)
            .addSnapshotListener { snapshot, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshot = snapshot?.documents {
                        if snapshot.isEmpty {
                            self.notFoundImage.isHidden = false
                            self.notFoundLabel.isHidden = false
                        } else {
                            self.notFoundImage.isHidden = true
                            self.notFoundLabel.isHidden = true
                        }
                    }
                }
            }
        
//        database.child("Users").child(userID!).child("bookmarks").observe(.value) { snapshot in
//            if let _ = snapshot.value as? String {
//
//            } else {
//                self.notFoundImage.isHidden = false
//                self.notFoundLabel.isHidden = false
//            }
//        }
    }
    
    func configNotFoundViews() {
        view.addSubview(notFoundImage)
        view.addSubview(notFoundLabel)
        
        NSLayoutConstraint.activate([
            notFoundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notFoundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notFoundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notFoundImage.heightAnchor.constraint(equalTo: notFoundImage.widthAnchor, multiplier: 1/1.333333),
            
            notFoundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            notFoundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            notFoundLabel.topAnchor.constraint(equalTo: notFoundImage.bottomAnchor, constant: 10)
        ])
        notFoundImage.translatesAutoresizingMaskIntoConstraints = false
        notFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        notFoundImage.isHidden = true
        notFoundLabel.isHidden = true
        
        notFoundLabel.text = "Oops, We couldn't find any bookmarked posts. To bookmark posts, press the bookmark icon on any post and it should appear here."
        notFoundLabel.numberOfLines = 0
        notFoundLabel.textAlignment = .center
        notFoundLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        notFoundLabel.textColor = .systemGray
    }
    

}
