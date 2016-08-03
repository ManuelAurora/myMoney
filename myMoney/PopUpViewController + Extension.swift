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
        
        self.view.addSubview(view)
    }
}