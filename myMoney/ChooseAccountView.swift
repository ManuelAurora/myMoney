//
//  NewIncomeView.swift
//  myMoney
//
//  Created by Мануэль on 09.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit

class ChooseAccountView: UIView
{
    var viewController: PopUpViewController!
    
    var chosenAccountName = "Choose"    
     
    lazy var allAccounts: [Account] = {
        
        let result = fetchData(forEntity: "Account", withSortKey: "currency", predicate: nil) as! [Account]
        
        return result
    }()
     
    @IBOutlet weak var tableView: UITableView!
        
    @IBAction func close(sender: UIButton) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectAccount(sender: UIButton) {
        
        if let controller = viewController.presentingViewController as? IncomeViewController
        {
            guard let income = controller.income else { return }
            
            controller.chooseButton.setTitle(chosenAccountName, forState: .Normal)
            
            income.account = fetchAccount(withName: chosenAccountName)
        }
        
        if let controller = viewController.presentingViewController as? CheckViewController
        {
            guard let check = controller.check else { return }
            
            controller.accountButton.setTitle(chosenAccountName, forState: .Normal)
            
            check.account = fetchAccount(withName: chosenAccountName)
        }
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    class func loadFromNib() -> ChooseAccountView {
        
        let view = NSBundle.mainBundle().loadNibNamed("ChooseAccountView", owner: self, options: nil).first! as! ChooseAccountView
        
        return view
    }
    
    override func didMoveToSuperview() {
        
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "AccountCell")
        
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
    }
    
    func fetchAccount(withName name: String) -> Account {
        
        let predicate = NSPredicate(format: "name = %@", name)
        
        let account = fetchData(forEntity: "Account", withSortKey: "currency", predicate: predicate).first! as! Account

        return account
    }

}

extension ChooseAccountView: UITableViewDataSource, UITableViewDelegate
{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allAccounts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell") as! AccountTableViewCell
        
        cell.accessoryType              = .None
        cell.accountBalanceLabel.hidden = true
        cell.accountNameLabel.text      = allAccounts[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)as! AccountTableViewCell
        
        toggleCheckMark(inCell: cell)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)as! AccountTableViewCell
        
        cell.accessoryType = .None
    }
    
    func toggleCheckMark(inCell cell: AccountTableViewCell) {
        
            cell.accessoryType = .Checkmark
            chosenAccountName      = cell.accountNameLabel.text!
    }
    
}
