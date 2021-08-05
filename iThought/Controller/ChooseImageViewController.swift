//
//  ChooseImageViewController.swift
//  iThought
//
//  Created by Mohamed Attar on 22/07/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChooseImageViewController: UIViewController {

    let database = Database.database().reference()
    let userId = Auth.auth().currentUser?.uid
    let img = UIImageView(image: UIImage(named: "male_01"))
    
    var selectedIndexPath: IndexPath?
    var selectedImage: String?
    
    var imagesArray = ["male_01", "female_01",
                       "male_02", "female_02",
                       "male_03", "female_03",
                       "male_04", "female_04",
                       "male_05", "female_05"]
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(iThoughtCollectionViewCell.self, forCellWithReuseIdentifier: iThoughtCollectionViewCell.reuseID)
        collectionView.backgroundColor = .clear
        collectionView.allowsSelection = true
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose image"
        view.backgroundColor = UIColor(red: 47/255, green: 53/255, blue: 61/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        
        view.addSubview(img)
        view.addSubview(collectionView)
        
        setConstraints()
        
        collectionView.delegate   = self
        collectionView.dataSource = self
        
    }
    
    @objc func doneTapped() {
        database.child("Users").child(userId!).child("picture").setValue(selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            img.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            img.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            img.widthAnchor.constraint(equalToConstant: 200),
            img.heightAnchor.constraint(equalToConstant: 150),
            
            collectionView.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        img.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    

}


extension ChooseImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iThoughtCollectionViewCell.reuseID, for: indexPath) as! iThoughtCollectionViewCell
        
        if selectedIndexPath != nil && indexPath == selectedIndexPath {
            cell.backgroundColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 0.3)
            selectedImage = imagesArray[indexPath.row]
        } else {
            cell.backgroundColor = .clear
            selectedImage = nil
        }
        
        cell.image.image = UIImage(named: imagesArray[indexPath.row])
        cell.image.contentMode = .scaleAspectFit
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 20, height: view.frame.width/2 - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? iThoughtCollectionViewCell {
            self.selectedIndexPath = indexPath
            img.image = cell.image.image
            cell.contentView.backgroundColor = UIColor(red: 216/255, green: 207/255, blue: 234/255, alpha: 0.3)
            selectedImage = imagesArray[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? iThoughtCollectionViewCell {
            self.selectedIndexPath = nil
            cell.contentView.backgroundColor = .clear
            selectedImage = nil
        }
    }
    
    
}
