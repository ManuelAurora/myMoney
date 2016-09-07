//
//  GroupFilterView.swift
//  myMoney
//
//  Created by Мануэль on 04.09.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class GroupFilterView: UIButton
{
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var groupImageView: UIImageView!
    
    private var filtered = false
    
    var selectedAsFilter: Bool {
        
        set {
            
            self.backgroundColor = newValue == true ? UIColor.cyanColor() : UIColor.whiteColor()
            
            filtered = newValue
        }
        
        get {
            return filtered
        }
    }
    
    
    override func didMoveToSuperview() {
        self.layer.cornerRadius = 10        
    }
    
    class func loadFromNib() -> GroupFilterView {
        
        let view = NSBundle.mainBundle().loadNibNamed("GroupFilterView", owner: self, options: nil).first! as! GroupFilterView
        
        return view
    }

}
