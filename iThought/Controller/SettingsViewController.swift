//
//  SettingsViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 21/07/2021.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    let signOut = iThoughtSettingsButtons(symbol: "arrowshape.turn.up.left.fill", title: "Sign out")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        title = "Settings"
        view.addSubview(signOut)
        
        setConstraints()
        configureButtons()
    }
    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            signOut.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signOut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signOut.heightAnchor.constraint(equalToConstant: 60),
            signOut.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
        
    }
    
    func configureButtons() {
        signOut.addTarget(self, action: #selector(signOutt), for: .touchUpInside)
    }
    
    @objc func signOutt() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
    }

}
