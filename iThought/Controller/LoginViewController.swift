//
//  ViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 08/07/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let usernameTextField = iThoughtTextField(for: "Username", symbol: "person.fill", placeholder: "Enter your Username")
    let passwordTextField = iThoughtTextField(for: "Password", symbol: "lock.fill", placeholder: "Enter your Password")
    var loginButton       = iThoughtButton(bTitle: "Sign In")
    let hideShowButton    = UIButton()
    let showIcon = UIImage(systemName: "eye.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let hideIcon = UIImage(systemName: "eye.slash.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    var hidden = true
    let waitingAlert = UIAlertController(title: nil, message: "Signing In...", preferredStyle: .alert)
    let forgotPasswordAlert = UIAlertController(title: "Forgot your password?", message: "Shhh, Relax and try to remember your password.", preferredStyle: .alert)
    
    let forgotPasswordButton = UIButton()
    
    let signUpInstead = UILabel()
    let signUpButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.bColor
        title = "Sign In"
        
        
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(hideShowButton)
        view.addSubview(signUpInstead)
        view.addSubview(signUpButton)
        
        forgotPasswordAlert.view.tintColor = K.sColor
        
        setConstraints()
        loginButton.isEnabled = false
        usernameTextField.textField.textContentType = .username
        passwordTextField.textField.textContentType = .password
        passwordTextField.textField.isSecureTextEntry = true
        
        usernameTextField.customDelegate = self
        passwordTextField.customDelegate = self
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        configureButton()
        
        configureLabel()
        
        forgotPasswordAlert.addAction(UIAlertAction(title: "Thank You!", style: .default, handler: { ACTION in
            self.forgotPasswordAlert.dismiss(animated: true, completion: nil)
        }))
    }

    
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 100),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            passwordTextField.heightAnchor.constraint(equalToConstant: 100),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hideShowButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            hideShowButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -15),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            signUpInstead.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15),
            signUpInstead.leadingAnchor.constraint(equalTo: loginButton.leadingAnchor, constant: 10),
            
            signUpButton.leadingAnchor.constraint(equalTo: signUpInstead.trailingAnchor, constant: 5),
            signUpButton.centerYAnchor.constraint(equalTo: signUpInstead.centerYAnchor)
        ])
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        hideShowButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpInstead.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func showTapped() {
        hidden = (hidden == true) ? false : true
        if hidden {
            hideShowButton.setImage(showIcon, for: .normal)
            passwordTextField.textField.isSecureTextEntry = true
        } else {
            hideShowButton.setImage(hideIcon, for: .normal)
            passwordTextField.textField.isSecureTextEntry = false
        }
    }
    
    func configureButton() {
        hideShowButton.setImage(showIcon, for: .normal)
        hideShowButton.addTarget(self, action: #selector(showTapped), for: .touchUpInside)
        
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordTapped), for: .touchUpInside)
        forgotPasswordButton.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButton.setTitleColor(K.sColor, for: .normal)
        
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(K.sColor, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc func forgotPasswordTapped() {
        
        present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @objc func signUpTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    func configureLabel() {
        signUpInstead.text = "Don't have an account? Let's"
        signUpInstead.textColor = .white
    }
    
    let imageAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    @objc func loginTapped() {
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        waitingAlert.view.addSubview(loadingIndicator)
        present(waitingAlert, animated: true, completion: nil)
        
        
        
        let email = "\(usernameTextField.getText())@iThought.com"
        let password = passwordTextField.getText()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            
            self?.waitingAlert.dismiss(animated: true, completion: nil)
            
            if error != nil {
                let alert = UIAlertController(title: "Couldn't Sign In", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(HNPViewController())
        }

    }
    
    
}


extension LoginViewController: TextFieldExternalDelegate {
    func checkIfTFHasText(textField: UITextField) {
        if usernameTextField.getText() != "" && passwordTextField.getText() != "" {
            self.loginButton.lightUp()
        } else {
            self.loginButton.dimDown()
        }
    }
    
    
}
