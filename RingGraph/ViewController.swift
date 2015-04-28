//
//  ViewController.swift
//  RingGraph
//
//  Created by Michał Kreft on 13/04/15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var graphViews = [RingGraphView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trianglePath = TrianglePathProvider()
        let rightArrowPath = RightArrowPathProvider()
        
        let tripleGraphMeters = [RingMeter(title: "Move", value: 100, maxValue: 100, colors: [AppleBlue1, AppleBlue2], symbolProvider: rightArrowPath),
            RingMeter(title: "Exercise", value: 72, maxValue: 100, colors: [AppleGreen1, AppleGreen2], symbolProvider: DoubleRightArrowPathProvider()),
            RingMeter(title: "Stand", value: 45, maxValue: 100, colors: [AppleRed1, AppleRed2], symbolProvider: UpArrowPathProvider())]
        
        let singleGraphMeter = [RingMeter(title: "Move", value: 70, maxValue: 100, colors: [AppleRed1, AppleRed2])]
        
        let color = UIColor.yellowColor()
        let singleColorGraphMeters = [RingMeter(title: "Move", value: 68, maxValue: 100, colors: [color]),
            RingMeter(title: "Exercise", value: 63, maxValue: 100, colors: [color]),
            RingMeter(title: "Stand", value: 40, maxValue: 100, colors: [color])]
        
        if let graph = RingGraph(meters: tripleGraphMeters) {
            let frame = CGRect(x: 160, y: 260, width: 300, height: 300)
            let ringGraphView = RingGraphView(frame: frame, graph: graph, preset: .MetersDescription)
            view.addSubview(ringGraphView)
            graphViews.append(ringGraphView)
        }
        
        if let graph = RingGraph(meters: singleGraphMeter) {
            let frame = CGRect(x: 540, y: 260, width: 300, height: 300)
            let ringGraphView = RingGraphView(frame: frame, graph: graph, preset: .CentralDescription)
            view.addSubview(ringGraphView)
            graphViews.append(ringGraphView)
        }
        
        for i in 0..<3 {
            if let graph = RingGraph(meters: singleColorGraphMeters) {
                let frame = CGRect(x: 160 + i * 70, y: 150, width: 50, height: 50)
                let ringGraphView = RingGraphView(frame: frame, graph: graph, preset: .None)
                view.addSubview(ringGraphView)
                graphViews.append(ringGraphView)
            }
        }
    }
    
    @IBAction func animateButtonTapped(sender: AnyObject) {
        for graphView in graphViews {
            graphView.animateGraph()
        }
    }
}

