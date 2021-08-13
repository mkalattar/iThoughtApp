//
//  ProfileViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 18/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: UIViewController {
    
    //    let signOut = UIButton()
    let defaults = UserDefaults.standard
    let userPostsTableView = UITableView()
    var postsArray = [iThoughtPost]()
    let db = Firestore.firestore()
    
    var userID: String?
    
    let profileImg = UIImageView()
    let usernameLabel = UILabel()
    let bioLabel = UILabel()
    
    let heartIcon = UIImageView(image: UIImage(systemName: "heart.fill")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    let dividerIcon = UIImageView(image: UIImage(systemName: "poweron")?.withTintColor(.white, renderingMode: .alwaysOriginal))
    let postsIcon = UIImageView(image: UIImage(systemName: "text.quote")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    
    let likesLabel = UILabel()
    let postsLabel = UILabel()
    
    let activePostsLabel = UILabel()
    let refreshButton = UIButton()
    
    let vc = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        
        view.addSubview(profileImg)
        view.addSubview(usernameLabel)
        view.addSubview(bioLabel)
        view.addSubview(heartIcon)
        view.addSubview(dividerIcon)
        view.addSubview(postsIcon)
        view.addSubview(likesLabel)
        view.addSubview(postsLabel)
        view.addSubview(activePostsLabel)
        view.addSubview(userPostsTableView)
        userPostsTableView.backgroundColor = .clear
        userPostsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        fetchData { _ in
            self.userPostsTableView.reloadData()
        }
        
        setConstraints()
        configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getUserData()
    }
    
    func getUserData() {
        print(userID!)
        DatabaseManager.shared.db.collection("users").document(userID!).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                if let snap = snapshot {
                    self.usernameLabel.text = snap.get("username") as? String
                    self.bioLabel.text = snap.get("bio") as? String
//                    self.likesLabel.text = "\(snap.get("overall_likes") as? Int ?? 0)"
//                    self.postsLabel.text = "\(snap.get("overall_posts") as? Int ?? 0)"
                    self.profileImg.image = UIImage(named: snap.get("picture") as? String ?? "loading")
                }
            }
        }
    }
    
    func configureTableView() {
        
        userPostsTableView.register(iThoughtPostsCell.self, forCellReuseIdentifier: iThoughtPostsCell.id)
        userPostsTableView.allowsSelection = false
        userPostsTableView.rowHeight = UITableView.automaticDimension
        userPostsTableView.estimatedRowHeight = 200
        
        
        userPostsTableView.delegate = self
        userPostsTableView.dataSource = self
    }
    
    func fetchData(completion: @escaping (Bool) -> ()) {
        let now = Date()
        //        let endAt = Calendar.current.date(byAdding: .day, value: 1, to: now)
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
                            self.postsArray.append(post)
                        }
                    }
                    self.likesLabel.text = "\(likes)"
                    self.postsLabel.text = "\(posts)"
                }
                completion(true)
            }
    }
    
    func setupView() {
        view.backgroundColor = K.bColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settings))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            //            profileImg.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            //            profileImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            profileImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImg.widthAnchor.constraint(equalToConstant: 150),
            profileImg.heightAnchor.constraint(equalTo: profileImg.widthAnchor, multiplier: 1/1.3333),
            
            //            usernameLabel.leadingAnchor.constraint(equalTo: profileImg.trailingAnchor, constant: 10),
            //            usernameLabel.topAnchor.constraint(equalTo: profileImg.topAnchor),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo: profileImg.bottomAnchor, constant: 15),
            
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            dividerIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dividerIcon.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5),
            
            likesLabel.trailingAnchor.constraint(equalTo: dividerIcon.leadingAnchor, constant: -8),
            likesLabel.centerYAnchor.constraint(equalTo: dividerIcon.centerYAnchor),
            
            heartIcon.trailingAnchor.constraint(equalTo: likesLabel.leadingAnchor, constant: -5),
            heartIcon.centerYAnchor.constraint(equalTo: dividerIcon.centerYAnchor),
            
            postsIcon.leadingAnchor.constraint(equalTo: dividerIcon.trailingAnchor, constant: 8),
            postsIcon.centerYAnchor.constraint(equalTo: dividerIcon.centerYAnchor),
            
            postsLabel.leadingAnchor.constraint(equalTo: postsIcon.trailingAnchor, constant: 5),
            postsLabel.centerYAnchor.constraint(equalTo: dividerIcon.centerYAnchor),
            
            activePostsLabel.topAnchor.constraint(equalTo: dividerIcon.bottomAnchor, constant: 20),
            activePostsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            userPostsTableView.topAnchor.constraint(equalTo: activePostsLabel.bottomAnchor, constant: 10),
            userPostsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userPostsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userPostsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        dividerIcon.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        postsIcon.translatesAutoresizingMaskIntoConstraints = false
        postsLabel.translatesAutoresizingMaskIntoConstraints = false
        activePostsLabel.translatesAutoresizingMaskIntoConstraints = false
        userPostsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let waitingAlert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    func loadLoadingAlert() {
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        waitingAlert.view.addSubview(loadingIndicator)
        present(waitingAlert, animated: true, completion: nil)
    }
    
    
    func configImg() {
//        profileImg.image = UIImage(named: picture ?? "loading")
        profileImg.contentMode = .scaleAspectFit
    }
    
    func configLabels() {
//        usernameLabel.text = username ?? "Error"
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
//        bioLabel.text = bio ?? "Error"
        bioLabel.textColor = .systemGray
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        
//        likesLabel.text = "\(overallLikes ?? 0)"
//        postsLabel.text = "\(overallPosts ?? 0)"
        
        activePostsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        activePostsLabel.text = "Active Posts"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configImg()
        configLabels()
    }
    
//    func printStuff() {
//        username = defaults.string(forKey: "username")
//        picture = defaults.string(forKey: "picture")
//        bio = defaults.string(forKey: "bio")
//        overallPosts = defaults.integer(forKey: "overall_posts")
//        overallLikes = defaults.integer(forKey: "overall_likes")
//
//        print("username: \(username ?? "Error")")
//        print("picture: \(picture ?? "Error")")
//        print("bio: \(bio ?? "Error")")
//        print("Overall Posts: \(overallPosts ?? -1)")
//        print("Overall Likes: \(overallLikes ?? -1)")
//
//        configImg()
//        configLabels()
//        //        waitingAlert.dismiss(animated: true, completion: nil)
//    }
    
    @objc func settings() {
        //        navigationController?.pushViewController(SettingsViewController(), animated: true)
        let settingsNC = UINavigationController(rootViewController: SettingsViewController())
        present(settingsNC, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        cell.userImage.setImage(UIImage(named: (posts.anonymous! ? "anonymous" : posts.picture ?? "loading") ), for: .normal) 
        cell.postLabel.text     = posts.text
        
        cell.commentButton.isHidden = (posts.disableReplies!)
        
        let reportPost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deletePost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
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
        
        
        if #available(iOS 14.0, *) {
            cell.moreButton.showsMenuAsPrimaryAction = true
            if Auth.auth().currentUser?.uid == posts.userID {
                cell.moreButton.menu = UIMenu(title: "", children: deletePostArray)
            } else {
                cell.moreButton.menu = UIMenu(title: "", children: reportPostArray)
            }
        } else {
            cell.moreButtonTappedCallBack = {
                if Auth.auth().currentUser?.uid == posts.userID {
                    self.present(deletePost, animated: true, completion: nil)
                } else {
                    self.present(reportPost, animated: true, completion: nil)
                }
            }
        }
        
        
        reportPost.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { ACTION in
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
    
    
}

