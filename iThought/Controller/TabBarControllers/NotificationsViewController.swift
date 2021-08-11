//
//  NotificationsViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 18/07/2021.
//

import UIKit

class NotificationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.bColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Mark all as Read", style: .plain, target: self, action: #selector(markAllAsRead))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
    }
    
    @objc func markAllAsRead() {
        
    }
}
