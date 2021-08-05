//
//  iThoughtPasswordField.swift
//  iThought
//
//  Created by Mohamed Attar on 11/07/2021.
//

import UIKit

protocol ExternalPasswordDelegate {
    func passwordCheckerText(textField: UITextField) -> Void
}

class iThoughtPasswordField: iThoughtTextField {
    
    let hideShowButton    = UIButton()
    let showIcon = UIImage(systemName: "eye.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    let hideIcon = UIImage(systemName: "eye.slash.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    var hide = true
    var passwordDelegate: ExternalPasswordDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(for tTitle: String, symbol: String, placeholder: String) {
        super.init(for: tTitle, symbol: symbol, placeholder: placeholder)
        config()
    }
    
    private func config() {
        self.textField.isSecureTextEntry = true
        self.textField.textContentType = .newPassword
        self.textField.passwordRules = UITextInputPasswordRules(descriptor: "minlength: 6; required: lower; required: upper; required: digit; required: [-];")
        addSubview(hideShowButton)
        NSLayoutConstraint.activate([
            hideShowButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            hideShowButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
        hideShowButton.translatesAutoresizingMaskIntoConstraints = false
        hideShowButton.setImage(showIcon, for: .normal)
        hideShowButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc func buttonTapped() {
        hide = (hide == true) ? false : true
        if hide {
            hideShowButton.setImage(showIcon, for: .normal)
            self.textField.isSecureTextEntry = true
        } else {
            hideShowButton.setImage(hideIcon, for: .normal)
            self.textField.isSecureTextEntry = false
        }
    }
    
}

extension iThoughtPasswordField {
    
    
    override func textFieldDidChangeSelection(_ textField: UITextField) {
        customDelegate?.checkIfTFHasText(textField: textField)
        
        if let text = textField.text {
            if !text.isValidPassword() {
                UIView.animate(withDuration: 0.4) { [self] in
                    layer.borderColor = UIColor.systemRed.cgColor
                }
            } else {
                UIView.animate(withDuration: 0.4) { [self] in
                    layer.borderColor = UIColor(red: 123/255, green: 87/255, blue: 206/255, alpha: 1).cgColor
                }
            }
        }
       
        passwordDelegate?.passwordCheckerText(textField: textField)
        
    }
}
