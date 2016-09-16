//
//  PictureSelectionView.swift
//  myMoney
//
//  Created by Мануэль on 16.09.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class PictureSelectionView: UIView
{
    var viewController: PopUpViewController!
    var pictures: Pictures!
    var selectedImage: UIImage? {
        didSet
        {
            guard let image = selectedImage else { return }
            viewController.recieveSelectedImage(_: image)
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func close(_ sender: UIButton) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func didMoveToSuperview() {
        
        makeLayout()
        
        let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: "PictureCell")
        
        layer.cornerRadius = 10
        
        self.center = viewController.view.center
        
        collectionView.dataSource = self
        collectionView.delegate   = self
    }
    
    private func makeLayout() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing      = 4
        
        let size = floor(self.bounds.width / 5)
        
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView.collectionViewLayout = layout
    }    
    
    
    class func loadFromNib() -> PictureSelectionView {
        
        let view = Bundle.main.loadNibNamed("PictureSelectionView", owner: self, options: nil)?.first! as! PictureSelectionView
        
        return view
    }
    
}

extension PictureSelectionView: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as! PictureCollectionViewCell
        
        cell.pictureImageView.image = pictures.list[indexPath.row]
        
        return cell
    }
    
}

extension PictureSelectionView: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedImage = pictures.list[indexPath.row]
    }
}
