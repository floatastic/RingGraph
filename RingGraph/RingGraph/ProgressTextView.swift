//
//  ProgressTextView.swift
//  RingMeter
//
//  Created by Michał Kreft on 12/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

private let counterDescriptionRatio: CGFloat = 0.7

internal class ProgressTextView: UIView {
    private let counterHostView: UIView
    private let counterLabel: UILabel
    private let descriptionLabel: UILabel
    private let fadeAnimationHelper: RangeAnimationHelper
    private let slideAnimationHelper: RangeAnimationHelper
    
    required init(frame: CGRect, ringMeter: RingMeter) {
        counterLabel = UILabel(frame: CGRect())
        descriptionLabel = UILabel(frame: CGRect())
        counterHostView = UIView(frame: CGRect())
        fadeAnimationHelper = RangeAnimationHelper(animationStart: 0.3, animationEnd: 0.5)
        slideAnimationHelper = RangeAnimationHelper(animationStart: 0.4, animationEnd: 0.7)
        
        super.init(frame: frame)
        setupSubviews(ringMeter: ringMeter)
    }
    
    required init?(coder aDecoder: NSCoder) { //ugh!
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAnimationProgress(progress: Float) {
        setFadeAnimationState(progress: progress)
        setSlideAnimationProgress(progress: progress)
    }
}

private extension ProgressTextView {
    
    func setupSubviews(ringMeter: RingMeter) {
        setupSubviewFrames()
        setupSubviewVisuals(ringMeter: ringMeter)
    }
    
    func setupSubviewFrames() {
        var frame = self.frame
        frame.origin = CGPoint.zero
        frame.size.height *= counterDescriptionRatio
        counterHostView.frame = frame
        
        counterLabel.frame = frame
        counterHostView.addSubview(counterLabel)
        
        frame.origin.y = frame.size.height
        frame.size.height = self.frame.size.height - frame.size.height
        descriptionLabel.frame = frame
        
        addSubview(counterHostView)
        addSubview(descriptionLabel)
    }
    
    func setupSubviewVisuals(ringMeter: RingMeter) {
        counterLabel.font = UIFont.systemFont(ofSize: 90)
        counterLabel.text = String(ringMeter.value)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 28)
        descriptionLabel.text = "OF \(ringMeter.maxValue) \(ringMeter.title.uppercased())" //TODO lozalize
        
        counterLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        
        let color = UIColor.white
        counterLabel.textColor = color
        descriptionLabel.textColor = color
        
        counterHostView.clipsToBounds = true
    }
    
    func setFadeAnimationState(progress: Float) {
        alpha = CGFloat(fadeAnimationHelper.normalizedProgress(progress))
    }
    
    func setSlideAnimationProgress(progress: Float) {
        let positionMultiplier = 1.0 - slideAnimationHelper.normalizedProgress(progress)
        counterLabel.frame.origin.y = counterHostView.frame.height * CGFloat(positionMultiplier)
    }
}
