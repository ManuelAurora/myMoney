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
    func addNewItem() {        
        
        if let controller = presentingViewController as? CheckViewController
        {
            let priceString = articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            if mode == .New {
                
                let articleString = TableString(AddArticle: article!, intoTablePart: controller.check!.tablePart, withPrice: Float(priceString), amount: nil)
                
                articleString.number = controller.fetchedResultsController!.sections![0].numberOfObjects + 1
                
                controller.renumerateStrings()
                
            } else {
                
                let stringToEdit = controller.fetchedResultsController!.objectAtIndexPath(indexOfStringToEdit!) as! TableString
                
                stringToEdit.price = Float(articlePriceTextField.text!)
            }
            
            dismissViewControllerAnimated(true, completion:nil)
        }
        else if let controller = presentingViewController as? IncomeViewController
        {
            let priceString = articlePriceTextField.text!.stringByReplacingOccurrencesOfString(",", withString: ".", options: [], range: nil)
            
            let incomeString = TableString(AddArticle: nil, intoTablePart: controller.income!.tablePart, withPrice: Float(priceString), amount: nil)            
            
            
        }
    }
    
   
}