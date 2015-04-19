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

struct TriagnelPathProvider : SymbolPathProvider {
    
    func path(inRect rect: CGRect) -> UIBezierPath {
        let margin :CGFloat = 2
        var points = [CGPoint]()
        points.append(CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMinY(rect) + margin))
        points.append(CGPoint(x: CGRectGetMaxX(rect) - margin, y: CGRectGetMaxY(rect) - margin))
        points.append(CGPoint(x: CGRectGetMinX(rect) + margin, y: CGRectGetMaxY(rect) - margin))
        
        let path = UIBezierPath()
        path.lineCapStyle = kCGLineCapRound
        path.lineJoinStyle = kCGLineJoinRound
        
        path.moveToPoint(points[0])
        path.addLineToPoint(points[1])
        path.addLineToPoint(points[2])
        path.closePath()
        
        return path
    }
    
}