//
//  HomeViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 18/07/2021.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    
    let db = Firestore.firestore()
    
    let regionCode = Locale.current.regionCode
    
    let defaults = UserDefaults.standard

    
    var postsArray = [iThoughtPost]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        fetchData { _ in
//            self.tableView.reloadData()
        }
        configureTableView()
        setConstraints()

    }
    
    
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        fetchData { done in
//            if done {
//                self.tableView.reloadData()
//            } else {
//                print("something happened")
//            }
//        }
//    }
//
    func configureTableView() {
        
        tableView.register(iThoughtPostsCell.self, forCellReuseIdentifier: iThoughtPostsCell.id)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    func loadMessages() {
//        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapshot, error) in
//            self.messages = []
//            if let e = error {
//                print(e)
//            } else {
//                if let snapshotDocument = querySnapshot?.documents {
//                    for doc in snapshotDocument {
//                        let data            = doc.data()
//                        if let sender       = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
//                            let newMessage  = Message(sender: sender, body: messageBody)
//                            self.messages.append(newMessage)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    func fetchData(completion: @escaping (Bool) -> ()) {
        let now = Date()
        db.collection("posts")
            .order(by: "endAt", descending: true)
            .whereField("region", isEqualTo: regionCode!)
            .whereField("endAt", isGreaterThan: now)
            .addSnapshotListener { snapshot, error in
            if let e = error {
                print("ERROR: \(e.localizedDescription)")
            } else {
                self.postsArray.removeAll()
                if let snapshotDoc = snapshot?.documents {
                    for document in snapshotDoc {
                        
                        let post = iThoughtPost()

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

                        self.postsArray.append(post)

                    }
                }
            }
            DispatchQueue.main.async {
                  self.tableView.reloadData()
            }
            completion(true)
        }
//        tableView.reloadData()
        
//        .getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//
//                    let post = iThoughtPost()
//
//                    post.postID = document.documentID
//                    post.anonymous = document.data()["anonymous"] as? Bool
//                    post.createdAt = document.data()["createdAt"] as? Timestamp
//                    post.disableReplies = document.data()["disableReplies"] as? Bool
//                    post.likes = document.data()["likes"] as? Int
//                    post.picture = document.data()["picture"] as? String
//                    post.senstive = document.data()["sensitive"] as? Bool
//                    post.text = document.data()["text"] as? String
//                    post.userID = document.data()["uid"] as? String
//                    post.username = document.data()["username"] as? String
//
//                    self.postsArray.append(post)
//                }
//            }
//            completion(true)
//        }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupView() {
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePost))
        composeButton.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
        navigationItem.rightBarButtonItems = [refreshButton, composeButton]
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)

    }
    
    @objc func refreshTableView() {
        refreshTable()
    }
    
    func refreshTable() {
        fetchData { _ in
            self.tableView.reloadData()
        }
    }
    
    @objc func composePost() {
        let nav = UINavigationController(rootViewController: ComposePostViewController())
        present(nav, animated: true) {
//            self.tableView.reloadData()
        }
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: iThoughtPostsCell.id, for: indexPath) as! iThoughtPostsCell
                
        let posts = postsArray[indexPath.row]
        cell.usernameLabel.text = (posts.anonymous! ? "Anonymous Post" : posts.username)
        cell.userID = posts.userID
        cell.postID = posts.postID
        
        cell.index = indexPath
        
        let date = posts.createdAt!.dateValue()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        cell.timeLabel.text = "\(hour):\(minute)"
        cell.likeButton.setTitle(" \(posts.likes ?? 0)", for: .normal)
        
        let likedPosts = self.defaults.stringArray(forKey: "likedPosts")
        
        if let liked = likedPosts {
            if liked.contains(posts.postID!) {
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.userImage.image = UIImage(named: (posts.anonymous! ? "anonymous" : posts.picture ?? "loading") )
        cell.postLabel.text = posts.text
        
        cell.commentButton.isHidden = (posts.disableReplies!)
        
        cell.buttonTapCallback = {
            
            var likedPosts = self.defaults.stringArray(forKey: "likedPosts")
            
            if let liked = likedPosts {
                if liked.contains(posts.postID!) {
                    return
                }
            }
            
            let postsRef = self.db.collection("posts").document(posts.postID!)
            postsRef.updateData(["likes": FieldValue.increment(Int64(1))])
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.likeButton.setTitle(" \(posts.likes ?? 0)", for: .normal)
            likedPosts?.append(posts.postID!)
            self.defaults.setValue(likedPosts, forKey:"likedPosts")
        }
        return cell
    } 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}
