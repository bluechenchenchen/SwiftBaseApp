import SwiftUI

// MARK: - 辅助视图
struct RangeSlider: View {
  @Binding var range: ClosedRange<Double>
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        Rectangle()
          .fill(Color.gray.opacity(0.2))
        
        Rectangle()
          .fill(Color.blue)
          .frame(width: geometry.size.width * CGFloat(range.upperBound - range.lowerBound))
          .offset(x: geometry.size.width * CGFloat(range.lowerBound))
        
        HStack {
          Circle()
            .fill(.white)
            .frame(width: 20, height: 20)
            .shadow(radius: 2)
            .offset(x: geometry.size.width * CGFloat(range.lowerBound) - 10)
            .gesture(
              DragGesture()
                .onChanged { value in
                  let newValue = Double(value.location.x / geometry.size.width)
                  range = min(newValue, range.upperBound - 0.1)...range.upperBound
                }
            )
          
          Circle()
            .fill(.white)
            .frame(width: 20, height: 20)
            .shadow(radius: 2)
            .offset(x: geometry.size.width * CGFloat(range.upperBound) - 10)
            .gesture(
              DragGesture()
                .onChanged { value in
                  let newValue = Double(value.location.x / geometry.size.width)
                  range = range.lowerBound...max(newValue, range.lowerBound + 0.1)
                }
            )
        }
      }
    }
  }
}
