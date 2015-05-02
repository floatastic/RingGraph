//
//  SymbolPathProviders.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

protocol SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath
}

class DefaultPathProvider {
    let animationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: 0.3, animationEnd: 0.6)
    let margin :CGFloat = 2
    
    func defaultPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.lineCapStyle = kCGLineCapRound
        path.lineJoinStyle = kCGLineJoinRound
        path.lineWidth = 3
        
        return path
    }
    
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func normalizedProgress(progress :Float) -> CGFloat {
        return CGFloat(animationHelper.normalizedProgress(absoluteProgress: progress))
    }
}

class RightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    override func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        var points = [CGPoint]()
        
        let middleEndPoint = CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect))
        
        var intermediatePoint1 = middleEndPoint
        intermediatePoint1.x = middleEndPoint.x * progress
        
        var intermediatePoint2 = middleEndPoint
        intermediatePoint2.x = CGRectGetMidX(rect) + middleEndPoint.x * progress / 2
        
        points.append(intermediatePoint1)
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect)))
        
        points.append(intermediatePoint2)
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect)))
        
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.moveToPoint(points[2])
        path.addLineToPoint(points[3])
        path.moveToPoint(points[2])
        path.addLineToPoint(points[4])
        path.closePath()
        
        return path
    }
    
}

class DoubleRightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    override func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        var points = [CGPoint]()
        
        let arrowSpacing :CGFloat = 6
        
        points.append(CGPoint(x: CGRectGetMaxX(rect) - arrowSpacing, y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect) - arrowSpacing, y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect) - arrowSpacing, y: CGRectGetMaxY(rect)))
        
        points.append(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect)))
        
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[2])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[3])
        
        path.moveToPoint(points[4])
        path.addLineToPoint(points[5])
        path.moveToPoint(points[4])
        path.addLineToPoint(points[6])
        
        path.closePath()
        
        return path
    }
    
}

class UpArrowPathProvider : RightArrowPathProvider, SymbolPathProvider {
    
    override func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        var path = super.path(inRect: rect, forAnimationProgress: animationProgress)
        
        let center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        let radians = CGFloat(-90 * M_PI / 180)
        
        var transform = CGAffineTransformIdentity
        transform = CGAffineTransformTranslate(transform, center.x, center.y)
        transform = CGAffineTransformRotate(transform, radians)
        transform = CGAffineTransformTranslate(transform, -center.x, -center.y)
        
        path.applyTransform(transform)
        
        return path
    }
    
}

internal class NilPathProvider : SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
}
