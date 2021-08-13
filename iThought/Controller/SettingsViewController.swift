//
//  SettingsViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 21/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase
import StoreKit

class SettingsViewController: UIViewController {
    
    //    let signOut = iThoughtSettingsButtons(symbol: "arrowshape.turn.up.left.fill", title: "Sign out")
    let settingsTableView = UITableView(frame: .zero, style: .grouped)
    
    let defaults = UserDefaults.standard
    
    let settingsNames = [ ["Edit Profile", "Delete All My Posts"], ["Disable Sensitive Content"], ["Sign Out", "Delete My Account"], ["Rate this app", "Report a bug", "Request a feature", "FAQ"] ]
    let headerTitles = ["Profile Settings", "Feed Settings", "Account Settings", "Feedback"]
    let db = Firestore.firestore()
    let deleteAccountAlert = UIAlertController(title: "Are you sure you want to delete your account?", message: nil, preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.bColor
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
        title = "Settings"
        
        deleteAccountAlert.view.tintColor = K.sColor
        deleteAccountAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        deleteAccountAlert.addAction(UIAlertAction(title: "Yes Delete My Account", style: .destructive, handler: { action in
            let signInAlert = UIAlertController(title: "Please sign in to confirm this operation", message: nil, preferredStyle: .alert)
            
            signInAlert.addTextField { usernameTextField in
                usernameTextField.placeholder = "Username"
                usernameTextField.returnKeyType = .next
                usernameTextField.keyboardType = .emailAddress
            }
            signInAlert.addTextField { passwordTextField in
                passwordTextField.placeholder = "Password"
                passwordTextField.returnKeyType = .continue
                passwordTextField.isSecureTextEntry = true
            }
            signInAlert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { _ in
                guard let fields = signInAlert.textFields, fields.count == 2 else {
                    let errorAlert = UIAlertController(title: "Please make sure you entered both Username and Password", message: nil, preferredStyle: .alert)
                    errorAlert.view.tintColor = K.sColor
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    return
                }
                let usernameF = fields[0]
                let passwordF = fields[1]
                
                guard let username = usernameF.text, !username.isEmpty, let password = passwordF.text, !password.isEmpty else {
                    let errorAlert = UIAlertController(title: "Please make sure you entered both Username and Password", message: nil, preferredStyle: .alert)
                    errorAlert.view.tintColor = K.sColor
                    errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                    return
                }
                self.login(usern: username, password: password)
            }))
            signInAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            
            self.present(signInAlert, animated: true, completion: nil)
        }))
        
        configTableView()
        setConstraints()
        
    }
    func login(usern: String, password: String) {
        let email = "\(usern)@ithought.com"
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if error != nil {
                let alert = UIAlertController(title: "Couldn't Sign In", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                return
            }
            self?.deleteAccount()
        }
    }
    func deleteAccount() {
        let user = Auth.auth().currentUser
        let userid = user?.uid
        
        user?.delete { error in
          if let error = error {
            print(error.localizedDescription)
          } else {
            self.db.collection("users").document(userid!).delete()
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
          }
        }
        
    }
    
    func configTableView() {
        view.addSubview(settingsTableView)
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.allowsSelection = true
        settingsTableView.isScrollEnabled = true
        settingsTableView.allowsMultipleSelection = false
        settingsTableView.backgroundColor = .clear
    }
    
    @objc func doneTapped () {
        self.dismiss(animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(UINavigationController(rootViewController: WelcomeViewController()))
    }
    
    @objc func switchTapped(_ sender: UISwitch) {
        if sender.tag == 0 {
            if sender.isOn {
                defaults.setValue(true, forKey: "disableSensitive")
            } else {
                defaults.setValue(false, forKey: "disableSensitive")
            }
        }
    }
    
    func rateThisApp() {
        let alert = UIAlertController(title: "Are you loving this app?", message: nil, preferredStyle: .alert)
        alert.view.tintColor = K.sColor
        
        alert.addAction(UIAlertAction(title: "Yes, I am lovin' it!", style: .default, handler: { [self]_ in
            guard let scene = view.window?.windowScene else {
                print("no scene")
                return
            }
            SKStoreReviewController.requestReview(in: scene)
        }))
        alert.addAction(UIAlertAction(title: "No, I am not.", style: .default, handler: { _ in
            //
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsNames[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        
        cell.backgroundColor = K.pColor
        cell.textLabel!.text = settingsNames[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = K.sColor
        
        let settingsSwitch = UISwitch()
        settingsSwitch.setOn(UserDefaults.standard.bool(forKey: "disableSensitive"), animated: true)
        settingsSwitch.tag = 0
        settingsSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        settingsSwitch.onTintColor = K.sColor
        
        
        switch cell.textLabel?.text {
        // Edit Profile
        case settingsNames[0][0]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "pencil")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Delete all my posts
        case settingsNames[0][1]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "trash.fill")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Delete My Account
        case settingsNames[2][1]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "person.fill.badge.minus")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Rate this app
        case settingsNames[3][0]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "hand.thumbsup.fill")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Allow Sensitive Content
        case settingsNames[1][0]:
            cell.accessoryView = settingsSwitch
            cell.selectionStyle = .none
        // Report a Bug
        case settingsNames[3][1]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "exclamationmark.bubble.fill")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Request a feature
        case settingsNames[3][2]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "figure.wave")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // FAQ
        case settingsNames[3][3]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "questionmark.diamond.fill")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        // Sign Out
        case settingsNames[2][0]:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "figure.walk")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
        default:
            cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.forward")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
            cell.selectionStyle = .default
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        switch cell.textLabel?.text {
        
        // Delete All Posts
        case settingsNames[0][1]:
            db.collection("posts")
                .whereField("uid", isEqualTo: Auth.auth().currentUser!.uid)
                .getDocuments { snapshot, error in
                    if let e = error {
                        print(e.localizedDescription)
                    } else {
                        if let snap = snapshot {
                            for doc in snap.documents {
                                self.db.collection("posts").document(doc.documentID).delete()
                            }
                        }
                    }
                }
            dismiss(animated: true, completion: nil)
            
        // Sign Out
        case settingsNames[2][0]:
            signOut()
            print("IT WORKS")
            
        // Report a Bug
//        case settingsNames[3][1]:
//            db.collection("bugs").addDocument(data: <#T##[String : Any]#>)
        
        // Delete account
        case settingsNames[2][1]:
            present(deleteAccountAlert, animated: true, completion: nil)
            
        // Rate this app
        case settingsNames[3][0]:
            rateThisApp()
            
            
        default:
            print("Something went wrong")
        }
    }
    
}


extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
