//
//  Protocols.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import CoreData

enum DocumentPresentationMode
{
    case DocumentEditMode
    case DocumentNewMode
}

enum PopUpElementPresentationMode
{
    case ElementEditMode
    case ElementNewMode
}

enum DocumentType
{  
    case DocumentExpenditureType
}

enum PopUpElementType
{
    case ElementArticleType
    case ElementAccountType
    case ElementAccountListType
}

struct Constants  //TODO: RENAME THIS!
{
    static let expenditureName = "Expenditure"
    static let incomeName      = "Income"
}

func prettyStringFrom(doubleValue: Double) -> String {
    
    let resultString = String(format: "%.2f", doubleValue)
    
    return resultString    
}

func prettyStringFrom(dateValue: NSDate) -> String {
    
    let formatter = NSDateFormatter()
    
    formatter.dateFormat = "d MMMM hh:mm"
    
    return formatter.stringFromDate(dateValue)
}