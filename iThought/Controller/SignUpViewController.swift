//
//  SignUpViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 11/07/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    let newUsernameTextField = iThoughtTextField(for: "Username", symbol: "person.fill", placeholder: "Choose a new Username")

    let newPasswordTextField = iThoughtPasswordField(for: "Password", symbol: "lock.fill", placeholder: "Choose a secure Password")
    let signUpButton = iThoughtButton(bTitle: "Sign Up")
    let loginInstead = UILabel()
    let loginButton = UIButton()

    let passwordChecker = UILabel()
    let waitingAlert = UIAlertController(title: nil, message: "Signing up...", preferredStyle: .alert)


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign up"
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        
        view.addSubview(newUsernameTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(signUpButton)
        view.addSubview(loginInstead)
        view.addSubview(loginButton)
        view.addSubview(passwordChecker)
        
        setConstraints()
        
        newPasswordTextField.passwordDelegate = self
        newUsernameTextField.customDelegate = self
        
        configureLabel()
        configButton()
        
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            newUsernameTextField.heightAnchor.constraint(equalToConstant: 100),
            newUsernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            newUsernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            newUsernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 100),
            newPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            newPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            newPasswordTextField.topAnchor.constraint(equalTo: newUsernameTextField.bottomAnchor, constant: 30),
  
            passwordChecker.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 10),
            passwordChecker.leadingAnchor.constraint(equalTo: newPasswordTextField.leadingAnchor),
            passwordChecker.trailingAnchor.constraint(equalTo: newPasswordTextField.trailingAnchor),
            
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),
            
            loginInstead.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 15),
            loginInstead.leadingAnchor.constraint(equalTo: signUpButton.leadingAnchor, constant: 10),
            
            loginButton.leadingAnchor.constraint(equalTo: loginInstead.trailingAnchor, constant: 5),
            loginButton.centerYAnchor.constraint(equalTo: loginInstead.centerYAnchor)
        ])
        newUsernameTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        loginInstead.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        passwordChecker.translatesAutoresizingMaskIntoConstraints = false
    }
    

    @objc func signUpTapped() {
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        loadingIndicator.tintColor = UIColor(red: 123/255, green: 87/255, blue: 206/255, alpha: 1)
        
        waitingAlert.view.addSubview(loadingIndicator)
        present(waitingAlert, animated: true, completion: nil)
        
        let username = "\(newUsernameTextField.getText())@iThought.com"
        let password = newPasswordTextField.getText()
        
        Auth.auth().createUser(withEmail: username, password: password) { authResult, error in
            
            self.waitingAlert.dismiss(animated: true, completion: nil)
            
            if error != nil {
                let alert = UIAlertController(title: "Couldn't Sign Up", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            DatabaseManager.shared.insertUser(user: iThoughtUser(bio: "", overallLikes: 0, overallPosts: 0, picture: "male_01", username: self.newUsernameTextField.getText().lowercased()), id: DatabaseManager.shared.userID!)
            
            
            let alert = UIAlertController(title: "You signed up Successfully!", message: "Now let's complete your profile", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Let's Go!", style: .default, handler: { ACTION in
                self.navigationController?.pushViewController(CompleteProfileViewController(), animated: true)
            }))
            alert.view.tintColor = UIColor(red: 123/255, green: 87/255, blue: 206/255, alpha: 1)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func configureLabel() {
        loginInstead.text = "Have an account?"
        loginInstead.textColor = .white
        
        passwordChecker.text = "Make sure your password has at least 6 characters and includes at least a capital letter (A-Z), a digit (0-9) and a special character."
        passwordChecker.font = UIFont.systemFont(ofSize: 15)
        passwordChecker.textColor = .systemRed
        passwordChecker.isHidden = true
        passwordChecker.numberOfLines = 0
        passwordChecker.textAlignment = .justified
    }
    
    func configButton() {
        
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        loginButton.setTitle("Log back in", for: .normal)
        loginButton.setTitleColor(UIColor(red: 123/255, green: 87/255, blue: 206/255, alpha: 1), for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func loginButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}


extension SignUpViewController: TextFieldExternalDelegate, ExternalPasswordDelegate {
    

    func checkIfTFHasText(textField: UITextField) {
        
        if (newUsernameTextField.getText() != "") && (newPasswordTextField.getText().isValidPassword()) {
            signUpButton.lightUp()
        } else {
            signUpButton.dimDown()
        }
        
    }
    
    func passwordCheckerText(textField: UITextField) {
        
        if (newUsernameTextField.getText() != "") && (newPasswordTextField.getText().isValidPassword()) {
            signUpButton.lightUp()
        } else {
            signUpButton.dimDown()
        }
        
        if newPasswordTextField.getText() != "" && !newPasswordTextField.getText().isValidPassword() {
            UIView.animate(withDuration: 0.4) { [self] in
                passwordChecker.isHidden = false
            }
        } else if newPasswordTextField.getText() != "" && newPasswordTextField.getText().isValidPassword() {
            UIView.animate(withDuration: 0.4) { [self] in
                passwordChecker.isHidden = true
            }
        }
        
    }
    
   
}
