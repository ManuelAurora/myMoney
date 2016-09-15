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
    
    var presentationMode: DocumentPresentationMode = .documentNewMode
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var dateLabel:    UILabel!
    
    @IBAction func record(_ sender: AnyObject) {
       
        guard let income = income else { return }
        
        let totalIncome  = Double(totalIncomeTextField.text!)!
        
        income.amount  = totalIncome as NSNumber?
        
        switch presentationMode
        {
        case .documentEditMode:
            
            income.deleteOldRegisterLine()
            income.conduct()
            
        case .documentNewMode:
            
            income.conduct()
        }               
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        managedContext.rollback()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseAccount(_ sender: UIButton) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        controller.elementType = .elementAccountListType
        
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let account = income?.account
        {
            chooseButton.setTitle(account.name, for: UIControlState())
        }
        else
        {
            let mainAcc = Account.mainAccount()
            
            chooseButton.setTitle("\(mainAcc.name)", for: UIControlState())
            
            income?.account = mainAcc
        }
        
        totalIncomeTextField.text = income!.amount == 0 ? "" : income?.amount?.stringValue
        
        dateLabel.text = prettyStringFrom(income!.date)
        
        totalIncomeTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        switch presentationMode
        {
        case .documentEditMode:
            
            recordButton.setTitle("Save", for: UIControlState())
            
        case .documentNewMode:
            
            income = Income(withAmount: 0)
            
            recordButton.setTitle("Add", for: UIControlState())
        }
    }
}


