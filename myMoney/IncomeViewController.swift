//
//  IncomeViewController.swift
//  myMoney
//
//  Created by Мануэль on 24.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class IncomeViewController: CoreDataTableViewController
{
    
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBAction func record(sender: AnyObject) {
        
    }
     
    
    @IBAction func cancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNew(sender: AnyObject) {
        
    }
}

