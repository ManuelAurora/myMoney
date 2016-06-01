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
    func conduct(register: Register)
}

protocol Document {
    var number: Int { get set }
}