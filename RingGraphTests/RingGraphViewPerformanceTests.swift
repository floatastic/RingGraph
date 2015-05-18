//
//  RingGraphView.swift
//  RingGraph
//
//  Created by Kreft, Michal on 03.05.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import FBSnapshotTestCase

class RingGraphViewPerformanceTests: FBSnapshotTestCase {
    
    var pushedContext :CGContext?
    let helper = TestsHelper()

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        popContext()
        super.tearDown()
    }

    func testPerformanceExample() {
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
