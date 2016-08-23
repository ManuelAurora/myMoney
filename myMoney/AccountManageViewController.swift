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
    
    var accounts: [Account] {
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicate: nil) as! [Account]
        
        return result
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addNewCount(sender: UIButton) {
        
        addNew()
        
    }
    
    func addNew() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("PopUpController") as! PopUpViewController
        
        controller.elementType = .ElementAccountType
        
        presentViewController(controller, animated: true, completion: nil)        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "AccountCell")
        
    }
}

extension AccountManageViewController: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell") as! AccountTableViewCell
        
        let account = accounts[indexPath.row]
        
        cell.accountNameLabel.text    = account.name
        cell.accountBalanceLabel.text = prettyStringFrom(account.accountBalance())
        
        return cell
    }
    
}
