//
//  SettingsViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 21/07/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SettingsViewController: UIViewController {
    
    //    let signOut = iThoughtSettingsButtons(symbol: "arrowshape.turn.up.left.fill", title: "Sign out")
    let settingsTableView = UITableView(frame: .zero, style: .grouped)
    
    let defaults = UserDefaults.standard
    
    let settingsNames = [ ["Edit Profile", "Delete All My Posts"], ["Allow Sensitive Content"], ["Sign Out", "Delete My Account"] ]
    let headerTitles = ["Profile Settings", "Feed Settings", "Account Settings"]
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = K.bColor
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1)
        
        title = "Settings"
        
        
        
        configTableView()
        setConstraints()
        
    }
    
    func configTableView() {
        view.addSubview(settingsTableView)
        
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.allowsSelection = true
        settingsTableView.layer.cornerRadius = 18
        settingsTableView.isScrollEnabled = false
        settingsTableView.allowsMultipleSelection = false
        settingsTableView.backgroundColor = .clear
    }
    
    @objc func doneTapped () {
        self.dismiss(animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
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
                defaults.setValue(true, forKey: "allowSensitive")
            } else {
                defaults.setValue(false, forKey: "allowSensitive")
            }
        }
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
        settingsSwitch.setOn(true, animated: true)
        settingsSwitch.tag = 0
        settingsSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        settingsSwitch.onTintColor = K.sColor
        
        
        
        
        if cell.textLabel?.text == settingsNames[1][0] {
            cell.accessoryView = settingsSwitch
            cell.selectionStyle = .none
        } else {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.forward")?.withTintColor(K.sColor, renderingMode: .alwaysOriginal))
            cell.selectionStyle = .default
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        switch cell.textLabel?.text {
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
        case settingsNames[2][0]:
            signOut()
            print("IT WORKS")
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
