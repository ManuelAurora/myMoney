//
//  PopUpVCActions.swift
//  myMoney
//
//  Created by Мануэль on 27.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

extension PopUpViewController
{
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