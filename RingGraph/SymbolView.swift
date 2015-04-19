//
//  SymbolView.swift
//  RingGraph
//
//  Created by Kreft, Michal on 19.04.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

class SymbolView: UIView {
    let margin: CGFloat = 2
    let symbolProvider: SymbolPathProvider
    let color = UIColor.blackColor().CGColor
    
    required init(frame: CGRect, symbolProvider: SymbolPathProvider) {
        self.symbolProvider = symbolProvider
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) { //ugh!
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        let path = symbolProvider.path(inRect: rectWithMargins(rect))
        let context = UIGraphicsGetCurrentContext()
        
        path.stroke()
    }
    
    private func rectWithMargins(originalRect: CGRect) -> CGRect {
        var rect = originalRect
        
        rect.origin.x += margin
        rect.origin.y += margin
        rect.size.width -= 2 * margin
        rect.size.height -= 2 * margin
        
        return rect
    }
}
