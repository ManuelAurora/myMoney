//
//  IncomeViewController.swift
//  myMoney
//
//  Created by Мануэль on 24.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class IncomeViewController: UIViewController
{
    var managedContext: NSManagedObjectContext!
    
    var income:  Income?
    var account: Account?
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBAction func record(sender: AnyObject) {
        
            let totalIncome  = Double(totalIncomeTextField.text!)!
            
            income = Income(withAmount: totalIncome)
            
            income!.account = account
            
            income!.conduct()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseAccount(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.type = .AccountList
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        totalIncomeTextField.becomeFirstResponder()
    }
}


