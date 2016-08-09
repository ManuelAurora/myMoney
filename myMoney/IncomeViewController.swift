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
    
    var income: Income?
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBAction func record(sender: AnyObject) {
        
        guard chooseButton.titleLabel!.text != "Choose" else { return }        
        
        let predicate = NSPredicate(format: "name = %@", chooseButton.titleLabel!.text!)
        
        let account = fetchData(forEntity: "Account", withSortKey: "currency", predicate: predicate).first! as! Account
        
        let totalIncome  = Double(totalIncomeTextField.text!)!
        let accountTotal = account.balance!.doubleValue
        let result       = accountTotal + totalIncome
        
        income = Income(withAmount: totalIncome )
        
        income?.account = account
        
        account.balance! = result
        
        try! managedContext.save()
        
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


