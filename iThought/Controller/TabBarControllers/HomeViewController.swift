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
    
    let postsTableView = UITableView()
    
    let db = Firestore.firestore()
    
    let regionCode = Locale.current.regionCode
    
    let notFoundImage = UIImageView(image: UIImage(named: "no_posts"))
    let notFoundLabel = UILabel()
    
    let options = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet) // Delete later
    let loadingAlert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    var postsArray = [iThoughtPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configLoadingAlert()
        
        view.addSubview(postsTableView)
        postsTableView.backgroundColor = .clear
        postsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        
        getCurrentUserData()
        configureTableView()
        setConstraints()
        configNotFoundViews()
        
    }
    
    func configLoadingAlert() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        loadingAlert.view.addSubview(loadingIndicator)
    }
    
    var currentUsername:String?
    var currentImage:String?
    func getCurrentUserData() {
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snap = snapshot {
                    self.currentUsername = snap.get("username") as? String
                    self.currentImage = snap.get("picture") as? String
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchData { _ in
            self.loadingAlert.dismiss(animated: true, completion: nil)
        }
        
        
        print("I HAVE BEEN SUMMONED")
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
            }
        }
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
        
        notFoundLabel.text          = "We couldn't find any posts in our database in your region today, be the first to post! and share the app with people on social media and between your friends!"
        notFoundLabel.numberOfLines = 0
        notFoundLabel.textAlignment = .center
        notFoundLabel.font          = UIFont.systemFont(ofSize: 16, weight: .semibold)
        notFoundLabel.textColor     = .systemGray
    }
    func configureTableView() {
        
        postsTableView.register(iThoughtPostsCell.self, forCellReuseIdentifier: iThoughtPostsCell.id)
        postsTableView.allowsSelection = false
        postsTableView.rowHeight = UITableView.automaticDimension
        postsTableView.estimatedRowHeight = 200
        
        
        postsTableView.delegate   = self
        postsTableView.dataSource = self
    }
    
    func fetchData(completion: @escaping (Bool) -> ()) {
        present(loadingAlert, animated: true, completion: nil)
        let now = Date()
        db.collection("posts")
            .order(by: "endAt", descending: true)
            .whereField("region", isEqualTo: regionCode!)
            .whereField("endAt", isGreaterThan: now)
            .whereField("sensitive", in: [!UserDefaults.standard.bool(forKey: "disableSensitive"), false] )
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
                        self.postsTableView.isHidden = true
                    } else {
                        self.notFoundLabel.isHidden = true
                        self.notFoundImage.isHidden = true
                        self.postsTableView.isHidden = false
                    }
                    
                }
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
                completion(true)
            }
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        postsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupView() {
        view.backgroundColor    = K.bColor
        let composeButton       = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composePost))
        composeButton.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        let _                   = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTableView))
        
        navigationItem.rightBarButtonItems           = [composeButton]
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        configOptionsButton()
    }
    
    @objc func refreshTableView() {
        refreshTable()
    }
    
    func refreshTable() {
        fetchData { _ in
            self.postsTableView.reloadData()
        }
    }
    
    @objc func composePost() {
        let vc = ComposePostViewController()
        
        vc.currentImage = currentImage
        vc.currentUsername = currentUsername
        
        let nav = UINavigationController(rootViewController: vc)
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
        cell.usernameLabel.setTitle((posts.anonymous! ? "Anonymous Post" : posts.username), for: .normal)
        cell.userID             = posts.userID
        cell.postID             = posts.postID
        cell.sensitive.isHidden = !(posts.senstive!)
        
        cell.index = indexPath
        
        let date     = posts.createdAt!.dateValue()
        let calendar = Calendar.current
        
        let hour    = calendar.component(.hour, from: date)
        let minute  = calendar.component(.minute, from: date)
        
        let hourString = hour < 10 ? "0\(hour)" : "\(hour)"
        let minuteString = minute < 10 ? "0\(minute)" : "\(minute)"
        
        cell.timeLabel.text = "\(hourString):\(minuteString)"
        cell.likeButton.setTitle(" \(posts.likes ?? 0)", for: .normal)
        cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        let likedPosts = self.defaults.stringArray(forKey: "likedPosts")
//
//        if let liked = likedPosts {
//            if liked.contains(posts.postID!) {
//                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            } else {
//                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//            }
//        } else {
//            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
        
        cell.userImage.setImage(UIImage(named: (posts.anonymous! ? "anonymous" : posts.picture ?? "loading") ), for: .normal)
        cell.postLabel.text     = posts.text
        
        cell.commentButton.isHidden = (posts.disableReplies!)
        
        
        let reportPost14 = UIAction(title: "Report Post", image: UIImage(systemName: "exclamationmark.bubble.fill")) { action in
            let docData: [String: Any] = [
                "reported_postID":      posts.postID  ?? "null",
                "reported_post_text":   posts.text    ?? "null",
                "reported_userID":      posts.userID  ?? "null",
                "reporter_userID":      Auth.auth().currentUser?.uid ?? "null"
            ]
            self.db.collection("reports").addDocument(data: docData)
        }
        let deletePost14 = UIAction(title: "Delete Post",image: UIImage(systemName: "trash.fill"), attributes: .destructive) { action in
            self.db.collection("posts").document(posts.postID!).delete()
        }
        let reportPostArray = [reportPost14]
        let deletePostArray = [deletePost14]
        
        
        
        cell.moreButton.showsMenuAsPrimaryAction = true
        if Auth.auth().currentUser?.uid == posts.userID {
            cell.moreButton.menu = UIMenu(title: "", children: deletePostArray)
        } else {
            cell.moreButton.menu = UIMenu(title: "", children: reportPostArray)
        }
        
        cell.profileTappedCallBack = {
            if posts.anonymous! { return }

            let profileVC = OtherUserProfileViewController()
            profileVC.userID = posts.userID
            profileVC.title = "\(posts.username!)'s Profile"
            let nav = UINavigationController(rootViewController: profileVC)
            self.present(nav, animated: true, completion: nil)
            print("I have been tapped")
        }
        
        
//        cell.likeButtonTappedCallBack = {
//            
//            var likedPosts = self.defaults.stringArray(forKey: "likedPosts")
//            
//            if let liked = likedPosts {
//                if liked.contains(posts.postID!) {
//                    return
//                }
//            }
//            
//            let postsRef = self.db.collection("posts").document(posts.postID!)
//            postsRef.updateData(["likes": FieldValue.increment(Int64(1))])
//            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            cell.likeButton.setTitle(" \(posts.likes ?? 0)", for: .normal)
//            likedPosts?.append(posts.postID!)
//            self.defaults.setValue(likedPosts, forKey:"likedPosts")
//        }
        
        return cell
    }
    
    @objc func closeProfile() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}


extension HomeViewController {
    
    func deleteOldPosts() {
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
    }
    
    func deleteAllPosts() {
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
    }
    
    func signout() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
    }
    
    func configOptionsButton() {
        let deleteAllPosts = UIAction(title: "Delete All Posts", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { action in
            self.deleteAllPosts()
        }
        let deleteOldPosts = UIAction(title: "Delete Posts Over 24H", image: UIImage(systemName: "trash.fill"), attributes: .destructive) { action in
            self.deleteOldPosts()
        }
        let signOut = UIAction(title: "Sign Out", image: UIImage(systemName: "figure.walk"), attributes: .destructive) { action in
            self.signout()
        }
        
        let actions = [deleteAllPosts, deleteOldPosts, signOut]
        
        
     
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Debug options", image: nil, primaryAction: nil, menu:  UIMenu(title: "", children: actions))
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
    }
}
