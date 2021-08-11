//
//  CompleteProfileViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 11/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CompleteProfileViewController: UIViewController {
    
    let database = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    
    
    let finishButton = iThoughtButton(bTitle: "Finish")
    let imageIconButton = UIButton()
    let bioTextView = iThoughtTextView(for: "Bio", symbol: "square.and.pencil", placeholder: "Enter your bio...")
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title = "Complete your profile"
        view.backgroundColor = K.bColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addSubview(finishButton)
        view.addSubview(imageIconButton)
        view.addSubview(bioTextView)
        view.addGestureRecognizer(tap)
                
        setConstraints()
        configureButtons()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageIconButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageIconButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageIconButton.widthAnchor.constraint(equalToConstant: 200),
            imageIconButton.heightAnchor.constraint(equalToConstant: 150),
            
            bioTextView.heightAnchor.constraint(equalToConstant: 130),
            bioTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bioTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bioTextView.topAnchor.constraint(equalTo: imageIconButton.bottomAnchor, constant: 20),
            
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 60),
            finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        imageIconButton.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        database.child("Users").child(userId!).child("picture").observeSingleEvent(of: .value) { snapshot in
//            if let pic = snapshot.value as? String {
//                self.imageIconButton.setImage(UIImage(named: pic), for: .normal)
//            }
//        }
//    }
    
    func configureButtons() {
        // imageIconButton Configurations
        imageIconButton.addTarget(self, action: #selector(imageIconButtonTapped), for: .touchUpInside)
        database.child("Users").child(userId!).child("picture").observeSingleEvent(of: .value) { snapshot in
            if let pic = snapshot.value as? String {
                self.imageIconButton.setImage(UIImage(named: pic), for: .normal)
            }
        }
        
        // finishButton Configurations
        finishButton.addTarget(self, action: #selector(finishProfile), for: .touchUpInside)
        finishButton.lightUp()
    }
    
    @objc func imageIconButtonTapped() {
        let vc = ChooseImageViewController()
        vc.title = "Choose image"
        vc.modalPresentationStyle = .fullScreen
        vc.img.image = imageIconButton.image(for: .normal) ?? UIImage(named: "male_01")
        
        present(UINavigationController(rootViewController: vc), animated: true) { [self] in
            database.child("Users").child(userId!).child("picture").observe(.value) { snapshot in
                if let pic = snapshot.value as? String {
                    self.imageIconButton.setImage(UIImage(named: pic), for: .normal)
                }
            }
        }
    }
    
    @objc func finishProfile() {
        var bio = bioTextView.getText()
        if bio == "Enter your bio..." {
            bio = ""
        }
        database.child("Users").child(userId!).child("bio").setValue(bio)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(HNPViewController())
    }
    
}



