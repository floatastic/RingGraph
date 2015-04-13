//
//  RingGraph.swift
//  RingMeter
//
//  Created by Michał Kreft on 29/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation
import UIKit

struct RingGraph {
    let meters: [RingMeter]
    
    init?(meters: [RingMeter]) {
        self.meters = meters
        
        if (count(meters) == 0) {
            return nil
        }
    }
    
    init?(meter: RingMeter) {
        self.init(meters: [meter])
    }
}

private let defaultColor = UIColor.lightGrayColor()

struct RingMeter {
    let title: String
    let value: Int
    let maxValue: Int
    let colors: [UIColor]
    
    internal let normalizedValue: Float
    internal let backgroundColor: UIColor
    internal let descriptionLabelColor: UIColor
    
    init(title: String, value: Int, maxValue: Int, colors: [UIColor]) {
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.colors = count(colors) > 0 ? colors : [defaultColor]
        
        normalizedValue = value <= maxValue ? Float(value) / Float(maxValue) : 1.0
        
        if colors.count == 1 {
            backgroundColor = self.colors.first!.darker()
            descriptionLabelColor = self.colors.first!
        } else {
            descriptionLabelColor = self.colors.first!.blend(self.colors.last!)
            backgroundColor = descriptionLabelColor.darker()
        }
    }
}
