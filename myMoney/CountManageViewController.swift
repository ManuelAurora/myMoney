//
//  CountManageViewController.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class CountManageViewController: UIViewController
{

    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCount(sender: UIButton) {
        
        addNew()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addNew() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        presentViewController(controller, animated: true, completion: nil)
        
        
    }
}
