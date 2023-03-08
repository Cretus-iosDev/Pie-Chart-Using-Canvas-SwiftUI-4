

import SwiftUI

struct ContentView: View {
    var body: some View {
       Pie()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct PieModel: Identifiable {
    let id = UUID()
    var value: Double
    var color: Color
    var name: String
}

extension PieModel {
    static var sample: [PieModel] {
        [
            .init(value: 10, color: .orange, name: "Orange"),
            .init(value: 20, color: .blue, name: "blue"),
            .init(value: 30, color: .indigo, name: "indigo"),
            .init(value: 40, color: .purple, name: "purple"),
            .init(value: 50, color: .cyan, name: "cyan"),
            .init(value: 60, color: .teal, name: "teal"),
        ]
    }
}

struct Pie: View {
    
    @State private var animate = true
    @State private var slices = PieModel.sample
    
    var body: some View {
        VStack {
            Canvas { context,size in
                let total = slices.reduce(0) { $0 + $1.value }
                context.translateBy(x: size.width/2, y: size.height/2)
                
                var pieContext = context
                pieContext.rotate(by: .degrees(90))
                
                let radius = min (size.width,size.height) * 0.45
                
                var startAngle = Angle.zero
                for slice in slices {
                    let angle = Angle(degrees: 360 * (slice.value/total))
                    let endAngle = startAngle + angle
                    
                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: radius,startAngle: startAngle,endAngle: endAngle,clockwise: false)
                        p.closeSubpath()
                    }
                    
                    
                    pieContext.fill(path,with: .color(slice.color.opacity(0.6)))
                    pieContext.stroke(path,with: .color(slice.color), lineWidth: 3)
                    startAngle = endAngle
                    
                }
            }
            .rotationEffect(animate ?  .zero: .degrees(270), anchor: .center)
            .scaleEffect(animate ? 1.0 : 0.0, anchor: .center)
            .aspectRatio(1, contentMode: .fit)
            
            
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
                    ForEach(slices) { slice in
                        HStack {
                            Circle()
                                .foregroundStyle(slice.color
                                    .gradient)
                                .frame(width: 20)
                            Text(slice.name)
                        }
                    }
                }
            }
            .onTapGesture {
                withAnimation(Animation.spring(dampingFraction: 0.3)) {
                    animate.toggle()
                    
                }
            }
        }
        
    }
    
}
