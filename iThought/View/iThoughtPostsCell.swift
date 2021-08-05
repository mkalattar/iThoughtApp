//
//  iThoughtPostsCell.swift
//  iThought
//
//  Created by Mohamed Attar on 03/08/2021.
//

import UIKit
import Firebase


protocol TableViewButtonClicked {
    func likeButtonClicked(index: Int)
}

class iThoughtPostsCell: UITableViewCell {
    
    static let id = "postsCell"
    var posts = iThoughtPost()
    
    var postID: String?
    var userID: String?
    
    var cellDelegate: TableViewButtonClicked?
    var index: IndexPath?
    
    var buttonTapCallback: () -> ()  = { }
    
    let db = Firestore.firestore()
    
    let postView = UIView()
    
    let userImage = UIImageView()
    let usernameLabel = UILabel()
    let timeLabel = UILabel()
    let reportButton = UIButton()
    let postLabel = UILabel()
    let likeButton = UIButton()
    let commentButton = UIButton()
    let bookmarkButton = UIButton()
    
    let color = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
//
//    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        
        backgroundColor = .clear
                
        configureView()
        configureImage()
        configureLabels()
        configureButtons()
        setConstraints()
        
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        addSubview(postView)
        postView.backgroundColor = UIColor(red: 54/255, green: 47/255, blue: 61/255, alpha: 1)
        postView.layer.cornerRadius = 17
    }
    
    func configureButtons() {
        postView.addSubview(likeButton)
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
//        likeButton.setTitle(" \(posts.likes ?? 0)", for: .normal)
        likeButton.tintColor = color
        
        postView.addSubview(commentButton)
        commentButton.setImage(UIImage(systemName: "quote.bubble"), for: .normal)
        commentButton.tintColor = color
        
//        if posts.disableReplies ?? false {
//            commentButton.isHidden = true
//        } else {
//            commentButton.isHidden = false
//        }
        
        postView.addSubview(bookmarkButton)
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.tintColor = color
        
        postView.addSubview(reportButton)
        reportButton.setImage(UIImage(systemName: "exclamationmark.triangle.fill"), for: .normal)
        reportButton.tintColor = color
    }
    func configureLabels() {
        // usernameLabel
        postView.addSubview(usernameLabel)
//        if posts.anonymous ?? false {
//            usernameLabel.text = "Anonymous user"
//        } else {
//            usernameLabel.text = posts.username
//        }
        usernameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        // postLabel
        postView.addSubview(postLabel)
//        postLabel.text = posts.text
        postLabel.font = UIFont.systemFont(ofSize: 15)
        postLabel.numberOfLines = 0
        
        postView.addSubview(timeLabel)
//        timeLabel.text = "\(posts.createdAt ?? Date())"
        timeLabel.textColor = .systemGray
    }
    
    func configureImage() {
        postView.addSubview(userImage)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            postView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            postView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            postView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            postView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            userImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 5),
            userImage.topAnchor.constraint(equalTo: postView.topAnchor, constant: 10),
            userImage.widthAnchor.constraint(equalToConstant: 75),
            userImage.heightAnchor.constraint(equalTo: userImage.widthAnchor, multiplier: 1/1.33333),
            
            usernameLabel.topAnchor.constraint(equalTo: userImage.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 10),
            
            likeButton.leadingAnchor.constraint(equalTo: postView.leadingAnchor, constant: 19),
            likeButton.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -15),
            likeButton.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 15),
            
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 20),
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            bookmarkButton.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -20),
            bookmarkButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            
            reportButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            reportButton.centerXAnchor.constraint(equalTo: bookmarkButton.centerXAnchor),
            
            timeLabel.bottomAnchor.constraint(equalTo: userImage.bottomAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            
            postLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 5),
            postLabel.leadingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: 15),
            postLabel.trailingAnchor.constraint(equalTo: postView.trailingAnchor, constant: -5),
        ])
        
        postView.translatesAutoresizingMaskIntoConstraints = false
        userImage.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func likeTapped() {
        buttonTapCallback()
        cellDelegate?.likeButtonClicked(index: index!.row)
    }
    
}
