import SwiftUI

struct ControlCardView: View {
    let control: ControlItem
    @State private var isPressed = false
    
    private var iconName: String {
        switch control.type {
        case .basic: return "textformat"
        case .layout: return "square.grid.2x2"
        case .container: return "square.3.stack.3d"
        case .selection: return "checkmark.circle"
        case .indicator: return "gauge"
        case .graphics: return "scribble"
        case .list: return "list.bullet"
        case .media: return "play.rectangle"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)
                
                Text(control.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
            }
            
            Text(control.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(
                    color: .gray.opacity(isPressed ? 0.1 : 0.2),
                    radius: isPressed ? 3 : 5,
                    x: 0,
                    y: isPressed ? 1 : 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .padding(.horizontal)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onTapGesture {
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    ControlCardView(
        control: ControlItem(
            title: "示例控件",
            description: "这是一个示例控件的详细描述，可能会比较长，需要显示多行",
            type: .basic
        )
    )
    .previewLayout(.sizeThatFits)
    .padding()
}