//
//  NewIncomeView.swift
//  myMoney
//
//  Created by Мануэль on 09.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class NewIncomeView: UIView
{
    var viewController: PopUpViewController! 
    
    @IBOutlet weak var incomeAmountTextField: UITextField!
    @IBOutlet weak var addNewIncomeButton:    UIButton!
    
    @IBAction func addNewIncome(sender: UIButton) {
    }
    
    @IBAction func close(sender: UIButton) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func loadFromNib() -> NewIncomeView {
        
        let view = NSBundle.mainBundle().loadNibNamed("NewIncomeView", owner: self, options: nil).first! as! NewIncomeView
        
        return view
    }
}
