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
        for (index, ringMeter) in ringGraph.meters.enumerate() {
            
            CGContextSaveGState(context)
            drawBackgroundRing(geometry.radiusForIndex(index), meter: ringMeter)
            CGContextRestoreGState(context)
        }
    }
    
    func drawForeground(animationState: RingGraphAnimationState) {
        for (index, ringMeter) in ringGraph.meters.enumerate() {
            let currentValue = CGFloat(animationState.meterValues[index])
            let endAngle = geometry.angleForValue(currentValue)
            let radius = geometry.radiusForIndex(index)

            CGContextSaveGState(context)
            
            func drawHalfForegroundRing() {
                let drawAngle = (endAngle > halfRingAngle ? halfRingAngle : endAngle)
                drawForegroundRing(radius, startAngle: startAngle, endAngle: drawAngle, meter: ringMeter)
            }
            
            if (ringMeter.colors.count > 1) {
                CGContextBeginTransparencyLayer(context, nil);
                drawHalfForegroundRing()
                drawGradient(drawingRect, meterIndex: index) //TODO this method should take only gradient rect
                CGContextEndTransparencyLayer(context)
            } else {
                drawHalfForegroundRing()
            }

            if (endAngle > halfRingAngle) {
                let sectionEndAngle = endAngle > shadowEndingAngle ? shadowEndingAngle : endAngle
                drawForegroundRing(radius, startAngle: halfRingAngle, endAngle: sectionEndAngle, meter: ringMeter)
            }
            
            if (endAngle > shadowEndingAngle) {
                CGContextSetShadow(context, CGSizeMake(10, 0), 5);
                drawForegroundRing(radius, startAngle: shadowEndingAngle, endAngle: endAngle, meter: ringMeter)
            }
            
            CGContextRestoreGState(context)
        }
    }
}

private extension RignGraphPainter {
    
    func drawBackgroundRing(radius: CGFloat, meter: RingMeter) {
        let color = meter.backgroundColor.CGColor
        CGContextSetLineWidth(context, geometry.ringWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetStrokeColorWithColor(context, color)
        CGContextAddArc(context, geometry.centerPoint.x, geometry.centerPoint.y, radius, 0, fullCircleRadians, 0)
        CGContextStrokePath(context)
    }
    
    func drawForegroundRing(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, meter: RingMeter) {
        let color = meter.colors.last!.CGColor
        CGContextSetStrokeColorWithColor(context, color)
        CGContextSetLineWidth(context, geometry.ringWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextAddArc(context, geometry.centerPoint.x, geometry.centerPoint.y, radius, startAngle, endAngle, 0)
        CGContextStrokePath(context)
    }
    
    func drawGradient(fullRect: CGRect, meterIndex: Int) {
        let colors = ringGraph.meters[meterIndex].colors
        
        CGContextSetBlendMode(context, CGBlendMode.SourceIn)
        
        let num_locations :size_t = 2;
        let meterMultiplier = CGFloat(meterIndex + 1)
        let locations: [CGFloat] = [0.12 * meterMultiplier, 1 - 0.12 * meterMultiplier]
        let components: [CGFloat] = UIColor.gradientValuesFromColors(colors)
        
        if let glossGradient = CGGradientCreateWithColorComponents(CGColorSpaceCreateDeviceRGB(), components, locations, num_locations) {
        
            let topCenter = CGPoint(x: CGRectGetMidX(drawingRect), y: 0.0)
            let midCenter = CGPoint(x: CGRectGetMidX(drawingRect), y: CGRectGetMaxY(drawingRect))
            
            CGContextClipToRect(context, self.rightGradientClipRect(fullRect))
            CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, [])
        }
    }
    
    func rightGradientClipRect(drawRect: CGRect) -> CGRect {
        var clipRect = drawRect
        let halfWidth = CGRectGetMidX(drawRect)
        let halfRingWidth = geometry.ringWidth / 2.0
        clipRect.origin.x = halfWidth - halfRingWidth
        clipRect.size.width = halfWidth + halfRingWidth
        return clipRect
    }
}
