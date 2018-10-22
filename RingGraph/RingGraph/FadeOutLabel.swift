//
//  FadeOutLabel.swift
//  RingMeter
//
//  Created by Michał Kreft on 07/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

class FadeOutLabel: UILabel {
    private var originalText: String?
    private var lastFadeCharacterIndex = 0
    private var lastFadeCharacterAlpha: Float = 1.0
    private var animationHelper: RangeAnimationHelper
    
    override init(frame: CGRect) {
        animationHelper = RangeAnimationHelper(animationStart: 0.3, animationEnd: 0.7)
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var text: String? {
        didSet {
            originalText = text
            updateDisplayedText()
        }
    }
    
    func setAnimationProgress(progress: Float) {
        updateStateForProgress(progress)
        updateDisplayedText()
    }
}

private extension FadeOutLabel {
    
    func updateStateForProgress(_ progress: Float) {
        let normalizedProgress = animationHelper.normalizedProgress(progress)
        
        switch normalizedProgress {
            case 0.0:
                lastFadeCharacterIndex = 0
                lastFadeCharacterAlpha = 1.0
            case 1.0:
                lastFadeCharacterIndex = originalText != nil ? (originalText!).count - 1 : 0
                lastFadeCharacterAlpha = 0.0
            default:
                let intProgress = Int(normalizedProgress * 100)
                let lettersCount = (originalText != nil) ? (originalText!).count : 1
                let letterSpan = 100 / lettersCount
                lastFadeCharacterIndex = intProgress / letterSpan
                lastFadeCharacterAlpha = 1 - Float(intProgress % letterSpan) / Float(letterSpan)
        }
    }
    
    func updateDisplayedText() {
        if let text = self.shiftedText() {
            if (text.count == 0) {
                super.text = text
            } else {
                let color = self.textColor.withAlphaComponent(CGFloat(lastFadeCharacterAlpha))
                let range = NSRange(location: 0, length: 1)
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
                self.attributedText = attributedString
            }
        } else {
            super.text = nil
        }
    }
    
    func shiftedText() -> String? {
        var shiftedText: String?
        
        if let originalText = originalText {
            //let index = originalText.startIndex.advanced(lastFadeCharacterIndex)
            let index = originalText.index(originalText.startIndex, offsetBy: lastFadeCharacterIndex)
            shiftedText = String(originalText[index...])
        }
        
        return shiftedText
    }
}
