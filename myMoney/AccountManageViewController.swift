//
//  CountManageViewController.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class AccountManageViewController: UIViewController
{
    
    var managedContext: NSManagedObjectContext!    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCount(sender: UIButton) {
        
        addNew()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
       tableView.registerNib(nib, forCellReuseIdentifier: "AccountCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNew() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.docType = .Count
        
        presentViewController(controller, animated: true, completion: nil)        
        
    }
}

extension AccountManageViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchData(forEntity: "Account", withSortKey: "currency").count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell") as! AccountTableViewCell
        
        let account = fetchData(forEntity: "Account", withSortKey: "currency")[indexPath.row] as! Account
        
        cell.accountNameLabel.text = account.name
        cell.accountBalanceLabel.text = "\(account.balance!.doubleValue)"
        
        return cell
    }
    
}
