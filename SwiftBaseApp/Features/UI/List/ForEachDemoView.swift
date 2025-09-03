import SwiftUI

// MARK: - 数据模型
struct DemoItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let color: Color
}

struct DemoSection: Identifiable {
    let id = UUID()
    let title: String
    var items: [DemoItem]
}

// MARK: - 视图模型
@MainActor
class ForEachDemoViewModel: ObservableObject {
    @Published var items: [DemoItem] = []
    @Published var sections: [DemoSection] = []
    @Published var selectedItems: Set<UUID> = []
    @Published var isLoading = false
    
    init() {
        generateSampleData()
    }
    
    private func generateSampleData() {
        // 生成示例数据
        items = (0..<20).map { index in
            DemoItem(
                title: "Item \(index + 1)",
                subtitle: "Description for item \(index + 1)",
                color: Color(
                    hue: Double.random(in: 0...1),
                    saturation: 0.5,
                    brightness: 0.8
                )
            )
        }
        
        // 生成分组数据
        sections = (0..<5).map { sectionIndex in
            DemoSection(
                title: "Section \(sectionIndex + 1)",
                items: (0..<4).map { itemIndex in
                    DemoItem(
                        title: "Item \(itemIndex + 1)",
                        subtitle: "Section \(sectionIndex + 1), Item \(itemIndex + 1)",
                        color: Color(
                            hue: Double.random(in: 0...1),
                            saturation: 0.5,
                            brightness: 0.8
                        )
                    )
                }
            )
        }
    }
    
    @MainActor
    func refreshData() {
        isLoading = true
        // 模拟网络请求延迟
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1秒
            generateSampleData()
            isLoading = false
        }
    }
    
    func toggleSelection(for id: UUID) {
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
}

// MARK: - 基础示例视图
struct BasicExamplesView: View {
    @ObservedObject var viewModel: ForEachDemoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 1. 基于范围的遍历
            Group {
                Text("1.1 基于范围的遍历")
                    .font(.headline)
                
                HStack {
                    ForEach(0..<5) { index in
                        Text("\(index)")
                            .padding(8)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
            
            // 2. 遍历数组
            Group {
                Text("1.2 遍历数组")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.items) { item in
                            VStack {
                                Text(item.title)
                                    .font(.caption)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(item.color)
                                    .frame(width: 60, height: 60)
                            }
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }
            }
            
            // 3. 带选择功能的遍历
            Group {
                Text("1.3 带选择功能的遍历")
                    .font(.headline)
                
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 80))
                ]) {
                    ForEach(viewModel.items.prefix(8)) { item in
                        VStack {
                            Circle()
                                .fill(item.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    viewModel.selectedItems.contains(item.id) ?
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.white) : nil
                                )
                            Text(item.title)
                                .font(.caption)
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.selectedItems.contains(item.id) ?
                                      Color.blue.opacity(0.2) : Color.clear)
                        )
                        .onTapGesture {
                            withAnimation {
                                viewModel.toggleSelection(for: item.id)
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - 高级示例视图
struct AdvancedExamplesView: View {
    @ObservedObject var viewModel: ForEachDemoViewModel
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 1. 嵌套 ForEach
            Group {
                Text("2.1 嵌套 ForEach")
                    .font(.headline)
                
                List {
                    ForEach(viewModel.sections) { section in
                        Section(header: Text(section.title)) {
                            ForEach(section.items) { item in
                                HStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 20, height: 20)
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .font(.subheadline)
                                        Text(item.subtitle)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            
            // 2. 动画效果
            Group {
                Text("2.2 动画效果")
                    .font(.headline)
                
                VStack {
                    Button("显示/隐藏详情") {
                        withAnimation(.spring()) {
                            showDetails.toggle()
                        }
                    }
                    
                    if showDetails {
                        ForEach(viewModel.items.prefix(5)) { item in
                            HStack {
                                Circle()
                                    .fill(item.color)
                                    .frame(width: 30, height: 30)
                                Text(item.title)
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.slide)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - 性能优化示例视图
struct PerformanceExamplesView: View {
    @ObservedObject var viewModel: ForEachDemoViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 1. LazyVStack 优化
            Group {
                Text("3.1 LazyVStack 优化")
                    .font(.headline)
                
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.items) { item in
                            HStack {
                                Circle()
                                    .fill(item.color)
                                    .frame(width: 40, height: 40)
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            
            // 2. ID 优化
            Group {
                Text("3.2 ID 优化")
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(viewModel.items) { item in
                            VStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(item.color)
                                    .frame(width: 80, height: 80)
                                Text(item.title)
                                    .font(.caption)
                            }
                            .padding(8)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

// MARK: - 主视图
struct ForEachDemoView: View {
    @StateObject private var viewModel = ForEachDemoViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 1. 基础示例
            BasicExamplesView(viewModel: viewModel)
                .navigationTitle("基础示例")
                .tabItem {
                    Label("基础", systemImage: "1.circle")
                }
                .tag(0)
            
            // 2. 高级示例
            AdvancedExamplesView(viewModel: viewModel)
                .navigationTitle("高级示例")
                .tabItem {
                    Label("高级", systemImage: "2.circle")
                }
                .tag(1)
            
            // 3. 性能优化
            PerformanceExamplesView(viewModel: viewModel)
                .navigationTitle("性能优化")
                .tabItem {
                    Label("性能", systemImage: "3.circle")
                }
                .tag(2)
        }
        .navigationTitle("ForEach 示例")
        .refreshable {
            await withCheckedContinuation { continuation in
                viewModel.refreshData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    continuation.resume()
                }
            }
        }
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        ForEachDemoView()
    }
}
