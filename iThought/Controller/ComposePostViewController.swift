//
//  ComposePostViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 01/08/2021.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ComposePostViewController: UIViewController {

    let database = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    let defaults = UserDefaults.standard
    let db = Firestore.firestore()

    let tableView = UITableView()
    
//    var currentUsr = iThoughtUser()
    
    let userImageView = UIImageView()
    
    let heartIcon = UIImageView(image: UIImage(systemName: "heart")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    let commentIcon = UIImageView(image: UIImage(systemName: "quote.bubble")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    let bookmarksIcon = UIImageView(image: UIImage(systemName: "bookmark")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    
    let usernameLabel = UILabel()
    let textView = UITextView()
    
    let postView = UIView()
    
    var anonymous = false
    var senstive = false
    var disableReplies = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compose a Thought"
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post your Thought", style: .plain, target: self, action: #selector(postTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
//        database.child("Users").child(userID!).observe(.value) { snapshot in
//            guard let userDic = snapshot.value as? [String: Any] else { return }
//
//            self.currentUsr.username = userDic["username"] as? String
//            self.currentUsr.bio = userDic["bio"] as? String
//            self.currentUsr.overallLikes = userDic["overall_likes"] as? Int
//            self.currentUsr.overallPosts = userDic["overall_posts"] as? Int
//            self.currentUsr.picture = userDic["picture"] as? String
//
//            self.configImages()
//            self.configLabel()
//        }
                
        self.hideKeyboardWhenTappedAround()
        
//        view.addSubview(composePostTextView)
        configPostView()
        configTableView()
        setConstraints()
        
        textView.delegate = self
    }
    
    @objc func postTapped() {
        
        if textView.text == "" {
            // alert
        }
        
        let today = Date()
        let endAt = Calendar.current.date(byAdding: .day, value: 1, to: today)
        
        // Add a new document in collection "cities"
        db.collection("posts").document().setData([
            "text": textView.text!,
            "likes": 0,
            "anonymous": anonymous,
            "createdAt": Date(),
            "disableReplies": disableReplies,
            "endAt": endAt!,
            "picture": defaults.string(forKey: "picture")!,
            "region": Locale.current.regionCode!,
            "sensitive": senstive,
            "uid": userID!,
            "username": defaults.string(forKey: "username")!
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        self.dismiss(animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            postView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            postView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            postView.heightAnchor.constraint(equalToConstant: 210),
            
            tableView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        //        composePostTextView.translatesAutoresizingMaskIntoConstraints = false
        postView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.heightAnchor.constraint(equalToConstant: tableView.visibleCells[0].bounds.height * 3).isActive = true
    }
    
    func configPostView() {
//        54, 47, 61
        postView.backgroundColor = UIColor(red: 54/255, green: 47/255, blue: 61/255, alpha: 1)
        postView.layer.cornerRadius = 27
        
        view.addSubview(postView)
        postView.addSubview(userImageView)
        postView.addSubview(usernameLabel)
        postView.addSubview(textView)
        postView.addSubview(heartIcon)
        postView.addSubview(commentIcon)
        postView.addSubview(bookmarksIcon)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 5),
            userImageView.topAnchor.constraint(equalTo: postView.topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 75),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1/1.33333),
            
            usernameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            
            heartIcon.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 25),
            heartIcon.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -15),
            
            commentIcon.leadingAnchor.constraint(equalTo: heartIcon.trailingAnchor, constant: 20),
            commentIcon.centerYAnchor.constraint(equalTo: heartIcon.centerYAnchor),
            
            bookmarksIcon.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -25),
            bookmarksIcon.centerYAnchor.constraint(equalTo: heartIcon.centerYAnchor),
            
            textView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 5),
            textView.leadingAnchor.constraint(equalTo: userImageView.leadingAnchor, constant: 10),
            textView.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -5),
            textView.bottomAnchor.constraint(equalTo: heartIcon.topAnchor, constant: -5)
        ])
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        heartIcon.translatesAutoresizingMaskIntoConstraints = false
        commentIcon.translatesAutoresizingMaskIntoConstraints = false
        bookmarksIcon.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        configImages()
        configLabel()
        configTextView()
    }
    
    func configImages() {
        let pic = defaults.string(forKey: "picture")
        userImageView.image = UIImage(named: pic ?? "loading")
    }
    
    func configLabel() {
        let username = defaults.string(forKey: "username")
        usernameLabel.text = username
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    func configTextView() {
        textView.isScrollEnabled = true
        textView.text = "Write something..."
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .systemGray
    }
    
    func configTableView() {
        view.addSubview(tableView)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 18
        tableView.isScrollEnabled = false
    }
    
    @objc func switchTapped(_ sender: UISwitch) {
        if sender.tag == 0 {
            if sender.isOn {
                disableReplies = true
                commentIcon.isHidden = true
            } else {
                disableReplies = false
                commentIcon.isHidden = false
            }
        } else if sender.tag == 1 {
            if sender.isOn {
                senstive = true
            } else {
                senstive = false
            }
        } else {
            if sender.isOn {
                anonymous = true
                userImageView.image = UIImage(named: "anonymous")
                usernameLabel.text = "Anonymous post"
            } else {
                anonymous = false
                userImageView.image = UIImage(named: defaults.string(forKey: "picture") ?? "loading")
                usernameLabel.text = defaults.string(forKey: "username")
            }
        }
    }

}

let settingsName = ["Disable Replies", "Senstive Content (NSFW, swearing)", "Anonymous"]

extension ComposePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsName.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
//        cell.backgroundColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 0.5)
//        54, 47, 61
        cell.backgroundColor = UIColor(red: 54/255, green: 47/255, blue: 61/255, alpha: 1)
        cell.textLabel!.text = "\(settingsName[indexPath.row])"
        
        let settingsSwitch = UISwitch()
        settingsSwitch.setOn(false, animated: true)
        settingsSwitch.tag = indexPath.row
        settingsSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        settingsSwitch.onTintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
        
        cell.accessoryView = settingsSwitch
        
        return cell
    }
}

extension ComposePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write something..."
            textView.textColor = .systemGray
        }
    }
}
