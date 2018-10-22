//
//  CircleGraphView.swift
//  RingMeter
//
//  Created by Michał Kreft on 27/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

public class RingGraphView: UIView {
    let graph: RingGraph
    let foregroundView :ForegroundView
    
    required public init(frame: CGRect, graph: RingGraph, preset: GraphViewDescriptionPreset) {
        self.graph = graph
        
        let foregroundViewFrame = CGRect(origin: CGPoint(), size: frame.size)
        foregroundView = ForegroundView(frame: foregroundViewFrame, graph: graph, preset: preset)
        
        super.init(frame: frame)
        
        self.addSubview(foregroundView)
    }

    required public init?(coder aDecoder: NSCoder) { //ugh!
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        let painter = RignGraphPainter(ringGraph: graph, drawingRect: rect, context: UIGraphicsGetCurrentContext()!)
        painter.drawBackground()
    }
    
    public func animateGraph() {
        foregroundView.animate()
    }
}
