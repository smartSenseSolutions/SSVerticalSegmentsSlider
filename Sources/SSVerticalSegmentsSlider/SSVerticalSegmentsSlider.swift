//
//  SSVerticalSegmentsSlider.swift
//  SSVerticalSegmentsSlider
//
//  Created by Kiran Jasvanee - smartSense on 05/10/21.
//

import SwiftUI

// Usage...
struct SSVerticalSegmentSliderContentView_Previews: PreviewProvider {
    static var previews: some View {
        SSVerticalSegmentsSliderContentView()
    }
}

struct SSVerticalSegmentsSliderContentView: View {
    
    @State var selectedProgress: Int = 3
    
    var body: some View {
        VStack {
            SSVerticalSegmentsSlider(selectedProgress: self.$selectedProgress)
            .onChange(of: selectedProgress) { newValue in
                debugPrint("Progress changed to \(selectedProgress)!") // progress change event.
            }
            Text("Selected progress: \(self.selectedProgress)")
        }
    }
}

// Lib work...
public struct SSVerticalSegmentsSlider: View {
    
    // Should be public: LayoutOptions will be accessible outside also to let user allow to set it from outside of this library. Its initialization will be done through 'public init', which mandates us to delcare this enum public, or compiler will through an error.
    public enum LayoutOptions {
        case invertedTriangle(CGFloat, Int), triangle(CGFloat, Int), straight(CGFloat)
    }
    
    var totalSegments: Int = 6
    @State private var textSize: CGSize = CGSize.zero
    
    var contentOffSetGap: CGFloat = 12.0    // offset around content
    var heightOfSegments: CGFloat = 20.0    // segment height
    var gapBetweenSegments: CGFloat = 15.0   // gap between segments
    var cornerRadiusForAllSegments: CGFloat = 8.0   // corner radius for all segments.
    var cornerRadiusForFirstAndLastSegmentCornersOnly: CGFloat = 0.0 // corner radius only for first & last segment.
    var layoutOption: LayoutOptions = .invertedTriangle(40, 50)
    var backgroundColor: Color = Color.gray.opacity(0.16)
    var segmentTrackColor: Color = Color.gray.opacity(0.60)
    var segmentTintColor: Color = Color.blue
    
    @Binding var selectedProgress: Int // set default selected progress when layout renders for the first time.
    
    // Public Init for developers
    public init(selectedProgress: Binding<Int> = .constant(0),
                layoutOption: LayoutOptions = .invertedTriangle(40, 50),
                totalSegments: Int = 6,
                heightOfSegments: CGFloat = 20.0,
                gapBetweenSegments: CGFloat = 15.0,
                contentOffSetGap: CGFloat = 12.0,
                backgroundColor: Color = Color.gray.opacity(0.16),
                segmentTrackColor: Color = Color.gray.opacity(0.60),
                segmentTintColor: Color = Color.blue,
                cornerRadiusForAllSegments: CGFloat = 8.0,
                cornerRadiusForFirstAndLastSegmentCornersOnly: CGFloat = 0.0) {
        
        self._selectedProgress = selectedProgress
        self.layoutOption = layoutOption
        self.totalSegments = totalSegments
        self.heightOfSegments = heightOfSegments
        self.gapBetweenSegments = gapBetweenSegments
        self.contentOffSetGap = contentOffSetGap
        self.backgroundColor = backgroundColor
        self.segmentTrackColor = segmentTrackColor
        self.segmentTintColor = segmentTintColor
        self.cornerRadiusForAllSegments = cornerRadiusForAllSegments
        self.cornerRadiusForFirstAndLastSegmentCornersOnly = cornerRadiusForFirstAndLastSegmentCornersOnly
    }
    
    // Body handling...
    public var body: some View {
        VStack {
            SSVerticalSegmentsSlidersView.init(totalSegments: self.totalSegments,
                                             size: $textSize,
                                             contentOffSetGap: self.contentOffSetGap,
                                             heightOfSegment: self.heightOfSegments,
                                             gapBetweenSegments: self.gapBetweenSegments,
                                             cornerRadiusForAllSegments: self.cornerRadiusForAllSegments,
                                             cornerRadiusForFirstAndLastSegmentCornersOnly: self.cornerRadiusForFirstAndLastSegmentCornersOnly,
                                             layoutOption: self.layoutOption,
                                             selectedProgress: self.$selectedProgress,
                                             segmentTrackColor: self.segmentTrackColor,
                                             segmentTintColor: self.segmentTintColor)
                .frame(width: self.textSize.width,
                       height: self.textSize.height,
                       alignment: .center)
                .background(self.backgroundColor)
                .onAppear(perform: {
                    /*
                    When user finalizing progress by dragging really fast, onAppear will help us to render perfect height of the progress.
                     */
                    SSVerticalSegmentsPropertiesHolder.shared?.heightOfSegments = self.heightOfSegments
                })
            
        }
    }
}

struct SSVerticalSegmentsSlidersView: View {
    @State var heightOfProgress: CGFloat = 0.0
    
    var totalSegments: Int
    @Binding var size: CGSize
    var contentOffSetGap: CGFloat
    var heightOfSegment: CGFloat
    var gapBetweenSegments: CGFloat
    var cornerRadiusForAllSegments: CGFloat
    var cornerRadiusForFirstAndLastSegmentCornersOnly: CGFloat
    var layoutOption: SSVerticalSegmentsSlider.LayoutOptions
    @Binding var selectedProgress: Int
    var segmentTrackColor: Color
    var segmentTintColor: Color
    
    
    func increaseOrDecreaseHeight(ythLocationOfDragging: CGFloat) {
        // Without benchmarks.
        self.heightOfProgress = self.size.height - ythLocationOfDragging // calculating progress height.
        SSVerticalSegmentsPropertiesHolder.shared?.lastProgressYlocation = ythLocationOfDragging // last - yth location detected...
    }
    func finalizeProgress(ythLocationOfDragging: CGFloat) {
        
        if let progressLocationBenchmarks = SSVerticalSegmentsPropertiesHolder.shared?.getBenchmarks {
            
            var benchmarkIndex = -1
            for index in 0..<progressLocationBenchmarks.count {
                // debugPrint("benchmark value: \(progressLocationBenchmarks[index])")
                /*
                 if benchmark yth location crossed by user drag,
                 then it is fetching its segment index, that has been crossed.
                 */
                if ythLocationOfDragging < progressLocationBenchmarks[index] {
                    benchmarkIndex = index
                }
            }
            // debugPrint("index to benchmark: \(benchmarkIndex)")
            self.heightOfProgress = self.size.height - ythLocationOfDragging // just setting end progress, doesn't matter if you are keeping or not.
            
            // set final bench mark
            if benchmarkIndex >= 0 {
                /*
                 Get benchmark value which has been crossed. Benchmark values of segments starts from the bottom side of the view (not the top side).
                 To select full segment, you need to add height of segment with benchmark value. This code has been written below to get height of progress view.
                 Height applied to progress view to have the highlighted progress started from bottom side of super view.
                 */
                self.heightOfProgress = (self.size.height - progressLocationBenchmarks[benchmarkIndex]) + heightOfSegment
                self.selectedProgress = benchmarkIndex + 1 // passing selected index of progress. As it starts from 0, add +1
            }
        }
    }
    
    // Set heighlighted progress
    private func setProgress() {
        guard let progressLocationBenchmarks = SSVerticalSegmentsPropertiesHolder.shared?.getBenchmarks else{ return }
        guard progressLocationBenchmarks.indices.contains(self.selectedProgress-1) else{
            debugPrint("SSVerticalSegmentSlider Error: Selected progress out of bounds. Segment not available at index passed!")
            return
        }
        self.heightOfProgress = (self.size.height - progressLocationBenchmarks[self.selectedProgress-1]) + heightOfSegment
    }
    
    @GestureState private var dragGestureActive: Bool = false
    var isDragEndedCalled: Bool = false
    
    var body: some View {
        if totalSegments > 1 {
            VStack {
                RoundedRectangle.init(cornerRadius: 0)
                    .foregroundColor(self.segmentTrackColor)
                    .background(
                        GeometryReader {geometry -> Color in
                            let frameOfMainView = geometry.frame(in: .global)
                            // debugPrint("frame of main view: \(frameOfMainView)")
                            // Holds the main view frame, the actual frame of our component.
                            SSVerticalSegmentsPropertiesHolder.shared?.mainViewFrame = frameOfMainView
                            return Color.clear
                        }
                        
                    )
                    .overlay(
                        // Heighlighted Progress View
                        Rectangle.init()
                            .foregroundColor(self.segmentTintColor)
                            .frame(width: self.size.width, height: self.heightOfProgress, alignment: .bottom)
                        
                    , alignment: .bottom) // starts from bottom..
                    .gesture(
                        DragGesture(minimumDistance: 5)
                            .updating($dragGestureActive) { value, state, transaction in
                                state = true
                            }
                            .onChanged { value in
                                // debugPrint("Starting location: \(CGPoint.init(x: value.location.x, y: value.location.y))")
                                
                                /*
                                 Condition detects that drag is inside the area of our component.
                                 This portion will going to change height of progress view to highlight progress while dragging.
                                 */
                                if value.location.y >= 0 &&
                                    value.location.y <= self.size.height{
                                    increaseOrDecreaseHeight(ythLocationOfDragging: value.location.y)
                                }
                            }
                            .onEnded { value in
                                // debugPrint("Ending location: \(value)")
                                if value.location.y >= 0 &&
                                    value.location.y <= self.size.height{
                                    /*
                                     Will going to finalize your progress. Suppose, you've dragged up to the middle of any segment. It completes that whole segment with tint color.
                                     */
                                    finalizeProgress(ythLocationOfDragging: value.location.y)
                                }else{
                                    /*
                                     This will going to finalize your progress. Suppose, you've dragging so fast and went outside of your dragging area, then we will fix your progress based on last dragging location fetched using 'onChanged' gesture event.
                                     */
                                    finalizeProgress(ythLocationOfDragging: SSVerticalSegmentsPropertiesHolder.shared?.lastProgressYlocation ?? 0.0)
                                }
                            }
                    )
                    .onChange(of: dragGestureActive) { newIsActiveValue in
                        if newIsActiveValue == false {
                            // debugPrint("Drag cancelled")
                            // In scrollview, when drag cancelled without informing drag gesture at 'onEnded' method. This block will be called always when drag gesture ends, no matter where its being used in tableview, scrollview or any other container.
                            finalizeProgress(ythLocationOfDragging: SSVerticalSegmentsPropertiesHolder.shared?.lastProgressYlocation ?? 0.0)
                        }
                    }
                    .mask(
                        // Masking Segements.
                        SSVerticalSegmentsSliderMaskedView.init(
                            noOfSignals: self.totalSegments,
                            size: $size,
                            contentOffSetGap: self.contentOffSetGap,
                            heightOfSegment: self.heightOfSegment,
                            gapBetweenSegments: self.gapBetweenSegments,
                            cornerRadiusForAllSegments: self.cornerRadiusForAllSegments,
                            cornerRadiusForFirstAndLastSegmentCornersOnly: self.cornerRadiusForFirstAndLastSegmentCornersOnly,
                            layoutOption: self.layoutOption)
                    )
                    /*
                     Below code will fulfill the use-case of setting progress once main view size decided based on segments and spaces set by developer.
                     To know how we are deciding view size, check 'SSVerticalSegmentsSliderMaskedView' code. We are deciding size of the main view according to content. Once content drawn, we are figuring out and setting using onAppear().
                     Below setProgress() function will be called to set default selected progress passed by developer once component's final size set.
                     */
                    .onChange(of: size) { newValue in
                        // debugPrint("Size changed to \(size)!") // incase you want to fire any event upon selection.
                        setProgress()
                    }
            }
            .gesture(DragGesture(minimumDistance: 0).onEnded({ (value) in
                // debugPrint(value.location) // Location of the tap, as a CGPoint.
                finalizeProgress(ythLocationOfDragging: value.location.y)
            }))
        }else{
            VStack {
                Text.init("Please provide strength more than 1")
            }
        }
    }
}


struct SSVerticalSegmentsSliderMaskedView: View {
    var noOfSignals: Int
    @Binding var size: CGSize
    var contentOffSetGap: CGFloat = 0.0
    var heightOfSegment: CGFloat = 0.0
    var gapBetweenSegments: CGFloat
    var cornerRadiusForAllSegments: CGFloat
    var cornerRadiusForFirstAndLastSegmentCornersOnly: CGFloat
    var layoutOption: SSVerticalSegmentsSlider.LayoutOptions
    
    func getWidthAccordingToLayoutOptionSelected(usingIndex index: Int,
                                                 withTotalSegments total: Int) -> CGFloat{
        switch self.layoutOption {
        case .invertedTriangle(let width, let widerPercent):
            guard width > 8.0 else{
                debugPrint("Width of the first segment must be greater than 8, so we can layout other progressive segments based on it.")
                return 8.0
            }
            var calculatedWidthOfSegment = width
            if widerPercent > 0 && widerPercent <= 100 {
                let widerPercent = Double(widerPercent)*0.01
                // from below triangle layout, only difference is to use + rather than using - while calculating width.
                calculatedWidthOfSegment = width+(width*(widerPercent*Double(index)))
            }else{
                debugPrint("To make segment wider than the previous one, set percentage between 1 to 100...")
            }
            return calculatedWidthOfSegment
        case .triangle(let width, let widerPercent):
            guard width > 8.0 else{
                debugPrint("Width of the first segment must be greater than 8, so we can layout other progressive segments based on it.")
                return 8.0
            }
            var calculatedWidthOfSegment = width
            if widerPercent > 0 && widerPercent <= 100 {
                let widerPercent = Double(widerPercent)*0.01
                // from above inverted triangle layout, only difference is to use - rather than + while calculating width.
                calculatedWidthOfSegment = width+(width*(widerPercent*Double(total-index)))
            }else{
                debugPrint("To make segment wider than previous one, set percentage between 1 to 100...")
            }
            return calculatedWidthOfSegment
        case .straight(let width):
            return width
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: self.gapBetweenSegments, content: {
            ForEach.init((0..<self.noOfSignals).reversed(), id: \.self) { index in
                /*
                 Masked segments to be shown above super view.
                 */
                Group {
                    // It is the first segment, and if do we have specific corners to apply?, if yes, this code helps to apply
                    if index == (self.noOfSignals-1) && self.cornerRadiusForFirstAndLastSegmentCornersOnly > 0.0{
                        
                        Rectangle()
                            .cornerRadiusBySSVertical(self.cornerRadiusForFirstAndLastSegmentCornersOnly, corners: [.topLeft, .topRight])
                            .cornerRadiusBySSVertical(self.cornerRadiusForAllSegments, corners: [.bottomLeft, .bottomRight])
                    }else if index == 0  && self.cornerRadiusForFirstAndLastSegmentCornersOnly > 0.0{
                        // It is the last segment, and if do we have specific corners to apply?, if yes, this code helps to apply
                        
                        Rectangle()
                            .cornerRadiusBySSVertical(self.cornerRadiusForFirstAndLastSegmentCornersOnly, corners: [.bottomLeft, .bottomRight])
                            .cornerRadiusBySSVertical(self.cornerRadiusForAllSegments, corners: [.topLeft, .topRight])
                    }else{
                        // Generic corners for all segments...
                        Rectangle()
                            .cornerRadius(self.cornerRadiusForAllSegments)
                    }
                }
                .frame(width: getWidthAccordingToLayoutOptionSelected(usingIndex: index, withTotalSegments: self.noOfSignals-1),
                       height: heightOfSegment)
                .offset(y: 0)
                .background(
                    GeometryReader {geometry -> Color in
                        let frameOfSegment = geometry.frame(in: .global)
                        // debugPrint("size of rounded rectangle: \(frameOfSegment) at position: \(index)")
                        SSVerticalSegmentsPropertiesHolder.shared?.loadFramesOfSegments(frameOfSegment, forIndex: index)
                        return Color.clear
                    }
                )
            }
        })
        .background(
            GeometryReader {gp -> Color in
                
                SSVerticalSegmentsPropertiesHolder.shared?.mainViewSizeFinalized = CGSize.init(width: gp.size.width + self.contentOffSetGap*2, height: gp.size.height + self.contentOffSetGap*2)
                   
                return Color.clear
        })
        .onAppear(perform: {
            setMainViewSize()
        })
    }
    
    func setMainViewSize() {
        // Set main view size as per the content.
        self.size = SSVerticalSegmentsPropertiesHolder.shared?.mainViewSizeFinalized ?? CGSize.zero
    }
}


// Extensions...
extension View {
    func cornerRadiusBySSVertical(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCornerBySSVertical(radius: radius, corners: corners) )
    }
}
struct RoundedCornerBySSVertical: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

