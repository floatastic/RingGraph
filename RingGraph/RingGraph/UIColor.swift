//
//  UIColor.swift
//  RingMeter
//
//  Created by Michał Kreft on 01/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

//import Foundation
import UIKit

public let AppleBlue1 = UIColor(red: 0.965, green: 0.094, blue: 0.122, alpha: 1.0)
public let AppleBlue2 = UIColor(red: 0.973, green: 0.0, blue: 0.671, alpha: 1.0)
public let AppleGreen1 = UIColor(red: 0.647, green: 1.0, blue: 0.0, alpha: 1.0)
public let AppleGreen2 = UIColor(red: 0.845, green: 1.0, blue: 0.004, alpha: 1.0)
public let AppleRed1 = UIColor(red: 0.271, green: 0.878, blue: 0.984, alpha: 1.0)
public let AppleRed2 = UIColor(red: 0.306, green: 0.988, blue: 0.918, alpha: 1.0)

internal extension UIColor {
    
    class func gradientValuesFromColors(colors: [UIColor]) -> [CGFloat] {
        var outputValues = [CGFloat]()
        var r, g, b, a :CGFloat
        (r, g, b, a) = (0.0, 0.0, 0.0, 0.0)
        
        for color in colors {
            //TODO try to simply add CGColors to array (like in c)
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            outputValues += [r, g, b, a]
        }
        
        return outputValues
    }
    
    func darker() -> UIColor {
        var h, s, b, a :CGFloat
        (h, s, b, a) = (0.0, 0.0, 0.0, 0.0)
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s * 1.2, brightness: 0.25, alpha: a)
    }
    
    func blend(color: UIColor) -> UIColor {
        let alpha: CGFloat = 0.5
        let beta = 1.0 - alpha
        var r1, g1, b1, a1, r2, g2, b2, a2 :CGFloat
        (r1, g1, b1, a1, r2, g2, b2, a2) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        let r = r1 * beta + r2 * alpha;
        let g = g1 * beta + g2 * alpha;
        let b = b1 * beta + b2 * alpha;
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}