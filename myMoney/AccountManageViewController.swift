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
    
    @IBAction func addNewCount(_ sender: UIButton) {
        
        addNew()
        
    }
    
    func addNew() {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpViewController
        
        controller.elementType = .elementAccountType
        
        present(controller, animated: true, completion: nil)
        
    }
    
    //If someone have reference at an account - delete is unable.
    func checkAccountIsPossibleTo(delete account: Account) -> Bool {
        
        let predicate = NSPredicate(format: "account=%@", account)
        
        let references = DataManager.sharedInstance().fetchData(forEntity: "Registrator", withSortKey: nil, predicates: [predicate])
        
        return references.count > 0 ? false : true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "AccountCell")
        
    }
}

extension AccountManageViewController: UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountTableViewCell
        
        let account = accounts[(indexPath as NSIndexPath).row]
        
        cell.accountNameLabel.text    = account.name
        cell.accountBalanceLabel.text = prettyStringFrom(account.accountBalance())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let account = accounts[(indexPath as NSIndexPath).row]
        
        if checkAccountIsPossibleTo(delete: account)
        {
            managedContext.delete(account)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            try! managedContext.save()
        }
        else { tableView.reloadRows(at: [indexPath], with: .automatic) }
        
        //TODO: Need to make an Alarm if acc is impossible to delete
    }
    
}
