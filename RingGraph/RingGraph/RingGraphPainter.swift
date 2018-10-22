//
//  RingGraphPainter.swift
//  RingMeter
//
//  Created by Michał Kreft on 30/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation
import UIKit

internal class RignGraphPainter {
    let ringGraph: RingGraph
    let drawingRect: CGRect
    let geometry: Geometry
    let context: CGContext
    
    required init(ringGraph: RingGraph, drawingRect: CGRect, context: CGContext) {
        self.ringGraph = ringGraph
        self.drawingRect = drawingRect
        self.context = context
        geometry = Geometry(ringGraph: ringGraph, drawingSize: drawingRect.size)
    }
    
    func drawBackground() {
        for (index, ringMeter) in ringGraph.meters.enumerated() {
            
            context.saveGState()
            drawBackgroundRing(radius: geometry.radiusForIndex(index), meter: ringMeter)
            context.restoreGState()
        }
    }
    
    func drawForeground(animationState: RingGraphAnimationState) {
        for (index, ringMeter) in ringGraph.meters.enumerated() {
            let currentValue = CGFloat(animationState.meterValues[index])
            let endAngle = geometry.angleForValue(currentValue)
            let radius = geometry.radiusForIndex(index)

            context.saveGState()
            
            func drawHalfForegroundRing() {
                let drawAngle = (endAngle > halfRingAngle ? halfRingAngle : endAngle)
                drawForegroundRing(radius: radius, startAngle: startAngle, endAngle: drawAngle, meter: ringMeter)
            }
            
            if (ringMeter.colors.count > 1) {
                context.beginTransparencyLayer(auxiliaryInfo: nil)
                drawHalfForegroundRing()
                drawGradient(fullRect: drawingRect, meterIndex: index) //TODO this method should take only gradient rect
                context.endTransparencyLayer()
            } else {
                drawHalfForegroundRing()
            }

            if (endAngle > halfRingAngle) {
                let sectionEndAngle = endAngle > shadowEndingAngle ? shadowEndingAngle : endAngle
                drawForegroundRing(radius: radius, startAngle: halfRingAngle, endAngle: sectionEndAngle, meter: ringMeter)
            }
            
            if (endAngle > shadowEndingAngle) {
                context.setShadow(offset: CGSize(width: 10, height: 0), blur: 5)
                drawForegroundRing(radius: radius, startAngle: shadowEndingAngle, endAngle: endAngle, meter: ringMeter)
            }
            
            context.restoreGState()
        }
    }
}

private extension RignGraphPainter {
    
    func drawBackgroundRing(radius: CGFloat, meter: RingMeter) {
        let color = meter.backgroundColor.cgColor
        context.setLineWidth(geometry.ringWidth)
        context.setLineCap(CGLineCap.round)
        context.setStrokeColor(color)
        context.addArc(center: geometry.centerPoint, radius: radius, startAngle: 0, endAngle: fullCircleRadians, clockwise: false)
        context.strokePath()
    }
    
    func drawForegroundRing(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, meter: RingMeter) {
        let color = meter.colors.last!.cgColor
        context.setStrokeColor(color)
        context.setLineWidth(geometry.ringWidth)
        context.setLineCap(CGLineCap.round)
        context.addArc(center: geometry.centerPoint, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
    
    func drawGradient(fullRect: CGRect, meterIndex: Int) {
        let colors = ringGraph.meters[meterIndex].colors
        
        context.setBlendMode(CGBlendMode.sourceIn)
        
        let num_locations :size_t = 2;
        let meterMultiplier = CGFloat(meterIndex + 1)
        let locations: [CGFloat] = [0.12 * meterMultiplier, 1 - 0.12 * meterMultiplier]
        let components: [CGFloat] = UIColor.gradientValuesFromColors(colors: colors)
        
        if let glossGradient = CGGradient(colorSpace: CGColorSpaceCreateDeviceRGB(), colorComponents: components, locations: locations, count: num_locations) {
        
            let topCenter = CGPoint(x: drawingRect.midX, y: 0.0)
            let midCenter = CGPoint(x: drawingRect.midX, y: drawingRect.maxY)
            
            context.clip(to: self.rightGradientClipRect(drawRect: fullRect))
            context.drawLinearGradient(glossGradient, start: topCenter, end: midCenter, options: [])
        }
    }
    
    func rightGradientClipRect(drawRect: CGRect) -> CGRect {
        var clipRect = drawRect
        let halfWidth = drawRect.midX
        let halfRingWidth = geometry.ringWidth / 2.0
        clipRect.origin.x = halfWidth - halfRingWidth
        clipRect.size.width = halfWidth + halfRingWidth
        return clipRect
    }
}
