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
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicates: nil) as! [Account]
        
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
    
    //If someone have reference at an account - delete is unable.
    func checkAccountIsPossibleTo(delete account: Account) -> Bool {
        
        let predicate = NSPredicate(format: "account=%@", account)
        
        let references = DataManager.sharedInstance().fetchData(forEntity: "Registrator", withSortKey: nil, predicates: [predicate])
        
        return references.count > 0 ? false : true
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard editingStyle == .Delete else { return }
        
        let account = accounts[indexPath.row]
        
        if checkAccountIsPossibleTo(delete: account)
        {
            managedContext.deleteObject(account)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            try! managedContext.save()
        }
        else { tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic) }
        
        //TODO: Need to make an Alarm if acc is impossible to delete
    }
    
}
