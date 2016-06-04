//
//  AddNewconsumption  AddNewItemOfExpenditureViewController.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class AddNewItemOfExpenditureViewController: UIViewController {

    var managedContext: NSManagedObjectContext!
    
    let catalogOfExpenditure = AllCatalogs.sharedInstance().catalogExpenditure
    
    @IBOutlet weak var name:                UITextField!
    @IBOutlet weak var useQuantityAndPrice: UISwitch!
    @IBOutlet weak var parentButton:        UIButton!
    
    @IBAction func AddNew(sender: UIButton) {
        
        let article = Expenditure(name: name.text!)
        
        DataManager.sharedInstance().saveEntity(article)
        
        catalogOfExpenditure.items.append(article)
                
        let controller = self.presentingViewController as! CheckViewController
        
        controller.tileButtons()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addGroup(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
