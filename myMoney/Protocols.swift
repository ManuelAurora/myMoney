//
//  Protocols.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

protocol Measure
{
    var name: String { set get }
    
    
    
    
    
}



protocol Registrator {
    func conduct()
    var ID: Int { get }
}

protocol Document {
    var number: Int { get set }
}

enum ProcessingModes {
    case Saving
    case Conduction
}