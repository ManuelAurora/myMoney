//
//  PopUpViewController + modelExtension.swift
//  myMoney
//
//  Created by Мануэль on 03.08.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit

extension PopUpViewController
{
    func showExpenseView() {
        
    }
    
    func showIncomeView() {
        
        let view = NewIncomeView.loadFromNib()
        
        view.layer.cornerRadius = 10
        view.center             = self.view.center
        view.center.y          -= 50
        
        self.view.addSubview(view)
        
        view.viewController = self
    }
    
    func showAccountView() {
        
        let view = NewAccountView.loadFromNib()
        
        view.layer.cornerRadius = 10
        view.center             = self.view.center
        view.center.y           -= 50
        
        self.view.addSubview(view)
        
        view.viewController = self
    }
    
    func addNewOrEditItem() {
        
        //Adding or editing for CheckViewController
//        
//        if let controller = presentingViewController as? CheckViewController
//        {
//            let priceString = articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
//            
//            if mode == .New
//            {
//                let articleString = TableString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
//                
//                articleString.number = controller.fetchedResultsController!.sections![0].numberOfObjects + 1
//                
//                controller.renumerateStrings()
//            }
//            else
//            {
//                guard let stringToEdit = tableString else { return }
//                
//                stringToEdit.price = Float(articlePriceTextField.text!)
//            }
//            
//            dismissViewControllerAnimated(true, completion:nil)
//        }
        
  //      Adding or editing for IncomeViewController
        
     
//        {
//            let addNewIncomeView =
//            
//            let priceString = incomeNameTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
//            
//            if mode == .New
//            {
//                _ = TableString(AddArticle: nil, intoTablePart: controller.income!.tablePart, withPrice: Float(priceString), amount: nil)
//            }
//            else
//            {
//                guard let stringToEdit = tableString else { return }
//                
//                stringToEdit.price = Double(priceString)
//            }
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//        
    }
    
    func addNewIncome(from incomeView: NewIncomeView) {
        
        if let controller = presentingViewController as? IncomeViewController
        {
            let priceString = incomeView.incomeAmountTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            
            
            
            
        }
        
    }
    
    func addNewAccount(from accountView: NewAccountView) {
        
        let tabBar = presentingViewController as! UITabBarController
        
        let controller = tabBar.viewControllers![2] as! AccountManageViewController
        
        // Creating
        
        let account = Account(withName: "\(accountView.accountNameTextField.text!)")
        
        if let balance = Double(accountView.balanceTextField.text!)
        {
            account.balance = balance         
        }
        
        if let currency = accountView.currencyLabel.text
        {
            account.currency = currency
        }
        
        // Saving to context 
        
        do
        {
            try DataManager.sharedInstance().saveContext()
            
             controller.tableView.reloadData()
        }
        catch
        {
            print("Unable to save new count")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}