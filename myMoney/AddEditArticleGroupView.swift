//
//  AddEditGroupView.swift
//  myMoney
//
//  Created by Мануэль on 29.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class AddEditArticleGroupView: UIView
{
    var viewController: PopUpViewController!
    var articleGroup:   ArticleGroup!
    
    @IBOutlet weak var nameTextField:      UITextField!
    @IBOutlet weak var parentChooseButton: UIButton!
    @IBOutlet weak var headerLabel:        UILabel!
    
    @IBAction func selectParent(sender: UIButton) {
        
        
        
        
    }
    
    @IBAction func saveGroup(sender: UIButton) {
        
        viewController.addEditArticleGroup(from: self)        
    }
    
    override func didMoveToSuperview() {
        
        if let articleGroup = articleGroup
        {
            nameTextField.text = articleGroup.name
        }
        
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
        
        nameTextField.becomeFirstResponder()
    }
    
    class func loadFromNib() -> AddEditArticleGroupView {
        
        let view = NSBundle.mainBundle().loadNibNamed("AddEditArticleGroupView", owner: self, options: nil).first! as! AddEditArticleGroupView
        
        return view
    }
}
