//
//  TestsHelper.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.05.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit
import RingGraph

class TestsHelper: NSObject {
    
    func defaultFrame() -> CGRect {
        return CGRect(x: 160, y: 260, width: 300, height: 300)
    }
    
    func tripleGraphMeters(value value: Int) -> [RingMeter] {
        return [RingMeter(title: "Move", value: value, maxValue: 100, colors: [AppleBlue1, AppleBlue2], symbolProvider: RightArrowPathProvider()),
            RingMeter(title: "Exercise", value: value, maxValue: 100, colors: [AppleGreen1, AppleGreen2], symbolProvider: DoubleRightArrowPathProvider()),
            RingMeter(title: "Stand", value: value, maxValue: 100, colors: [AppleRed1, AppleRed2], symbolProvider: UpArrowPathProvider())]
    }
    
    func singleGraphMeters(value value: Int) -> [RingMeter] {
        return [RingMeter(title: "Move", value: value, maxValue: 100, colors: [AppleRed1, AppleRed2])]
    }
    
    func tripleSingleColorGraphMeters(value value: Int) -> [RingMeter] {
        let color = UIColor.yellowColor()
        return [RingMeter(title: "Move", value: value, maxValue: 100, colors: [color]),
            RingMeter(title: "Exercise", value: value, maxValue: 100, colors: [color]),
            RingMeter(title: "Stand", value: value, maxValue: 100, colors: [color])]
    }
    
}
