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
    func showArticleView() {
        
        let view = AddEditArticleView.loadFromNib()
        
        view.viewController = self
        view.article        = article
        
        self.view.addSubview(view)
    }
    
    func chooseAccountView() {
        
        let view = ChooseAccountView.loadFromNib()
        
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    func showAccountView() {
        
        let view = NewAccountView.loadFromNib()
        
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    func addEditArticleInTablePart(from articleView: AddEditArticleView) {
        
        //Adding or editing for CheckViewController
        
        if let controller = presentingViewController as? CheckViewController
        {
            let priceString =  articleView.articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            if elementPresentationMode == .ElementNewMode
            {
                let articleString = TableString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
                
                articleString.number = controller.fetchedResultsController!.sections![0].numberOfObjects + 1
               
            }
            else
            {
                guard let stringToEdit = tableString else { return }
                
                stringToEdit.price = Float(articleView.articlePriceTextField.text!)
            }
            
            dismissViewControllerAnimated(true, completion:nil)
        }
    }
    
    
    func addNewAccount(from accountView: NewAccountView) {
        
        let tabBar = presentingViewController as! UITabBarController
        
        let controller = tabBar.viewControllers![2] as! AccountManageViewController
        
        // Creating
        
        let account = Account(withName: "\(accountView.accountNameTextField.text!)")
        
        if let balance = Double(accountView.balanceTextField.text!)
        {
            let income = Income(withAmount: balance)
            
            income.account = account
            
            _ = RegisterLine(basedOn: income, measure: account, resource: balance, kind: .Adding, date: income.date)
            
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