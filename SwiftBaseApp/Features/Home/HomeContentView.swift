import SwiftUI

struct HomeContentView: View {
    // MARK: - Properties
    private let categories = [
        MainCategory(
            title: "UI 控件",
            description: "SwiftUI 基础控件和布局示例",
            icon: "square.grid.2x2",
            color: .blue,
            destination: AnyView(UIHomeContentView())
        ),
        MainCategory(
            title: "状态管理",
            description: "SwiftUI 状态管理和数据流",
            icon: "arrow.triangle.2.circlepath",
            color: .purple,
            destination: AnyView(StateManagementDemoView())
        ),
        MainCategory(
            title: "本地存储",
            description: "UserDefaults, CoreData, FileManager, Keychain",
            icon: "externaldrive",
            color: .green,
            destination: AnyView(LocalStorageDemoView())
        ),
        MainCategory(
            title: "网络数据",
            description: "网络请求、JSON处理、异步编程",
            icon: "network",
            color: .orange,
            destination: AnyView(NetworkDataDemoView())
        ),
        MainCategory(
            title: "系统集成",
            description: "地图、相册、分享、登录等系统功能",
            icon: "gear",
            color: .red,
            destination: AnyView(SystemIntegrationDemoView())
        ),
        MainCategory(
            title: "文档浏览",
            description: "iOS开发学习文档和指南",
            icon: "doc.text",
            color: .indigo,
            destination: AnyView(DocumentationHomeView())
        ),
        MainCategory(
            title: "其他分类",
            description: "其他功能和工具",
            icon: "ellipsis.circle",
            color: .gray,
            destination: AnyView(OtherDemoView())
        )
    ]
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List(categories) { category in
                NavigationLink(destination: category.destination) {
                    MainCategoryRow(category: category)
                }
            }
            .navigationTitle("目录")
        }
    }
}

// MARK: - Main Category Model
struct MainCategory: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let destination: AnyView
}

// MARK: - Main Category Row View
struct MainCategoryRow: View {
    let category: MainCategory
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: category.icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(category.color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.headline)
                
                Text(category.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
#Preview {
    HomeContentView()
}