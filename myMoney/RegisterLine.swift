//
//  RegisterLine.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

struct RegisterLine
{
    
    let registrator: Registrator
    
    let measure: Measure
    
    let resourse: Double
    
    let kind: Kind
    
}

enum Kind: String
{
    case Substracting = "-"
    case Adding       = "+"
}