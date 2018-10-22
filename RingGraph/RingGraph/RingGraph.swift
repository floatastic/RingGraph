//
//  RingGraph.swift
//  RingMeter
//
//  Created by Michał Kreft on 29/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation
import UIKit

public struct RingGraph {
    let meters: [RingMeter]
    
    public init?(meters: [RingMeter]) {
        self.meters = meters
        
        if (meters.count == 0) {
            return nil
        }
    }
    
    public init?(meter: RingMeter) {
        self.init(meters: [meter])
    }
}

private let defaultColor = UIColor.lightGray

public struct RingMeter {
    let title: String
    let value: Int
    let maxValue: Int
    let colors: [UIColor]
    let symbolProvider: SymbolPathProvider
    
    internal let normalizedValue: Float
    internal let backgroundColor: UIColor
    internal let descriptionLabelColor: UIColor
    

    
    public init(title: String, value: Int, maxValue: Int, colors: [UIColor], symbolProvider: SymbolPathProvider) {
        self.title = title
        self.value = value
        self.maxValue = maxValue
        self.colors = colors.count > 0 ? colors : [defaultColor]
        self.symbolProvider = symbolProvider
        
        normalizedValue = value <= maxValue ? Float(value) / Float(maxValue) : 1.0
        
        if colors.count == 1 {
            backgroundColor = self.colors.first!.darker()
            descriptionLabelColor = self.colors.first!
        } else {
            descriptionLabelColor = self.colors.first!.blend(color: self.colors.last!)
            backgroundColor = descriptionLabelColor.darker()
        }
    }
    
    public init(title: String, value: Int, maxValue: Int, colors: [UIColor]) {
        let pathProvider = NilPathProvider()
        self.init(title: title, value: value, maxValue: maxValue, colors: colors, symbolProvider: pathProvider)
    }
}

