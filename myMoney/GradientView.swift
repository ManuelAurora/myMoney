//
//  GradientView.swift
//  iFoundIt
//
//  Created by Мануэль on 29.04.16.
//  Copyright © 2016 Мануэль. All rights reserved.
//

import UIKit

class GradienView: UIView
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor  = UIColor.clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let locations:  [CGFloat] = [0, 1]
        let components: [CGFloat] = [0, 0, 0, 0.2, 0, 0, 0, 0.85]
       
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient   = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: 2)
        
        let x       = bounds.midX
        let y       = bounds.midY
        let point   = CGPoint(x: x, y: y)
        let radiust = max(x, y)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawRadialGradient(gradient!, startCenter: point, startRadius: 0, endCenter: point, endRadius: radiust, options: .drawsAfterEndLocation)
    }    
}
