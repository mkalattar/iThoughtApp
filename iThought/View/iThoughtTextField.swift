//
//  iThoughtTextField.swift
//  iThought
//
//  Created by Mohamed Attar on 10/07/2021.
//

import UIKit

protocol TextFieldExternalDelegate {
    func checkIfTFHasText(textField: UITextField) -> Void
}

class iThoughtTextField: UIView {
    
    let textField      = UITextField()
    let textFieldTitle = UILabel()
    var symbol = ""
    let imageAttachment = NSTextAttachment()
    let fullString = NSMutableAttributedString()
    var customDelegate: TextFieldExternalDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSymbol(symbol:String) {
        self.symbol = symbol
    }
    
    init(for tTitle: String, symbol: String, placeholder: String) {
        super.init(frame: .zero)
        setSymbol(symbol: symbol)
        
        let imageIcon = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        imageAttachment.image = imageIcon
        
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: "  "))
        fullString.append(NSAttributedString(string: tTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
        
        
        
        textFieldTitle.attributedText = fullString
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.delegate = self
        configureTextField()
    }
    
    private func configureTextField() {
        addSubview(textFieldTitle)
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textFieldTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 33)
        ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.textColor = .white
        
        layer.borderWidth  = 1.5
        layer.borderColor  = UIColor.systemGray.cgColor
        layer.cornerRadius = 27
        
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        
    }
    
    func getText() -> String {
        if textField.hasText {
            return textField.text!
        } else {
            return ""
        }
    }
}


extension iThoughtTextField: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        customDelegate?.checkIfTFHasText(textField: textField)
        
        if textField.hasText {
            UIView.animate(withDuration: 0.4) {
                self.layer.borderColor = K.sColor.cgColor
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.layer.borderColor  = UIColor.systemGray.cgColor
            }
        }
    }
}
