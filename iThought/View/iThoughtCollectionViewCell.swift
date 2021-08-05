//
//  iThoughtCollectionViewCell.swift
//  iThought
//
//  Created by Mohamed Attar on 24/07/2021.
//

import UIKit

class iThoughtCollectionViewCell: UICollectionViewCell {
    static let reuseID = "customCell"
    let image = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        addSubview(image)
        contentView.layer.cornerRadius = 30
        
        image.bounds = contentView.bounds
        
        image.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: image.frame.width*1.33333).isActive = true
        image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true 
        
        image.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
}
