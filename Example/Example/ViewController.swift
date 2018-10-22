//
//  ViewController.swift
//  Example
//
//  Created by Kreft, Michal on 07.06.15.
//  Updated by Sebastien REMY on 06.2016, 09.2016
//  Copyright (c) 2015 yomajkel. All rights reserved.
//

import UIKit
import RingGraph

class ViewController: UIViewController {
    
    @IBOutlet weak var ringGraphMetersView: RingGraphView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    var graphViews = [RingGraphView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        drawRing()
    }
    
    @IBAction func segmentedControlValueChanged() {
        drawRing()
    }
    
    @IBAction func animateButtonTapped(sender: AnyObject) {
        for graphView in graphViews {
            graphView.animateGraph()
        }
    }
    
    func drawRing() {
        ringGraphMetersView.subviews.forEach({$0.removeFromSuperview()})
        graphViews = []
        
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Triple Graph Meters
            let tripleGraphMeters = [RingMeter(title: "Move", value: 100, maxValue: 100, colors: [AppleBlue1, AppleBlue2], symbolProvider: RightArrowPathProvider()),
                                     RingMeter(title: "Exercise", value: 72, maxValue: 100, colors: [AppleGreen1, AppleGreen2], symbolProvider: DoubleRightArrowPathProvider()),
                                     RingMeter(title: "Stand", value: 45, maxValue: 100, colors: [AppleRed1, AppleRed2], symbolProvider: ImageProvider(image: UIImage(named: "QuestionMark")))]
            
            if let graph = RingGraph(meters: tripleGraphMeters) {
                let viewFrame = ringGraphMetersView.frame
                let ringFrame = CGRect(x: 0, y: 0, width: viewFrame.width, height: viewFrame.height)
                let ringGraphView = RingGraphView(frame: ringFrame, graph: graph, preset: .MetersDescription)
                ringGraphMetersView.addSubview(ringGraphView)
                graphViews.append(ringGraphView)
            }
            
        case 1:
            // Single Graph Meter
            let singleGraphMeter = [RingMeter(title: "Move", value: 70, maxValue: 100, colors: [AppleRed1, AppleRed2])]
            
            if let graph = RingGraph(meters: singleGraphMeter) {
                let viewFrame = ringGraphMetersView.frame
                let ringFrame = CGRect(x: 0, y: 0, width: viewFrame.width, height: viewFrame.height)
                let ringGraphView = RingGraphView(frame: ringFrame, graph: graph, preset: .CentralDescription)
                ringGraphMetersView.addSubview(ringGraphView)
                graphViews.append(ringGraphView)
            }
            
        case 2:
            // Color Graph Meters
            let color = UIColor.yellow
            let singleColorGraphMeters = [RingMeter(title: "Move", value: 68, maxValue: 100, colors: [color]),
                                          RingMeter(title: "Exercise", value: 63, maxValue: 100, colors: [color]),
                                          RingMeter(title: "Stand", value: 40, maxValue: 100, colors: [color])]
            
            for i in 0..<3 {
                if let graph = RingGraph(meters: singleColorGraphMeters) {
                    let viewFrame = ringGraphMetersView.frame
                    let frame = CGRect(x: Int(viewFrame.width - 190) / 2 + i * 70, y: Int(viewFrame.height - 50) / 2, width: 50, height: 50)
                    let ringGraphView = RingGraphView(frame: frame, graph: graph, preset: .None)
                    ringGraphMetersView.addSubview(ringGraphView)
                    graphViews.append(ringGraphView)
                }
            }
            
        default:
            break
        }
        
    }
}



