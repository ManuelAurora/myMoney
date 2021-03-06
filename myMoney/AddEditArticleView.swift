//
//  NewArticleView.swift
//  myMoney
//
//  Created by Мануэль on 10.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class AddEditArticleView: UIView
{
    var viewController: PopUpViewController!
    var article:        Article!
    
    @IBOutlet weak var articleNameLabel:      UILabel!
    @IBOutlet weak var articlePriceTextField: UITextField!
    @IBOutlet weak var addEditButton:         UIButton!
    @IBOutlet weak var articleImageView:      UIImageView!

    @IBAction func addEdit(_ sender: UIButton) {
        
        viewController.addEditArticleInTablePart(from: self)
    }
    
    @IBAction func close(_ sender: UIButton) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    override func didMoveToSuperview() {
        
        articleNameLabel.text = article.name
                
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
        
        articlePriceTextField.becomeFirstResponder()
    }
    
    class func loadFromNib() -> AddEditArticleView {
        
        let view = Bundle.main.loadNibNamed("AddEditArticleView", owner: self, options: nil)?.first! as! AddEditArticleView
        
        return view
    }
}
