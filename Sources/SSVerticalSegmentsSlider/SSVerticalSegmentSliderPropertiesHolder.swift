//
//  SSVerticalSegmentsPropertiesHolder.swift
//  SSVerticalSegmentsSlider
//
//  Created by Kiran Jasvanee - smartSense on 05/10/21.
//

import Foundation
import SwiftUI

class SSVerticalSegmentsPropertiesHolder {
    
    private static var verticalSegmentProperties: SSVerticalSegmentsPropertiesHolder? = nil
    static var shared: SSVerticalSegmentsPropertiesHolder? {
        if verticalSegmentProperties == nil {
            self.verticalSegmentProperties = SSVerticalSegmentsPropertiesHolder()
        }
        return verticalSegmentProperties ?? nil
    }
    
    var mainViewSizeFinalized: CGSize = CGSize.zero // holds main view size
    var mainViewFrame: CGRect = CGRect.zero         // holds main view frame
    var listOfFramesOfSegments: [Int: CGRect] = [:] // holds frames of all segments drawn inside main view.
    var heightOfSegments: CGFloat = 0.0             // just holds height of segments, so below getBenchmarks computed property can calculate benchmarks with help of heights of segments.
    
    var locationYofSegments: [CGFloat] = []         // holds yth origin of all segments drawn in main view.
    var lastProgressYlocation: CGFloat = 0.0        // holds last progress view's yth location. it will help to figure out finalizing progress when user drags really fast and we won't have proper location through 'onEnded' of drag gesture.
    
    func loadFramesOfSegments(_ frameOfSegment: CGRect, forIndex index: Int) {
        self.listOfFramesOfSegments[index] = frameOfSegment
    }
    var getBenchmarks: [CGFloat] {
        
        /*
         Calculates and returns benchmark values. Benchmarks are baseline yth position of each of those segments.
         */
        if locationYofSegments.isEmpty {
            
            var benchmarks: [Int: CGFloat] = [:]
            for (index, segmentFrame) in self.listOfFramesOfSegments {
                benchmarks[index] =  (segmentFrame.origin.y - mainViewFrame.origin.y) + heightOfSegments
            }
            let sortedKeys = Array(benchmarks.keys).sorted(by: {$0 < $1})
            // get sorted your frame values.
            for key in sortedKeys {
                if let value = benchmarks[key] {
                    self.locationYofSegments.append(value)
                }
            }
        }
        return self.locationYofSegments
    }
    
}
