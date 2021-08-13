//
//  iThoughtTextView.swift
//  iThought
//
//  Created by Mohamed Attar on 12/07/2021.
//

import UIKit

class iThoughtTextView: UIView {
    
    let textView = UITextView()
    let textFieldTitle = UILabel()
    let imageAttachment = NSTextAttachment()
    let fullString = NSMutableAttributedString()
    var customDelegate: TextViewExternalDelegate?
    var placeholder = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(for tTitle: String, symbol: String, placeholder: String) {
        super.init(frame: .zero)
        textView.delegate = self
        self.placeholder = placeholder
        
        let imageIcon = UIImage(systemName: symbol)?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        imageAttachment.image = imageIcon
        
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: "  "))
        fullString.append(NSAttributedString(string: tTitle, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]))
        
        
        
        textFieldTitle.attributedText = fullString
        
        configureTextView()
    }
    
    func getText() -> String {
        if textView.hasText {
            return textView.text!
        } else {
            return ""
        }
    }
    
    private func configureTextView() {
        addSubview(textFieldTitle)
        addSubview(textView)
        
        textView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            textFieldTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            textView.topAnchor.constraint(equalTo: textFieldTitle.bottomAnchor)
        ])
        textView.translatesAutoresizingMaskIntoConstraints = false
        textFieldTitle.translatesAutoresizingMaskIntoConstraints = false
        
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.text = placeholder
        textView.textColor = UIColor.lightGray
        
        layer.borderWidth  = 1.5
        layer.borderColor  = UIColor.systemGray.cgColor
        layer.cornerRadius = 27
        
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .no
//        textView.keyboardType = .default
        textView.isScrollEnabled = true
        
    }
    
    

}

protocol TextViewExternalDelegate {
    
}

extension iThoughtTextView: UITextViewDelegate {
    

    func textViewDidChangeSelection(_ textView: UITextView) {
      
        if textView.hasText && textView.text != placeholder {
            UIView.animate(withDuration: 0.4) {
                self.layer.borderColor = K.sColor.cgColor
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.layer.borderColor  = UIColor.systemGray.cgColor
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .white
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
}
