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
    let tableView = UITableView()
    var postsArray = [iThoughtPost]()
    let db = Firestore.firestore()
    
    let userID = Auth.auth().currentUser?.uid

    
    var picture: String?
    var username: String?
    var bio: String?
    var overallLikes: Int?
    var overallPosts: Int?
    
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
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
  
        setConstraints()
        configureTableView()
        printStuff()
        tableView.reloadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        tableView.reloadData()
//    }
    
    func configureTableView() {
        
        tableView.register(iThoughtPostsCell.self, forCellReuseIdentifier: iThoughtPostsCell.id)
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        
        tableView.delegate = self
        tableView.dataSource = self
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
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
//        view.backgroundColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
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
            
            tableView.topAnchor.constraint(equalTo: activePostsLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        profileImg.image = UIImage(named: defaults.string(forKey: "picture") ?? "loading")
        profileImg.contentMode = .scaleAspectFit
        
    }
    
    func configLabels() {
        usernameLabel.text = defaults.string(forKey: "username")
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        bioLabel.text = defaults.string(forKey: "bio")
        bioLabel.textColor = .systemGray
        bioLabel.numberOfLines = 0
        bioLabel.textAlignment = .center
        
        likesLabel.text = "\(defaults.integer(forKey: "overall_likes"))"
        postsLabel.text = "\(defaults.integer(forKey: "overall_posts"))"
        
        activePostsLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        activePostsLabel.text = "Active Posts"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configImg()
        configLabels()
        fetchData { _ in
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    func printStuff() {
        username = defaults.string(forKey: "username")
        picture = defaults.string(forKey: "picture")
        bio = defaults.string(forKey: "bio")
        overallPosts = defaults.integer(forKey: "overall_posts")
        overallLikes = defaults.integer(forKey: "overall_likes")
        
        print("username: \(username ?? "Error")")
        print("picture: \(picture ?? "Error")")
        print("bio: \(bio ?? "Error")")
        print("Overall Posts: \(overallPosts ?? -1)")
        print("Overall Likes: \(overallLikes ?? -1)")
        
        configImg()
        configLabels()
//        waitingAlert.dismiss(animated: true, completion: nil)
    }
    
    @objc func settings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        let reportPost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deletePost = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        reportPost.addAction(UIAlertAction(title: "Report this Post", style: .destructive, handler: { ACTION in
            let docData: [String: Any] = [
                "reported_postID": posts.postID ?? "null",
                "reported_post_text": posts.text ?? "null",
                "reported_userID": posts.userID ?? "null",
                "reporter_userID": Auth.auth().currentUser?.uid ?? "null"
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
    
    
}

