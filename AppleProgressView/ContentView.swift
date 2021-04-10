//
//  ContentView.swift
//  AppleProgressView
//
//  Created by Terry Kuo on 2021/4/9.
//

import SwiftUI

struct ContentView: View {
    
    let gradientColors: [Color] = [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))]
    let sliceSize = 0.35
    @State var progress: Double = 0.3
    
    
    private let percentageFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }()
    
    private var strokeGradient: AngularGradient {
        return AngularGradient(gradient: Gradient(colors: self.gradientColors), center: .center, angle: .degrees(-10) )
    }
    
    private func strokeStyle(with geometry: GeometryProxy) -> StrokeStyle {
        return StrokeStyle(lineWidth: 0.12 * min(geometry.size.width, geometry.size.height), lineCap: .round)
    }
    
//    init(_ progress: Double = 0.3) {
//        self.progress = progress
//    }
    private var fullTrimSize: CGFloat {
        //print("Full Trim Size is \(1 - CGFloat(self.sliceSize))")
        return 1 - CGFloat(self.sliceSize) //0.65
    }
    
    private var progressSize: CGFloat {
        if (fullTrimSize * CGFloat(self.progress)) < 0.64 {
            //print("now its:\(fullTrimSize * CGFloat(self.progress))")
            return fullTrimSize * CGFloat(self.progress)
            
        } else {
            //print("its full")
            //print("FULL: \(fullTrimSize * CGFloat(self.progress))")
            return 0.65
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                if self.progress < 1 {
                    self.progress += 0.25
                } else {
                    self.progress = 1
                }
            }) {
                Image(systemName: "star")
                    .font(.system(size: 40))
            }
            GeometryReader { geometry in
                ZStack {
                    Group {
                        Circle() //Full Bar
                            .trim(from: 0, to: fullTrimSize)
                            .stroke(self.strokeGradient, style: self.strokeStyle(with: geometry))
                            .opacity(0.5)
                            //.animation(.easeInOut(duration: 1))
                        Circle() //Progress Bar
                            .trim(from: 0, to: progressSize)
                            .stroke(self.strokeGradient, style: self.strokeStyle(with: geometry))
                    }
                    .rotationEffect(Angle.degrees(90) + Angle.degrees(360 * self.sliceSize / 2))
                    
                    
                    if self.progress >= 0.995 {
                        Image(systemName: "star.fill")
                            .font(.system(size: 0.4 * min(geometry.size.width, geometry.size.height), weight: .bold, design: .rounded))
                            .foregroundColor(Color.yellow)
                            //.offset(y: -0.05 * min(geometry.size.width, geometry.size.height))
                            //.animation(.spring())
                    } else {
                        Text(self.percentageFormatter.string(from: self.progress as NSNumber)!)
                            .font(.system(size: 0.3 * min(geometry.size.width, geometry.size.height), weight: .bold, design: .rounded))
                            //.offset(y: -0.05 * min(geometry.size.width, geometry.size.height))
                            //.animation(.spring())
                    }
                    
                    
                } //Zstack
                //.offset(y: 0.1 * min(geometry.size.width, geometry.size.height))
            }
            .padding(40)
            //.background(Color(UIColor.systemBackground))
            //.cornerRadius(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.sizeThatFits)
    }
}
