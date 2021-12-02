//
//  SSSegmentContentViews.swift
//  SSVerticalSegmentsSliderExamples
//
//  Created by Kiran Jasvanee - smartSense on 01/12/21.
//

import SwiftUI
import SSVerticalSegmentsSlider

struct ContentViewInvertedTriangleView: View {
    @State var selectedProgress: Int = 2
    
    var body: some View {
        VStack {
            SSVerticalSegmentsSlider(
                selectedProgress: self.$selectedProgress,
                totalSegments: 7)
            .onChange(of: selectedProgress) { newValue in
                print("Progress changed to \(selectedProgress)!")
            }
            .cornerRadius(12)
            HStack(alignment: .center, spacing: 0) {
                Text("Selected progress: ")
                    .fontWeight(.medium)
                Text("\(self.selectedProgress)")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
    }
}

struct ContentViewStraightSectionedView: View {
    @State var selectedProgress: Int = 2
    
    var body: some View {
        SSVerticalSegmentsSlider(
            selectedProgress: self.$selectedProgress,
            layoutOption: .straight(80),
            heightOfSegments: 40,
            gapBetweenSegments: 2,
            cornerRadiusForAllSegments: 0.0,
            cornerRadiusForFirstAndLastSegmentCornersOnly: 20)
        .onChange(of: selectedProgress) { newValue in
            print("Progress changed to \(selectedProgress)!")
        }
        .cornerRadius(12)
    }
}

struct ContentViewStraightTriangleView: View {
    @State var selectedProgress: Int = 2
    
    var body: some View {
        VStack {
            SSVerticalSegmentsSlider(
                selectedProgress: self.$selectedProgress,
                layoutOption: .triangle(18, 50),
                totalSegments: 7)
            .onChange(of: selectedProgress) { newValue in
                print("Progress changed to \(selectedProgress)!")
            }
            .cornerRadius(12)
            HStack(alignment: .center, spacing: 0) {
                Text("Selected progress: ")
                    .fontWeight(.medium)
                Text("\(self.selectedProgress)")
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
        }
    }
}


struct ContentView_Previews_1: PreviewProvider {
    static var previews: some View {
        ContentViewInvertedTriangleView()
    }
}

struct ContentView_Previews_2: PreviewProvider {
    static var previews: some View {
        ContentViewStraightSectionedView()
    }
}

struct ContentView_Previews_3: PreviewProvider {
    static var previews: some View {
        ContentViewStraightTriangleView ()
    }
}
