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
        
        let result = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicates: nil) as! [Account]
        
        return result
    }()
     
    @IBOutlet weak var tableView: UITableView!
        
    @IBAction func close(_ sender: UIButton) {
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectAccount(_ sender: UIButton) {
        
        if let controller = viewController.presentingViewController as? IncomeViewController
        {
            guard let income = controller.income else { return }
            
            controller.chooseButton.setTitle(chosenAccountName, for: UIControlState())
            
            income.account = fetchAccount(withName: chosenAccountName)
        }
        
        if let controller = viewController.presentingViewController as? CheckViewController
        {
            guard let check = controller.check else { return }
            
            controller.accountButton.setTitle(chosenAccountName, for: UIControlState())
            
            check.account = fetchAccount(withName: chosenAccountName)
        }
        
        viewController.dismiss(animated: true, completion: nil)
    }
    
    class func loadFromNib() -> ChooseAccountView {
        
        let view = Bundle.main.loadNibNamed("ChooseAccountView", owner: self, options: nil)?.first! as! ChooseAccountView
        
        return view
    }
    
    override func didMoveToSuperview() {
        
        let nib = UINib(nibName: "AccountTableViewCell", bundle: nil)
        
        tableView.register(nib, forCellReuseIdentifier: "AccountCell")
        
        self.layer.cornerRadius = 10
        self.center             = viewController.view.center
        self.center.y          -= 50
    }
    
    func fetchAccount(withName name: String) -> Account {
        
        let predicate = NSPredicate(format: "name = %@", name)
        
        let account = DataManager.sharedInstance().fetchData(forEntity: "Account", withSortKey: "currency", predicates: [predicate]).first! as! Account

        return account
    }

}

extension ChooseAccountView: UITableViewDataSource, UITableViewDelegate
{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell") as! AccountTableViewCell
        
        cell.accessoryType              = .none
        cell.accountBalanceLabel.isHidden = true
        cell.accountNameLabel.text      = allAccounts[(indexPath as NSIndexPath).row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)as! AccountTableViewCell
        
        toggleCheckMark(inCell: cell)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)as! AccountTableViewCell
        
        cell.accessoryType = .none
    }
    
    func toggleCheckMark(inCell cell: AccountTableViewCell) {
        
            cell.accessoryType = .checkmark
            chosenAccountName      = cell.accountNameLabel.text!
    }
    
}
