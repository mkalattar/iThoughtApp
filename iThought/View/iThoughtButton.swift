//
//  iThoughtButton.swift
//  iThought
//
//  Created by Mohamed Attar on 10/07/2021.
//

import UIKit

class iThoughtButton: UIButton {
    
    var bTitle: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(bTitle: String) {
        super.init(frame: .zero)
        self.bTitle = bTitle
        
        setTitle(bTitle, for: .normal)
        configure()
    }
    
    func lightUp() {
        UIView.animate(withDuration: 0.4) { [self] in
            backgroundColor = K.pColor
            setTitleColor(K.sColor, for: .normal)
            layer.borderColor = K.sColor.cgColor
//            layer.borderWidth = 0.2

            layer.borderWidth = 0
            isEnabled = true
        }
    }
    
    func dimDown() {
        UIView.animate(withDuration: 0.4) { [self]  in
            isEnabled = false
            layer.borderWidth = 2
            layer.borderColor = UIColor.systemGray.cgColor
            setTitleColor(.systemGray, for: .normal)
            backgroundColor = .clear
        }
    }
    
    private func configure() {
        dimDown()
        layer.cornerRadius = 20
        titleLabel?.font   = UIFont.systemFont(ofSize: 20, weight: .semibold)
        layer.borderColor  = UIColor.systemGray.cgColor
        layer.borderWidth  = 2
        setTitleColor(.systemGray, for: .normal)
    }

}
