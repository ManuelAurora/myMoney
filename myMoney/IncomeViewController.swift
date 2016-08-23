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
    
    var presentationMode: DocumentPresentationMode = .DocumentNewMode
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var dateLabel:    UILabel!
    
    @IBAction func record(sender: AnyObject) {
       
        guard let income = income else { return }
        
        let totalIncome  = Double(totalIncomeTextField.text!)!
        
        income.amount  = totalIncome
        
        switch presentationMode
        {
        case .DocumentEditMode:
            
            income.deleteOldRegisterLine()
            income.conduct()
            
        case .DocumentNewMode:
            
            income.conduct()
        }               
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let name = income?.account.name
        {
            chooseButton.setTitle(name, forState: .Normal)
        }
        
        totalIncomeTextField.text = income!.amount == 0 ? "" : income?.amount?.stringValue
        
        dateLabel.text = prettyStringFrom(income!.date)
        
        totalIncomeTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        switch presentationMode
        {
        case .DocumentEditMode:
            
            recordButton.setTitle("Save", forState: .Normal)
            
        case .DocumentNewMode:
            
            income = Income(withAmount: 0)
            
            recordButton.setTitle("Add", forState: .Normal)
        }
    }
}


