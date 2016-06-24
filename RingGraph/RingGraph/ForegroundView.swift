//
//  ForegroundView.swift
//  RingMeter
//
//  Created by Michał Kreft on 01/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

public enum GraphViewDescriptionPreset {
    case None
    case CentralDescription
    case MetersDescription
}

internal class ForegroundView: UIView {
    let graph: RingGraph
    let descriptionPreset: GraphViewDescriptionPreset
    var animationState: AnimationState
    var displayLink: CADisplayLink?
    var ringDescriptionLabels = [FadeOutLabel]()
    var symbolViews = [SymbolView]()
    var progressTextView: ProgressTextView?
    
    required init(frame: CGRect, graph: RingGraph, preset: GraphViewDescriptionPreset) {
        self.graph = graph
        descriptionPreset = preset
        animationState = AnimationState(totalDuration: 1.3, progress: 1.0)
        
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        switch descriptionPreset {
        case .CentralDescription:
            addProgressTextView()
        case .MetersDescription:
            addRingDescriptionLabels()
            addRingSymbols()
        case .None:
            break
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) { //ugh!
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        if isAnimating() {
            animationState.incrementDuration(displayLink!.duration)
        }
        
        let animationProgress = animationState.progress()

        if isAnimating() && animationProgress == 1.0 {
            endAnimation()
        }
        
        let ringAnimationState = RingGraphAnimationState(graph: graph, animationProgress: animationProgress)
        
        let painter = RignGraphPainter(ringGraph: graph, drawingRect: rect, context: UIGraphicsGetCurrentContext()!)
        painter.drawForeground(ringAnimationState)
        
        for label in ringDescriptionLabels {
            label.setAnimationProgress(animationProgress)
        }
        
        for symbolView in symbolViews {
            symbolView.animationProgress = animationProgress
        }
        
        if let progressTextView = self.progressTextView {
            progressTextView.setAnimationProgress(animationProgress)
        }
    }
    
    func animate() {
        if isAnimating() {
            endAnimation()
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(UIView.setNeedsDisplay))
        displayLink!.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        animationState.currentTime = 0.0
    }
}

private extension ForegroundView {
    private func isAnimating() -> Bool {
        return displayLink != nil
    }
    
    private func endAnimation() {
        if isAnimating() {
            displayLink!.invalidate()
            displayLink = nil
        }
    }
    
    private func addRingDescriptionLabels() {
        let geometry = Geometry(ringGraph: graph, drawingSize: frame.size)
        
        for (index, labelFrame) in geometry.framesForDescriptionLabels().enumerate() {
            let meter = graph.meters[index]
            let label = FadeOutLabel(frame: labelFrame)
            label.text = meter.title.uppercaseString
            label.textAlignment = .Right
            label.font = UIFont.boldSystemFontOfSize(20.0)
            label.textColor = meter.descriptionLabelColor
            self.addSubview(label)
            ringDescriptionLabels.append(label)
        }
    }
    
    private func addRingSymbols() {
        let geometry = Geometry(ringGraph: graph, drawingSize: frame.size)
        
        for (index, frame) in geometry.framesForRingSymbols().enumerate() {
            let meter = graph.meters[index]
            let symbolView = SymbolView(frame: frame, symbolProvider: meter.symbolProvider)
            addSubview(symbolView)
            symbolViews.append(symbolView)
        }
    }
    
    private func addProgressTextView() {
        let geometry = Geometry(ringGraph: graph, drawingSize: frame.size)
        
        let view = ProgressTextView(frame: geometry.frameForDescriptionText(), ringMeter: graph.meters.first!)
        addSubview(view)
        progressTextView = view
    }
}
