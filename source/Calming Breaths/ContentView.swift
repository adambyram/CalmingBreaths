//
//  ContentView.swift
//  Calming Breaths
//
//  Created by Adam Byram on 3/29/20.
//  Copyright © 2020 Matter Reactor. All rights reserved.
//

import SwiftUI

struct GradientCircle: View {
    var body: some View {
        let color1 = Color.init(red: 81/255, green: 204/255, blue: 159/255)
        let color2 = Color.init(red: 154/255, green: 255/255, blue: 248/255)
        let spectrum = Gradient(colors: [ color1, color2])
        let conic =
            LinearGradient(gradient: spectrum, startPoint: UnitPoint(x: 0, y: 0.5), endPoint: UnitPoint(x: 0.5, y: 1))
        return Circle().fill(conic, style: FillStyle.init())
    }
}

struct ContentView: View {
    var petalCount: Double
    var size: CGFloat
    @State var scale: CGFloat
    @State var expanded: Bool = false
    
    var body: some View {
        let extra: Int = Double(petalCount) != Double(Int(petalCount)) ? 1 : 0
        let numberOfSides = Int(petalCount) + extra
        return
            GeometryReader {geometry in
                VStack {
                    
                        ZStack {
                            ForEach(Array(0..<numberOfSides), id: \.self) { i in
                                return GradientCircle()
                                    .frame(width: self.circleSize, height: self.circleSize)
                                    .opacity(self.getOpacity(at: i))
                                    .offset(x: self.getOffset(at: i).x, y: self.getOffset(at: i).y)
                            }
                        }
                
                }.edgesIgnoringSafeArea(.top)
            }.edgesIgnoringSafeArea(.top)
         .onTapGesture {
                withAnimation(.easeOut(duration: 4.0)) {
                    self.scale = self.expanded ? 0.1 : 1.0
            }
            self.expanded = !self.expanded
        }
    }
    
    var animatableData: AnimatablePair<Double, CGFloat> {
        get {return AnimatablePair(petalCount, scale)}
        set {
            petalCount = newValue.first
            scale = newValue.second
        }
    }
    
    private var rect: CGSize{
        return CGSize(width: size*scale, height: size*scale)
    }
    
    private var circleSize: CGFloat {
        return (rect.width + (1-scale)*rect.width)/2
    }
    
    private var radius: Double {
        let diameter = Double(min(rect.width, rect.height))/2.0
        return diameter/2.0
    }
    
    func getOpacity(at i: Int) -> Double {
        let maxOpacity = 0.55
        var opacity = petalCount - Double(i)
        opacity = max(0, min(1, opacity))
        return opacity*maxOpacity
    }
    
    func getOffset(at side: Int) -> CGPoint {
        let points = self.getPetalCenteres()
        let centerPoint = points[side]
        return self.getOffset(centerPoint)
    }
    
    /*
     We remove 2*radius instead of radius alone,
     because the views are already being drawed
     on the center of the container
     */
    func getOffset(_ center: CGPoint) -> CGPoint {
        return CGPoint(x: Double(center.x) - 2*radius, y: Double(center.y) - 2*radius)
    }
    
    func getPetalCenteres() -> [CGPoint] {
        let h = radius
        let center = CGPoint(x: rect.width/2, y: rect.height/2)
        
        var points: [CGPoint] = []
        
        let d = petalCount - Double(Int(petalCount)) > 0 ? 1 : 0
        
        for i in 0..<Int(petalCount) + d {
            let spinAngle = 90.0
            let additionalSpin = spinAngle * (1.0 - Double(self.scale))
            let angle = (Double(i) ) * (360/Double(petalCount)) + additionalSpin

            let angleInRad = angle*Double.pi/180
            
            let point = CGPoint(x: center.x + CGFloat(cos(angleInRad) * h), y: center.y + CGFloat(sin(angleInRad)*h))
            points.append(point)
        }
        return points
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
       
            ContentView(petalCount: 6, size: 300.0, scale: 1.0)
        
                    
        
    }
}
