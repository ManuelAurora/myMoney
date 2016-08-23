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

