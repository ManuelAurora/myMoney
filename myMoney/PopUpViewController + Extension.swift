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
        
        articlePriceTextField.becomeFirstResponder()
        
        popUpViewIncome.layer.cornerRadius = 10
        articleNameLabel.text!             = article!.name!
        popUpViewIncome.hidden             = false
    }
    
    func showIncomeView() {
        
        incomeNameTextField.becomeFirstResponder()
        
        popUpViewExpense.layer.cornerRadius = 10
        popUpViewExpense.hidden             = false
    }   
    
    func showCountView() {
        
        let view = NewCountView.loadFromNib()
        
        view.layer.cornerRadius = 10
        
        view.center = self.view.center
        
        view.center.y -= 50
        
        view.viewController = self
        
        self.view.addSubview(view)
    }
    
    func addNewOrEditItem() {
        
        //Adding or editing for CheckViewController
        
        if let controller = presentingViewController as? CheckViewController
        {
            let priceString = articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            if mode == .New
            {
                let articleString = TableString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
                
                articleString.number = controller.fetchedResultsController!.sections![0].numberOfObjects + 1
                
                controller.renumerateStrings()
            }
            else
            {
                guard let stringToEdit = tableString else { return }
                
                stringToEdit.price = Float(articlePriceTextField.text!)
            }
            
            dismissViewControllerAnimated(true, completion:nil)
        }
        
        //Adding or editing for IncomeViewController
        
        if let controller = presentingViewController as? IncomeViewController
        {
            let priceString = incomeNameTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            if mode == .New
            {
                _ = TableString(AddArticle: nil, intoTablePart: controller.income!.tablePart, withPrice: Float(priceString), amount: nil)
            }
            else
            {
                guard let stringToEdit = tableString else { return }
                
                stringToEdit.price = Double(priceString)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}