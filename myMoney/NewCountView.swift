//
//  MakeNewCountView.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class NewCountView: UIView
{    
    
    var viewController: PopUpViewController!
    
    @IBOutlet weak var countNameTextField: UITextField!
    @IBOutlet weak var balanceTextField:   UITextField!
    @IBOutlet weak var currencyLabel:      UILabel!
    @IBOutlet weak var saveButton:         UIButton!
    
    @IBAction func close(sender: UIButton) {
     
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    @IBAction func save(sender: UIButton) {
        
    }
    
    class func loadFromNib() -> NewCountView {
        
        let view = NSBundle.mainBundle().loadNibNamed("NewCountView", owner: self, options: nil).first! as! NewCountView
        
        return view
    }
    
    func fill(withCount count: Count) {
        
        if let balance = count.balance
        {
            balanceTextField.text   = "\(balance.doubleValue)"
        }
        
        if let currency = count.currency
        {
            currencyLabel.text      = currency
        }
        
        countNameTextField.text = count.name
        
    }
    
    
}
