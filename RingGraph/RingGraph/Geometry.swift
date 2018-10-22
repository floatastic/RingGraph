//
//  Geometry.swift
//  RingGraph
//
//  Created by Kreft, Michal on 15.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

internal let fullCircleRadians = 2.0 * CGFloat(Double.pi)
internal let startAngle = -0.25 * fullCircleRadians
internal let halfRingAngle = startAngle + CGFloat(Double.pi)
internal let shadowEndingAngle = startAngle + fullCircleRadians * 0.93

private let diameterToRingWidthFactor = CGFloat(0.11)
private let minDrawableValue = CGFloat(0.00001)

internal struct Geometry {
    let centerPoint: CGPoint
    let ringWidth: CGFloat
    
    private let size: CGSize
    private let ringGraph: RingGraph
    private let diameter: CGFloat
    
    private let maxRadius: CGFloat
    
    init(ringGraph: RingGraph, drawingSize: CGSize) {
        self.ringGraph = ringGraph
        size = drawingSize
        centerPoint = CGPoint(x: drawingSize.width / 2, y: drawingSize.height / 2)
        diameter = min(drawingSize.width, drawingSize.height)
        ringWidth = diameter * diameterToRingWidthFactor
        maxRadius = (diameter - ringWidth) / 2.0
    }
    
    func framesForDescriptionLabels() -> [CGRect] {
        var frames = [CGRect]()
        
        for (index, _) in ringGraph.meters.enumerated() {
            let radius = radiusForIndex(index)
            let origin = CGPoint(x: centerPoint.x - maxRadius, y: centerPoint.y - radius - ringWidth / 2.0)
            let size = CGSize(width: maxRadius - ringWidth / 1.5, height: ringWidth)
            frames.append(CGRect(origin: origin, size: size))
        }
        
        return frames
    }
    
    func frameForDescriptionText() -> CGRect {
        var frame = CGRect()
        frame.origin.x = centerPoint.x - size.width * 0.3
        frame.origin.y = centerPoint.y - size.height * 0.2
        frame.size.width = size.width * 0.6
        frame.size.height = size.height * 0.4
        return frame
    }
    
    func framesForRingSymbols() -> [CGRect] {
        var frames = [CGRect]()
        
        for (index, _) in ringGraph.meters.enumerated() {
            let radius = radiusForIndex(index)
            let width = ringWidth * 0.6
            let origin = CGPoint(x: centerPoint.x - width / 2.0, y: centerPoint.y - radius - width / 2.0)
            let size = CGSize(width: width, height: width)
            frames.append(CGRect(origin: origin, size: size))
        }
        
        return frames
    }
    
    func radiusForIndex(_ index: Int) -> CGFloat {
        return maxRadius - CGFloat(ringWidth + 1) * CGFloat(index)
    }
    
    func angleForValue(_ value: CGFloat) -> CGFloat {
        return (value > 0.0 ? value : minDrawableValue) * fullCircleRadians + startAngle
    }
}
