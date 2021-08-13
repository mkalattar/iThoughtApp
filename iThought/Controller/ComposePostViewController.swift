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
    let db = Firestore.firestore()
    let alert = UIAlertController(title: "Please make sure to write something before posting", message: nil, preferredStyle: .alert)

    let optionsTableView = UITableView()
    
    var currentUsername: String?
    var currentImage: String?
    
    let userImageView = UIImageView()
    
    let heartIcon = UIImageView(image: UIImage(systemName: "heart")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    let commentIcon = UIImageView(image: UIImage(systemName: "quote.bubble")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    let bookmarksIcon = UIImageView(image: UIImage(systemName: "bookmark")?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal))
    
    let usernameLabel = UILabel()
    let textView = UITextView()
    
    let postView = UIView()
    let sensitiveLabel = UILabel()
    
    var anonymous = false
    var senstive = false
    var disableReplies = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Compose a Thought"
        view.backgroundColor = K.bColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post your Thought", style: .plain, target: self, action: #selector(postTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        alert.addAction(UIAlertAction(title: "Okay!", style: .cancel, handler: nil))
        
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
        
        if (textView.text == "Write something..." && textView.textColor === UIColor.systemGray) || textView.text == "" {
            present(alert, animated: true, completion: nil)
            return
        }
        
        let today = Date()
        let endAt = Calendar.current.date(byAdding: .day, value: 1, to: today)
        
        db.collection("posts").document().setData([
            "text": textView.text!,
            "likes": 0,
            "anonymous": anonymous,
            "createdAt": Date(),
            "disableReplies": disableReplies,
            "endAt": endAt!,
            "picture": currentImage!,
            "region": Locale.current.regionCode!,
            "sensitive": senstive,
            "uid": userID!,
            "username": currentUsername!
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
            
            optionsTableView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 15),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
        ])
        postView.translatesAutoresizingMaskIntoConstraints = false
        optionsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        optionsTableView.heightAnchor.constraint(equalToConstant: optionsTableView.visibleCells[0].bounds.height * 3).isActive = true
    }
    
    func configPostView() {
//        54, 47, 61
        postView.backgroundColor = UIColor(red: 54/255, green: 47/255, blue: 61/255, alpha: 1)
        postView.layer.cornerRadius = 20
        
        view.addSubview(postView)
        postView.addSubview(userImageView)
        postView.addSubview(usernameLabel)
        postView.addSubview(textView)
        postView.addSubview(heartIcon)
        postView.addSubview(commentIcon)
        postView.addSubview(bookmarksIcon)
        postView.addSubview(sensitiveLabel)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 5),
            userImageView.topAnchor.constraint(equalTo: postView.topAnchor, constant: 10),
            userImageView.widthAnchor.constraint(equalToConstant: 75),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor, multiplier: 1/1.33333),
            
            usernameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            
            sensitiveLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 10),
            sensitiveLabel.bottomAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: -3),
            
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
        sensitiveLabel.translatesAutoresizingMaskIntoConstraints = false
        
        configImages()
        configLabel()
        configTextView()
    }
    
    func configImages() {
        let pic = currentImage
        userImageView.image = UIImage(named: pic ?? "loading")
    }
    
    func configLabel() {
        let username = currentUsername
        usernameLabel.text = username
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        sensitiveLabel.textColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        sensitiveLabel.backgroundColor = .systemGray2
        sensitiveLabel.clipsToBounds = true
        sensitiveLabel.layer.cornerRadius = 3
        sensitiveLabel.text = " SENSITIVE "
        sensitiveLabel.font = UIFont.systemFont(ofSize: 12)
        sensitiveLabel.isHidden = true
    }
    
    func configTextView() {
        textView.isScrollEnabled = true
        textView.text = "Write something..."
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .systemGray
    }
    
    func configTableView() {
        view.addSubview(optionsTableView)
        
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
        optionsTableView.allowsSelection = false
        optionsTableView.layer.cornerRadius = 18
        optionsTableView.isScrollEnabled = false
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
                sensitiveLabel.isHidden = false
            } else {
                senstive = false
                sensitiveLabel.isHidden = true
            }
        } else {
            if sender.isOn {
                anonymous = true
                userImageView.image = UIImage(named: "anonymous")
                usernameLabel.text = "Anonymous post"
            } else {
                anonymous = false
                userImageView.image = UIImage(named: currentImage ?? "loading")
                usernameLabel.text = currentUsername
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
        cell.backgroundColor = K.pColor
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
