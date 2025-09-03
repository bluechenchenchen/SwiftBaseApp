import SwiftUI

struct CategorySection: View {
    let type: ControlType
    let controls: [ControlItem]
    let destinationView: (ControlItem) -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            CategoryHeaderView(title: type.title)
            ForEach(controls) { control in
                NavigationLink(
                    destination: destinationView(control)
                ) {
                    ControlCardView(control: control)
                }
            }
        }
    }
}

#Preview {
    CategorySection(
        type: .basic,
        controls: [
            ControlItem(title: "示例控件1", description: "描述1", type: .basic),
            ControlItem(title: "示例控件2", description: "描述2", type: .basic)
        ],
        destinationView: { _ in AnyView(Text("示例视图")) }
    )
}
