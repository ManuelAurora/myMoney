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
    
    @IBAction func record(sender: AnyObject) {
        
        income = Income(withAmount: Double(totalIncomeTextField.text!)!)
        
        try! managedContext.save()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
          
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


