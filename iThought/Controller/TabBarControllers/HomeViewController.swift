//
//  HomeViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 18/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    let tableView = UITableView()
    
    let db = Firestore.firestore()
    
    let regionCode = Locale.current.regionCode
    let defaults   = UserDefaults.standard
    
    let notFoundImage = UIImageView(image: UIImage(named: "no_posts"))
    let notFoundLabel = UILabel()
    
    let options = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet) // Delete later

    
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
        configNotFoundViews()
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
        
        notFoundLabel.text          = "We couldn't find any posts in our database in your region today, be the first to post! and share the app with people on social media and between your friends!"
        notFoundLabel.numberOfLines = 0
        notFoundLabel.textAlignment = .center
        notFoundLabel.font          = UIFont.systemFont(ofSize: 16, weight: .semibold)
        notFoundLabel.textColor     = .systemGray
    }
    func configureTableView() {
        
        tableView.register(iThoughtPostsCell.self, forCellReuseIdentifier: iThoughtPostsCell.id)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        
        tableView.delegate   = self
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
                            
                            post.postID         = document.documentID
                            post.anonymous      = document.data()["anonymous"]      as? Bool
                            post.createdAt      = document.data()["createdAt"]      as? Timestamp
                            post.disableReplies = document.data()["disableReplies"] as? Bool
                            post.likes          = document.data()["likes"]          as? Int
                            post.picture        = document.data()["picture"]        as? String
                            post.senstive       = document.data()["sensitive"]      as? Bool
                            post.text           = document.data()["text"]           as? String
                            post.userID         = document.data()["uid"]            as? String
                            post.username       = document.data()["username"]       as? String
                            
                            self.postsArray.append(post)
                        }
                    }
                    if self.postsArray.isEmpty {
                        self.notFoundImage.isHidden = false
                        self.notFoundLabel.isHidden = false
                    } else {
                        self.notFoundLabel.isHidden = true
                        self.notFoundImage.isHidden = true
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
        view.backgroundColor    = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        let composeButton       = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePost))
        composeButton.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        let refreshButton       = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
        
        navigationItem.rightBarButtonItems           = [refreshButton, composeButton]
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        configOptionsButton()
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
        present(nav, animated: true)
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
        cell.userID             = posts.userID
        cell.postID             = posts.postID
        
        cell.index = indexPath
        
        let date     = posts.createdAt!.dateValue()
        let calendar = Calendar.current
        
        let hour    = calendar.component(.hour, from: date)
        let minute  = calendar.component(.minute, from: date)
        
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
        
        cell.userImage.image    = UIImage(named: (posts.anonymous! ? "anonymous" : posts.picture ?? "loading") )
        cell.postLabel.text     = posts.text
        
        cell.commentButton.isHidden = (posts.disableReplies!)
        
        let reportPost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deletePost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        reportPost.addAction(UIAlertAction(title: "Report this Post", style: .destructive, handler: { ACTION in
            let docData: [String: Any] = [
                "reported_postID":      posts.postID  ?? "null",
                "reported_post_text":   posts.text    ?? "null",
                "reported_userID":      posts.userID  ?? "null",
                "reporter_userID":      Auth.auth().currentUser?.uid ?? "null"
            ]
            self.db.collection("reports").addDocument(data: docData)
        }))
        reportPost.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { ACTION in
            self.dismiss(animated: true, completion: nil)
        }))
        
        deletePost.addAction(UIAlertAction(title: "Delete your post?", style: .destructive, handler: { ACTION in
            self.db.collection("posts").document(posts.postID!).delete()
        }))
        deletePost.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }))
        
        cell.moreButtonTappedCallBack = {
            if Auth.auth().currentUser?.uid == posts.userID {
                self.present(deletePost, animated: true, completion: nil)
            } else {
                self.present(reportPost, animated: true, completion: nil)
            }
        }
        
        cell.likeButtonTappedCallBack = {
            
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


extension HomeViewController {
    
    func configOptionsButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "applelogo"), style: .plain, target: self, action: #selector(optionsTapped))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
        options.addAction(UIAlertAction(title: "Delete Posts Over 24H", style: .destructive, handler: { ACTION in
            self.db.collection("posts").whereField("endAt", isLessThanOrEqualTo: Date()).getDocuments { snapshot, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        for doc in snapshot.documents {
                            self.db.collection("posts").document(doc.documentID).delete()
                        }
                    }
                }
            }
        }))
        options.addAction(UIAlertAction(title: "Delete all posts", style: .destructive, handler: { ACTION in
            self.db.collection("posts").getDocuments { snapshot, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    if let snapshot = snapshot {
                        for doc in snapshot.documents {
                            self.db.collection("posts").document(doc.documentID).delete()
                        }
                    }
                }
            }
        }))
        options.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { ACTION in
            self.options.dismiss(animated: true, completion: nil)
        }))
    }
    
    @objc func optionsTapped() {
        present(options, animated: true)
    }
}
