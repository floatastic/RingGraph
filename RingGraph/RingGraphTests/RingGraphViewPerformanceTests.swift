//
//  RingGraphView.swift
//  RingGraph
//
//  Created by Kreft, Michal on 03.05.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import XCTest
import RingGraph

class RingGraphViewPerformanceTests: XCTestCase {
    
    var pushedContext :CGContext?
    let helper = TestsHelper()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        popContext()
        super.tearDown()
    }

    func testDrawingPerformance() {
        let tripleGraphMeters = helper.tripleGraphMeters(value: 100)
        let graph = RingGraph(meters: tripleGraphMeters)
        let ringGraphView = RingGraphView(frame: helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
        
        pushContext(ringGraphView)
        
        self.measureBlock() {
            ringGraphView.drawRect(ringGraphView.bounds)
        }
    }
    
    private func pushContext(forView :UIView) {
        let scaleFactor = UIScreen.mainScreen().scale
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let bounds = forView.bounds
        let width = Int(bounds.size.width * scaleFactor)
        let height = Int(bounds.size.height * scaleFactor)
        
        let context = CGBitmapContextCreate(nil, width, height, 8, width * 4, colorSpace, bitmapInfo.rawValue)!
        UIGraphicsPushContext(context)
    }
    
    private func popContext() {
        if let _ = pushedContext {
            UIGraphicsPopContext()
            self.pushedContext = nil
        }
    }

}
