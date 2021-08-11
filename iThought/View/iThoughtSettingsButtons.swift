//
//  iThoughtSettingsButtons.swift
//  iThought
//
//  Created by Mohamed Attar on 25/07/2021.
//

import UIKit

class iThoughtSettingsButtons: UIButton {
    
    var title: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(symbol: String, title: String) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: symbol)?.withTintColor(UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        self.title = title
        config()
    }
    
    
    private func config() {
        
        setTitle(title, for: .normal)
        layer.cornerRadius = 20
        
        imageEdgeInsets.left = -30
        
        titleLabel?.font   = UIFont.systemFont(ofSize: 20, weight: .semibold)
        backgroundColor = K.pColor
        setTitleColor(K.sColor, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
