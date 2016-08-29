//
//  ArticleCollectionViewCell.swift
//  myMoney
//
//  Created by Мануэль on 29.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var articleNameLabel: UILabel!
    
    override func didMoveToSuperview() {
        
        self.layer.cornerRadius = 10
        
    }
    
}

