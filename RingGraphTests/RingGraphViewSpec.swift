//
//  RingGraphViewSpec.swift
//  RingGraph
//
//  Created by Kreft, Michal on 18.05.15.
//  Copyright (c) 2015 Michał Kreft. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots

class RingGraphViewSpec: QuickSpec {
    
    let helper = TestsHelper()

    override func spec() {
        describe("in MetersDescription preset", { () -> Void in
            
            it("has valid snapshot with meters on 100%") {
                let tripleGraphMeters = self.helper.tripleGraphMeters(value: 100)
                let graph = RingGraph(meters: tripleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
            
            it("has valid snapshot with meters on 50%") {
                let tripleGraphMeters = self.helper.tripleGraphMeters(value: 50)
                let graph = RingGraph(meters: tripleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
        })
        
        describe("in CentralDescription preset", { () -> Void in
            
            it("has valid snapshot with meter on 100%") {
                let singleGraphMeters = self.helper.singleGraphMeters(value: 100)
                let graph = RingGraph(meters: singleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
            
            it("has valid snapshot with meters on 50%") {
                let singleGraphMeters = self.helper.singleGraphMeters(value: 50)
                let graph = RingGraph(meters: singleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
        })
        
        describe("in None preset", { () -> Void in
            
            it("has valid snapshot with meter on 100%") {
                let tripleGraphMeters = self.helper.tripleSingleColorGraphMeters(value: 100)
                let graph = RingGraph(meters: tripleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
            
            it("has valid snapshot with meters on 50%") {
                let tripleGraphMeters = self.helper.tripleSingleColorGraphMeters(value: 50)
                let graph = RingGraph(meters: tripleGraphMeters)
                let ringGraphView = RingGraphView(frame: self.helper.defaultFrame(), graph: graph!, preset: .MetersDescription)
                
                expect(ringGraphView).to(haveValidSnapshot())
            }
        })
    }

}
