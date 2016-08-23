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
    
    var income:  Registrator?
    var account: Account?
    var presentationMode: DocumentPresentationMode!
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBAction func record(sender: AnyObject) {
        
        let totalIncome  = Double(totalIncomeTextField.text!)!
        
        income = Income(withAmount: totalIncome)
        
        income!.account = account!
        
        income!.conduct()
        
        try! DataManager.sharedInstance().saveContext()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func chooseAccount(sender: UIButton) {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.elementType = .ElementAccountListType
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseButton.setTitle(income?.account.name, forState: .Normal)
        
        totalIncomeTextField.text = income?.amount?.stringValue
        
        totalIncomeTextField.becomeFirstResponder()
    }
}


