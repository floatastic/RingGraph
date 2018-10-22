//
//  AnimationHelper.swift
//  RingMeter
//
//  Created by Michał Kreft on 13/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Foundation

internal struct AnimationState {
    let totalDuration: TimeInterval
    var currentTime: TimeInterval = 0.0
    
    init(totalDuration: TimeInterval) {
        self.totalDuration = totalDuration
    }
    
    init(totalDuration: TimeInterval, progress: Float) {
        self.totalDuration = totalDuration
        self.currentTime = totalDuration * TimeInterval(progress)
    }
    
    func progress() -> Float {
        return currentTime >= totalDuration ? 1.0 : Float(currentTime / totalDuration)
    }
    
    mutating func incrementDuration(delta: TimeInterval) {
        currentTime += delta
    }
}

internal struct RangeAnimationHelper {
    let animationStart: Float
    let animationEnd: Float
    
    init(animationStart: Float = 0.0, animationEnd: Float = 1.0) {
        self.animationStart = animationStart
        self.animationEnd = animationEnd
    }
    
    func normalizedProgress(_ absoluteProgress: Float) -> Float {
        var normalizedProgress: Float = 0.0
        
        switch absoluteProgress {
            case _ where absoluteProgress < animationStart:
                normalizedProgress = 0.0
            case _ where absoluteProgress > animationEnd:
                normalizedProgress = 1.0
            default:
                let progressSpan = animationEnd - animationStart
                normalizedProgress = (absoluteProgress - animationStart) / progressSpan
        }
        
        return normalizedProgress
    }
}

struct RingGraphAnimationState {
    let animationHelper: RangeAnimationHelper
    let animationProgress: Float
    let meterValues: [Float]
    
    init(graph: RingGraph, animationProgress inProgress: Float) {
        animationHelper = RangeAnimationHelper(animationStart: 0.3, animationEnd: 1.0)
        let graphProgress = sinEaseOutValue(forAnimationProgress: animationHelper.normalizedProgress(inProgress))
        animationProgress = graphProgress
        
        let closureProgress = animationProgress
        meterValues = graph.meters.map {meter -> Float in
            return meter.normalizedValue * closureProgress
        }
    }
}

internal func sinEaseOutValue(forAnimationProgress progress: Float) -> Float {
    return sin(progress * Float(Double.pi) / 2)
}
