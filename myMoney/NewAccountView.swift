//
//  MakeNewCountView.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class NewAccountView: UIView
{        
    var viewController: PopUpViewController!
    
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var balanceTextField:   UITextField!
    @IBOutlet weak var currencyLabel:      UILabel!
    @IBOutlet weak var saveButton:         UIButton!
    
    @IBAction func close(sender: UIButton) {
     
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save(sender: UIButton) {
        
        viewController.addNewAccount(from: self)
    }
    
    class func loadFromNib() -> NewAccountView {
        
        let view = NSBundle.mainBundle().loadNibNamed("NewAccountView", owner: self, options: nil).first! as! NewAccountView
        
        return view
    }
    
    override func didMoveToSuperview() {
        
        layer.cornerRadius = 10
        self.center        = viewController.view.center
        self.center.y     -= 50
        
        accountNameTextField.becomeFirstResponder()
    }
    
    func fill(withCount count: Account) {
        
        if let balance = count.balance
        {
            balanceTextField.text   = "\(balance.doubleValue)"
        }
        
        if let currency = count.currency
        {
            currencyLabel.text      = currency
        }
        
        accountNameTextField.text = count.name
    }
    
}
