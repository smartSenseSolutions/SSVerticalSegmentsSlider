//
//  SSSegmentInScrollView.swift
//  SSSegmentSliderExamples
//
//  Created by smartsense-kiran on 26/11/21.
//

import SwiftUI
import SSVerticalSegmentsSlider

struct SSSegmentInScrollView: View {
    @State var selectedProgress: Int = 1
    @State var selectedProgress1: Int = 2
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                Spacer().padding(.top)
                Text("ScrollView Workaround")
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                Divider().foregroundColor(.blue).padding(.bottom, 10)
                
                Group{
                    SSVerticalSegmentsSlider(selectedProgress: self.$selectedProgress)
                        .onChange(of: selectedProgress) { newValue in
                            print("Progress changed to \(selectedProgress)!")
                        }.padding(.bottom, 10)
                    HStack(alignment: .center, spacing: 0) {
                        Text("Selected progress: ")
                            .fontWeight(.medium)
                        Text("\(self.selectedProgress)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    Divider().foregroundColor(.black)
                }
                
                ZStack {
                    Circle()
                        .frame(width: 180, height: 180)
                        .foregroundColor(.red).opacity(0.8)
                    Text("Separator View")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                Group{
                    SSVerticalSegmentsSlider(selectedProgress: self.$selectedProgress1)
                        .onChange(of: selectedProgress1) { newValue in
                            print("Progress changed to \(selectedProgress1)!")
                        }
                    HStack(alignment: .center, spacing: 0) {
                        Text("Selected progress: ")
                            .fontWeight(.medium)
                        Text("\(self.selectedProgress1)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    Divider().foregroundColor(.red)
                }
            }
        })
    }
}

struct SSSegmentInScrollView_Previews: PreviewProvider {
    static var previews: some View {
        SSSegmentInScrollView()
    }
}
