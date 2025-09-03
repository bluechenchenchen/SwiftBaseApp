import SwiftUI

// MARK: - 数据模型
struct GridItemModel: Identifiable {
  let id = UUID()
  let title: String
  let color: Color
  let icon: String
}

struct GridSection: Identifiable {
  let id = UUID()
  let title: String
  var items: [GridItemModel]
}

// MARK: - 视图模型
@MainActor
class LazyGridViewModel: ObservableObject {
  @Published var items: [GridItemModel] = []
  @Published var sections: [GridSection] = []
  @Published var selectedItems: Set<UUID> = []
  @Published var isLoading = false
  
  private let icons = ["star.fill", "heart.fill", "bell.fill", "person.fill",
                       "house.fill", "gear.fill", "book.fill", "pencil",
                       "folder.fill", "doc.fill", "cloud.fill", "moon.fill"]
  
  init() {
    generateSampleData()
  }
  
  private func generateSampleData() {
    // 生成示例数据
    items = (0..<50).map { index in
      GridItemModel(
        title: "Item \(index + 1)",
        color: Color(
          hue: Double.random(in: 0...1),
          saturation: 0.7,
          brightness: 0.9
        ),
        icon: icons[index % icons.count]
      )
    }
    
    // 生成分组数据
    sections = (0..<5).map { sectionIndex in
      GridSection(
        title: "Section \(sectionIndex + 1)",
        items: (0..<8).map { itemIndex in
          GridItemModel(
            title: "Item \(itemIndex + 1)",
            color: Color(
              hue: Double.random(in: 0...1),
              saturation: 0.7,
              brightness: 0.9
            ),
            icon: icons[(sectionIndex * 8 + itemIndex) % icons.count]
          )
        }
      )
    }
  }
  
  func refreshData() {
    isLoading = true
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

// MARK: - 辅助视图
struct GridItemView: View {
  let item: GridItemModel
  let size: CGFloat
  
  var body: some View {
    VStack {
      Image(systemName: item.icon)
        .font(.system(size: size))
        .foregroundColor(item.color)
      Text(item.title)
        .font(.caption)
    }
  }
}

struct SelectableGridItemView: View {
  let item: GridItemModel
  let isSelected: Bool
  let onTap: () -> Void
  
  var body: some View {
    VStack {
      Image(systemName: item.icon)
        .font(.system(size: 24))
        .foregroundColor(isSelected ? .white : item.color)
      Text(item.title)
        .font(.caption)
        .foregroundColor(isSelected ? .white : .primary)
    }
    .frame(height: 80)
    .frame(maxWidth: .infinity)
    .background(isSelected ? item.color : item.color.opacity(0.1))
    .cornerRadius(8)
    .onTapGesture {
      withAnimation(.spring()) {
        onTap()
      }
    }
  }
}

// MARK: - 主视图
struct LazyGridDemoView: View {
  @StateObject private var viewModel = LazyGridViewModel()
  @State private var columnCount = 3
  @State private var showDetails = false
  
  var gridItems: [GridItem] {
    Array(repeating: .init(.flexible()), count: columnCount)
  }
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础布局
      ShowcaseSection("基础布局") {
        // 1. 基本网格
        ShowcaseItem(title: "基本网格") {
          VStack {
            Stepper("列数: \(columnCount)", value: $columnCount, in: 1...5)
            
            LazyVGrid(columns: gridItems, spacing: 16) {
              ForEach(viewModel.items.prefix(12)) { item in
                GridItemView(item: item, size: 30)
                  .frame(height: 80)
                  .frame(maxWidth: .infinity)
                  .background(item.color.opacity(0.1))
                  .cornerRadius(8)
              }
            }
          }
        }
        
        // 2. 水平网格
        ShowcaseItem(title: "水平网格") {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [
              GridItem(.fixed(80)),
              GridItem(.fixed(80))
            ], spacing: 16) {
              ForEach(viewModel.items.prefix(8)) { item in
                GridItemView(item: item, size: 24)
                  .frame(width: 80)
                  .frame(maxHeight: .infinity)
                  .background(item.color.opacity(0.1))
                  .cornerRadius(8)
              }
            }
          }
        }
        
        // 3. 自适应网格
        ShowcaseItem(title: "自适应网格") {
          LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 100, maximum: 200))
          ], spacing: 16) {
            ForEach(viewModel.items.prefix(6)) { item in
              GridItemView(item: item, size: 30)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .background(item.color.opacity(0.1))
                .cornerRadius(8)
            }
          }
        }
      }
      
      // MARK: - 高级布局
      ShowcaseSection("高级布局") {
        // 1. 分组网格
        ShowcaseItem(title: "分组网格") {
          VStack(alignment: .leading, spacing: 16) {
            ForEach(viewModel.sections.prefix(2)) { section in
              VStack(alignment: .leading) {
                Text(section.title)
                  .font(.subheadline)
                  .foregroundColor(.secondary)
                
                LazyVGrid(columns: [
                  GridItem(.adaptive(minimum: 80))
                ], spacing: 12) {
                  ForEach(section.items) { item in
                    GridItemView(item: item, size: 24)
                      .frame(height: 80)
                      .frame(maxWidth: .infinity)
                      .background(item.color.opacity(0.1))
                      .cornerRadius(8)
                  }
                }
              }
            }
          }
        }
        
        // 2. 动画网格
        ShowcaseItem(title: "动画网格") {
          VStack {
            Button("显示/隐藏详情") {
              withAnimation(.spring()) {
                showDetails.toggle()
              }
            }
            
            if showDetails {
              LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
              ], spacing: 16) {
                ForEach(viewModel.items.prefix(4)) { item in
                  GridItemView(item: item, size: 30)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(item.color.opacity(0.1))
                    .cornerRadius(8)
                    .transition(.scale.combined(with: .opacity))
                }
              }
            }
          }.frame(height: 220)
        }
      }
      
      // MARK: - 交互示例
      ShowcaseSection("交互示例") {
        // 1. 选择网格
        ShowcaseItem(title: "选择网格") {
          LazyVGrid(columns: [
            GridItem(.adaptive(minimum: 80))
          ], spacing: 12) {
            ForEach(viewModel.items.prefix(12)) { item in
              SelectableGridItemView(
                item: item,
                isSelected: viewModel.selectedItems.contains(item.id),
                onTap: { viewModel.toggleSelection(for: item.id) }
              )
            }
          }
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        // 1. 延迟加载
        ShowcaseItem(title: "延迟加载") {
          LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
          ], spacing: 16) {
            ForEach(viewModel.items) { item in
              GridItemView(item: item, size: 24)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(item.color.opacity(0.1))
                .cornerRadius(8)
            }
          }
        }
      }
    }
    .navigationTitle("网格布局示例")
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
    LazyGridDemoView()
  }
}
