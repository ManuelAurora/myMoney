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
        
        popUpViewExpense.hidden  = false
    }
    
    func showCountView() {
        
    }
}