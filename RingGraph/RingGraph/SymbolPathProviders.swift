//
//  SymbolPathProviders.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//  ImageProvider (c) Sebastien REMY (@iLandes on github) on 09.2016
//

import UIKit

let DefaultSymbolAnimationStart :Float = 0.3
let DefaultSymbolAnimationEnd :Float = 0.6

public protocol SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath
}

public class DefaultPathProvider {
    let animationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: DefaultSymbolAnimationStart, animationEnd: DefaultSymbolAnimationEnd)
    let margin :CGFloat = 2
    
    public init() { }
    
    func defaultPath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.lineCapStyle = CGLineCap.round
        path.lineJoinStyle = CGLineJoin.round
        path.lineWidth = 3
        
        return path
    }
    
    public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
    func normalizedProgress(_ progress :Float) -> CGFloat {
        return CGFloat(animationHelper.normalizedProgress(progress))
    }
}


public class ImageProvider : DefaultPathProvider, SymbolPathProvider {
    // Class Added by Sebastien REMY (@iLandes on github) on Sept' 2016
    
    private var image: UIImage?
    private let kTransparent =  UIColor(white: 1, alpha: 0)
    
    public init(image: UIImage?) {
        self.image = image
        super.init()
    }
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        let path = UIBezierPath()
        
        
        // Draw a Rect path
        var points = [CGPoint]()
        let w = rect.minX + rect.maxX
        let h = rect.minY + rect.maxY
        let r = CGRect(x: 0, y: 0, width: w, height: h)
        
        points.append(CGPoint(x: 0, y: 0))
        points.append(CGPoint(x: w, y: 0))
        points.append(CGPoint(x: w, y: h))
        points.append(CGPoint(x: 0, y: h))
        
        path.lineWidth = 0
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.addLine(to: points[2])
        path.addLine(to: points[3])
        path.close()
        
        
        // Fill path
        if let i = image {

            // Resizing Image
            UIGraphicsBeginImageContextWithOptions(CGSize(width: w, height: h), false, 1)
            i.draw(in: r)
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            // Fill with Resized Image
            if let resizedImage = resizedImage {
                UIColor(patternImage: resizedImage).setFill()
            }
        
        } else {
            // Fill Transparent
            kTransparent.setFill()
        }
        
        path.fill()
        
        return path
    }
}

public class RightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        var points = [CGPoint]()
        
        let middleEndPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        var intermediatePoint1 = middleEndPoint
        intermediatePoint1.x = middleEndPoint.x * progress
        
        var intermediatePoint2 = middleEndPoint
        intermediatePoint2.x = rect.midX + middleEndPoint.x * progress / 2
        
        points.append(intermediatePoint1)
        points.append(CGPoint(x: rect.minX, y: rect.midY))
        
        points.append(intermediatePoint2)
        points.append(CGPoint(x: rect.midX, y: rect.minY))
        points.append(CGPoint(x: rect.midX, y: rect.maxY))
        
        let path = defaultPath()
        
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.move(to: points[2])
        path.addLine(to: points[3])
        path.move(to: points[2])
        path.addLine(to: points[4])
        path.close()
        
        return path
    }
    
}

public class UpArrowPathProvider : RightArrowPathProvider {
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let path = super.path(inRect: rect, forAnimationProgress: animationProgress)
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radians = CGFloat(-90 * Double.pi / 180)
        
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        
        path.apply(transform)
        
        return path
    }
    
}

private let intermediateAnimationPoint :Float = DefaultSymbolAnimationEnd - 0.1

public class DoubleRightArrowPathProvider : DefaultPathProvider, SymbolPathProvider {
    
    let leftAnimationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: DefaultSymbolAnimationStart, animationEnd: intermediateAnimationPoint)
    let rightAnimationHelper: RangeAnimationHelper = RangeAnimationHelper(animationStart: intermediateAnimationPoint, animationEnd: DefaultSymbolAnimationEnd)
    let arrowSpacing :CGFloat = 6
    
    override public func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        let progress = normalizedProgress(animationProgress)
        
        if (progress == 0.0) {
            return super.path(inRect: rect, forAnimationProgress: animationProgress)
        }
        
        let leftProgress = CGFloat(leftAnimationHelper.normalizedProgress(animationProgress))
        let rightProgress = CGFloat(rightAnimationHelper.normalizedProgress(animationProgress))
        
        var points = [CGPoint]()
        
        let middleEndPoint = CGPoint(x: rect.maxX - arrowSpacing, y: rect.midY)
        let rightEndPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        var intermediatePoint1 = middleEndPoint
        intermediatePoint1.x = middleEndPoint.x * leftProgress
        
        points.append(intermediatePoint1)
        points.append(CGPoint(x: rect.minX, y: rect.midY))
        points.append(CGPoint(x: rect.midX - arrowSpacing, y: rect.minY))
        points.append(CGPoint(x: rect.midX - arrowSpacing, y: rect.maxY))
        
        if (rightProgress > 0) {
            let delta = arrowSpacing * (1 - rightProgress)
            var intermediateEndPoint2 = rightEndPoint
            intermediateEndPoint2.x -= delta
            
            points.append(intermediateEndPoint2)
            points.append(CGPoint(x: rect.midX - delta, y: rect.minY))
            points.append(CGPoint(x: rect.midX - delta, y: rect.maxY))
        }
        
        return path(from: points)
    }
    
    func path(from points :[CGPoint]) -> UIBezierPath {
        let path = defaultPath()
        
        path.move(to: points[0])
        path.addLine(to: points[1])
        path.move(to: points[0])
        path.addLine(to: points[2])
        path.move(to: points[0])
        path.addLine(to: points[3])
        
        if (points.count > 4) {
            path.move(to: points[4])
            path.addLine(to: points[5])
            path.move(to: points[4])
            path.addLine(to: points[6])
        }
        
        path.close()
        
        return path
    }
    
}

internal class NilPathProvider : SymbolPathProvider {
    func path(inRect rect: CGRect, forAnimationProgress animationProgress: Float) -> UIBezierPath {
        return UIBezierPath()
    }
}
