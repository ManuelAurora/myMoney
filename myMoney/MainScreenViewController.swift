//
//  MainScreenViewController.swift
//  myMoney
//
//  Created by Мануэль on 02.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController
{
    var managedContext: NSManagedObjectContext!
    
    var accounts: [Account] {
        
       let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicate: nil) as! [Account]
        
        return result
    }
    
    @IBOutlet weak var moneyTotalTextLabel:    UILabel!
    @IBOutlet weak var incomeTextLabel:        UILabel!
    @IBOutlet weak var expensesTextLabel:      UILabel!
    @IBOutlet weak var incomeCountLabel:       UILabel!
    @IBOutlet weak var moneyTotalCountLabel:   UILabel!
    @IBOutlet weak var expensesCountLabel:     UILabel!
    @IBOutlet weak var tableView:              UITableView!
    @IBOutlet weak var periodSegmentedControl: UISegmentedControl!
    
    let articleCatalog     = AllCatalogs.sharedInstance().catalogArticle
    let catalogExpenditure = AllCatalogs.sharedInstance().catalogExpenditure
    
    @IBAction func addNewIncome(sender: UIButton) {
        addIncome()
    }
    
    @IBAction func addNewExpense(sender: UIButton) {
        addCheck()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let accountCellNib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.registerNib(accountCellNib, forCellReuseIdentifier: "AccountCell")        
    }

    override func viewWillAppear(animated: Bool) {
        
        tableView.reloadData()
        
        
        
        updateMoneyInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCheck() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Check") as! CheckViewController
        
        controller.managedContext   = managedContext
        controller.articleCatalog   = articleCatalog
        controller.checkNumber      = catalogExpenditure.allObjects().count + 1
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func addIncome() {
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("Income") as! IncomeViewController
        
        controller.managedContext = managedContext
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    func updateMoneyInfo() {
        
        var totalMoney: Double = 0
        
        for account in accounts
        {
            totalMoney += account.accountBalance()
        }
        
        moneyTotalCountLabel.text = prettyStringFrom(totalMoney)
    }
    
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return accounts.count
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let account = accounts[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell") as! AccountTableViewCell
        
        cell.accountNameLabel.text    = account.name
        cell.accountBalanceLabel.text = prettyStringFrom(account.accountBalance())
        
        return cell
    }
    
}
