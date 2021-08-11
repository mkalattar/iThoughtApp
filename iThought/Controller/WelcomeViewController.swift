//
//  WelcomeViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 17/07/2021.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    let signInButton = iThoughtButton(bTitle: "Sign In")
    let signUpButton = iThoughtButton(bTitle: "Sign Up")
    
    let welcome = UILabel()
    
    let img = UIImageView(image: UIImage(named: "welcome"))
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        view.backgroundColor = K.bColor
        
        title = "Welcome"

        view.addSubview(welcome)
        view.addSubview(img)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        
        setConstraints()
        
        img.contentMode = .scaleAspectFit
        configureLabels()
        configureButtons()
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            
            welcome.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            welcome.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcome.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
//            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            img.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            img.widthAnchor.constraint(equalToConstant: 350),
//            img.heightAnchor.constraint(equalToConstant: 263),
            
            img.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            img.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            img.heightAnchor.constraint(equalTo: img.widthAnchor, multiplier: 1.333),
            img.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            
            signInButton.heightAnchor.constraint(equalToConstant: 60),
            signInButton.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -15),
            signInButton.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: signUpButton.trailingAnchor),
        ])
        welcome.translatesAutoresizingMaskIntoConstraints = false
        img.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureButtons() {
        signUpButton.lightUp()
        signUpButton.addTarget(self, action: #selector(signInOrUp), for: .touchUpInside)
        
        signInButton.lightUp()
        signInButton.addTarget(self, action: #selector(signInOrUp), for: .touchUpInside)
    }
    
    func configureLabels() {
        welcome.text = "Sign back in or sign up to share your thoughts anonymously."
        welcome.numberOfLines = 0
        welcome.font = UIFont.systemFont(ofSize: 17)
        welcome.textColor = .systemGray
    }
    
    @objc func signInOrUp(sender: iThoughtButton) {
        if sender.bTitle == "Sign In" {
            navigationController?.pushViewController(LoginViewController(), animated: true)
        } else {
            navigationController?.pushViewController(SignUpViewController(), animated: true)
        }
    }
    
}
