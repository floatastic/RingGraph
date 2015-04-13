//
//  RingGraphPainter.swift
//  RingMeter
//
//  Created by Michał Kreft on 30/03/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation
import UIKit

private let fullCircleRadians = 2.0 * CGFloat(M_PI)
private let startAngle = -0.25 * fullCircleRadians
private let halfRingAngle = startAngle + CGFloat(M_PI)
private let shadowEndingAngle = startAngle + fullCircleRadians * 0.93
private let diameterToRingWidthFactor = CGFloat(0.11)
private let minDrawableValue = CGFloat(0.00001)

internal class RignGraphPainter {
    let ringGraph: RingGraph
    let drawingRect: CGRect
    let centerPoint: CGPoint
    let diameter: CGFloat
    let ringWidth: CGFloat
    let maxRadius: CGFloat
    var context: CGContext?
    
    required init(ringGraph graph: RingGraph, drawingRect rect: CGRect) {
        ringGraph = graph
        drawingRect = rect
        
        centerPoint = CGPoint(x: CGRectGetMidX(drawingRect), y: CGRectGetMidY(drawingRect))
        diameter = min(CGRectGetWidth(drawingRect), CGRectGetHeight(drawingRect))
        ringWidth = diameter * diameterToRingWidthFactor
        maxRadius = (diameter - ringWidth) / 2.0
    }
    
    convenience init(ringGraph graph: RingGraph, drawingRect rect: CGRect, context: CGContext) {
        self.init(ringGraph: graph, drawingRect: rect)
        self.context = context
    }
    
    func drawBackground() {
        if let context = context {
            for (index, ringMeter) in enumerate(ringGraph.meters) {
                let radius = radiusForIndex(index)
                
                CGContextSaveGState(context)
                
                drawBackgroundRing(radius, meter: ringMeter)
                
                CGContextRestoreGState(context)
            }
        }
    }
    
    func drawForeground(animationState: RingGraphAnimationState) {
        if let context = context {
            for (index, ringMeter) in enumerate(ringGraph.meters) {
                let currentValue = CGFloat(animationState.meterValues[index])
                let endAngle :CGFloat = (currentValue > 0.0 ? currentValue : minDrawableValue) * fullCircleRadians + startAngle
                let radius = radiusForIndex(index)

                CGContextSaveGState(context)
                
                func drawHalfForegroundRing() {
                    let drawAngle = (endAngle > halfRingAngle ? halfRingAngle : endAngle)
                    drawForegroundRing(radius, startAngle: startAngle, endAngle: drawAngle, meter: ringMeter)
                }
                
                if (count(ringMeter.colors) > 1) {
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
    
    func framesForDescriptionLabels() -> [CGRect] {
        var frames = [CGRect]()
        
        for (index, ringMeter) in enumerate(ringGraph.meters) {
            let radius = radiusForIndex(index)
            let origin = CGPoint(x: centerPoint.x - maxRadius, y: centerPoint.y - radius - ringWidth / 2.0)
            let size = CGSize(width: maxRadius - ringWidth / 1.5, height: ringWidth)
            frames.append(CGRect(origin: origin, size: size))
        }
        
        return frames
    }
    
    func frameForDescriptionText() -> CGRect {
        var frame = CGRect()
        frame.origin.x = centerPoint.x - drawingRect.size.width * 0.3
        frame.origin.y = centerPoint.y - drawingRect.size.height * 0.2
        frame.size.width = drawingRect.size.width * 0.6
        frame.size.height = drawingRect.size.height * 0.4
        return frame
    }
}

private extension RignGraphPainter {
    
    func radiusForIndex(index: Int) -> CGFloat {
        return maxRadius - CGFloat(ringWidth + 1) * CGFloat(index)
    }
    
    func drawBackgroundRing(radius: CGFloat, meter: RingMeter) {
        if let context = context {
            let color = meter.backgroundColor.CGColor
            CGContextSetLineWidth(context, ringWidth)
            CGContextSetLineCap(context, kCGLineCapRound)
            CGContextSetStrokeColorWithColor(context, color)
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircleRadians, 0)
            CGContextStrokePath(context)
        }
    }
    
    func drawForegroundRing(radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, meter: RingMeter) {
        if let context = context {
            let color = meter.colors.last!.CGColor
            CGContextSetStrokeColorWithColor(context, color)
            CGContextSetLineWidth(context, ringWidth)
            CGContextSetLineCap(context, kCGLineCapRound)
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, 0)
            CGContextStrokePath(context)
        }
    }
    
    func drawGradient(fullRect: CGRect, meterIndex: Int) {
        if let context = context {
            let colors = ringGraph.meters[meterIndex].colors
            
            CGContextSetBlendMode(context, kCGBlendModeSourceIn)
            
            let num_locations :size_t = 2;
            let meterMultiplier = CGFloat(meterIndex + 1)
            let locations: [CGFloat] = [0.12 * meterMultiplier, 1 - 0.12 * meterMultiplier]
            let components: [CGFloat] = UIColor.gradientValuesFromColors(colors)
            
            let rgbColorspace = CGColorSpaceCreateDeviceRGB()
            let glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations)
            
            let topCenter = CGPoint(x: CGRectGetMidX(drawingRect), y: 0.0)
            let midCenter = CGPoint(x: CGRectGetMidX(drawingRect), y: CGRectGetMaxY(drawingRect))
            
            CGContextClipToRect(context, self.rightGradientClipRect(fullRect))
            CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0)
        }
    }
    
    func rightGradientClipRect(drawRect: CGRect) -> CGRect {
        var clipRect = drawRect
        let halfWidth = CGRectGetMidX(drawRect)
        let halfRingWidth = ringWidth / 2.0
        clipRect.origin.x = halfWidth - halfRingWidth
        clipRect.size.width = halfWidth + halfRingWidth
        return clipRect
    }
}
