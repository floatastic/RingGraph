//
//  SymbolPathProviders.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

protocol SymbolPathProvider {
    func path(inRect rect: CGRect) -> UIBezierPath
}

struct RightArrowPathProvider : SymbolPathProvider {
    
    func path(inRect rect: CGRect) -> UIBezierPath {
        let margin :CGFloat = 2
        var points = [CGPoint]()
        
        points.append(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMidY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMaxY(rect)))
        
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[2])
        path.moveToPoint(points[0])
        path.addLineToPoint(points[3])
        path.closePath()
        
        return path
    }
    
}

struct TriagnelPathProvider : SymbolPathProvider {
    
    func path(inRect rect: CGRect) -> UIBezierPath {
        var points = [CGPoint]()
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect)))
        points.append(CGPoint(x: CGRectGetMaxX(rect), y: CGRectGetMaxY(rect)))
        points.append(CGPoint(x: CGRectGetMinX(rect), y: CGRectGetMaxY(rect)))
        
        let path = defaultPath()
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.addLineToPoint(points[2])
        path.closePath()
        
        return path
    }
    
}

internal struct NilPathProvider : SymbolPathProvider {
    func path(inRect rect: CGRect) -> UIBezierPath {
        return UIBezierPath()
    }
}

private func defaultPath() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.lineCapStyle = kCGLineCapRound
    path.lineJoinStyle = kCGLineJoinRound
    path.lineWidth = 3
    
    return path
}