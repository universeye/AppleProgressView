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
    @State var progress: Double = 0.2
    
    
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
        return 1 - CGFloat(self.sliceSize) //0.65
    }
    
    private var progressSize: CGFloat {
        if (fullTrimSize * CGFloat(self.progress)) < 0.64 {
            return fullTrimSize * CGFloat(self.progress)
        } else {
            return 0.65
        }
    }
    
    
    var body: some View {
        VStack {
            
            GeometryReader { geometry in
                VStack {
                    ZStack {
                        Group {
                            Circle() //Full Bar
                                .trim(from: 0, to: fullTrimSize)
                                .stroke(self.strokeGradient, style: self.strokeStyle(with: geometry))
                                .opacity(0.5)
                                .animation(nil)
                            Circle() //Progress Bar
                                .trim(from: 0, to: progressSize)
                                .stroke(self.strokeGradient, style: self.strokeStyle(with: geometry))
                        }
                        .frame(width: 300, height: 300)
                        .rotationEffect(Angle.degrees(90) + Angle.degrees(360 * self.sliceSize / 2))
                        
                        
                        if self.progress >= 0.995 {
                            Image(systemName: "star.fill")
                                .font(.system(size: 0.4 * min(geometry.size.width, geometry.size.height), weight: .bold, design: .rounded))
                                .foregroundColor(Color.yellow)
                                //.offset(y: -0.05 * min(geometry.size.width, geometry.size.height))
                                .animation(nil)
                        } else {
                            Text(self.percentageFormatter.string(from: self.progress as NSNumber)!)
                                .font(.system(size: 0.3 * min(geometry.size.width, geometry.size.height), weight: .bold, design: .rounded))
                                //.offset(y: -0.05 * min(geometry.size.width, geometry.size.height))
                                .animation(nil)
                        }
                        
                        
                    }
                    HStack(spacing: 30) {
                        Button(action: {
                            increment25()
                        }) {
                            Text("add 25%")
                                .font(.system(size: 20))
                        }
                        
                        Button(action: {
                            increment50()
                        }) {
                            Text("add 50%")
                                .font(.system(size: 20))
                        }
                        
                        Button(action: {
                            toZero()
                        }) {
                            Text("0%")
                                .font(.system(size: 20))
                        }
                    }
                }
                //.offset(y: 0.1 * min(geometry.size.width, geometry.size.height))
               
            }
            .padding(40)
            .frame(height: 430)
            //.background(Color(UIColor.systemBackground))
            //.cornerRadius(20)
        }
    }
    
    
    
    private func increment25() {
        withAnimation {
            if self.progress < 1 {
                self.progress += 0.25
            } else {
                self.progress = 1
            }
        }
    }
    
    private func increment50() {
        withAnimation {
            if self.progress < 1 {
                self.progress += 0.5
            } else {
                self.progress = 1
            }
        }
    }
    
    private func toZero() {
        withAnimation {
            self.progress = 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
