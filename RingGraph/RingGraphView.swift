//
//  CircleGraphView.swift
//  RingMeter
//
//  Created by Michał Kreft on 27/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

class RingGraphView: UIView {
    let graph: RingGraph
    let foregroundView :ForegroundView
    
    required init(frame: CGRect, graph: RingGraph, preset: GraphViewDescriptionPreset) {
        self.graph = graph
        
        let foregroundViewFrame = CGRect(origin: CGPoint(), size: frame.size)
        foregroundView = ForegroundView(frame: foregroundViewFrame, graph: graph, preset: preset)
        
        super.init(frame: frame)
        
        self.addSubview(foregroundView)
    }

    required init(coder aDecoder: NSCoder) { //ugh!
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        let painter = RignGraphPainter(ringGraph: graph, drawingRect: rect, context: UIGraphicsGetCurrentContext())
        painter.drawBackground()
    }
    
    func animateGraph() {
        foregroundView.animate()
    }
}
