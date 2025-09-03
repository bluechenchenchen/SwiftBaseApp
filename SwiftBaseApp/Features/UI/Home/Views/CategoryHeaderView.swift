import SwiftUI

struct CategoryHeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
            .padding(.horizontal)
            .padding(.top)
    }
}

#Preview {
    CategoryHeaderView(title: "示例分类")
}
