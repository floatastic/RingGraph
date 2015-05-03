//
//  RingGraphView.swift
//  RingGraph
//
//  Created by Kreft, Michal on 03.05.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import XCTest

class RingGraphViewTests: FBSnapshotTestCase {
    var pushedContext :CGContext?

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        popContext()
        super.tearDown()
    }

    func testPerformanceExample() {
        let tripleGraphMeters = [RingMeter(title: "Move", value: 100, maxValue: 100, colors: [AppleBlue1, AppleBlue2], symbolProvider: RightArrowPathProvider()),
            RingMeter(title: "Exercise", value: 100, maxValue: 100, colors: [AppleGreen1, AppleGreen2], symbolProvider: DoubleRightArrowPathProvider()),
            RingMeter(title: "Stand", value: 100, maxValue: 100, colors: [AppleRed1, AppleRed2], symbolProvider: UpArrowPathProvider())]
        
        let graph = RingGraph(meters: tripleGraphMeters)
        
        let frame = CGRect(x: 160, y: 260, width: 300, height: 300)
        let ringGraphView = RingGraphView(frame: frame, graph: graph!, preset: .MetersDescription)
        
        pushContext(ringGraphView)
        
        self.measureBlock() {
            ringGraphView.drawRect(ringGraphView.bounds)
        }
    }
    
    private func pushContext(forView :UIView) {
        let scaleFactor = UIScreen.mainScreen().scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
        let bounds = forView.bounds
        let width = Int(bounds.size.width * scaleFactor)
        let height = Int(bounds.size.height * scaleFactor)
        
        let context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, bitmapInfo)
        UIGraphicsPushContext(context)
    }
    
    private func popContext() {
        if let pushedContext = pushedContext {
            UIGraphicsPopContext()
            self.pushedContext = nil
        }
    }

}
