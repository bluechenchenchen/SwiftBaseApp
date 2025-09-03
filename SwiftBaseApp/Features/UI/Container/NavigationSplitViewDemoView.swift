import SwiftUI

// MARK: - 数据模型
struct NavCategory: Identifiable, Hashable {
  let id = UUID()
  let name: String
  let icon: String
  let color: Color
}

struct NavItem: Identifiable, Hashable {
  let id = UUID()
  let title: String
  let description: String
  let category: NavCategory
}

// MARK: - 视图模型
class SplitViewNavigationManager: ObservableObject {
  @Published var selectedCategory: NavCategory?
  @Published var selectedItem: NavItem?
  
  // 示例数据
  let categories = [
    NavCategory(name: "收件箱", icon: "tray", color: .blue),
    NavCategory(name: "已发送", icon: "paperplane", color: .green),
    NavCategory(name: "草稿", icon: "doc", color: .orange),
    NavCategory(name: "已删除", icon: "trash", color: .red)
  ]
  
  var items: [NavItem] {
    guard let category = selectedCategory else { return [] }
    return (0...5).map { index in
      NavItem(
        title: "\(category.name)项目\(index + 1)",
        description: "这是\(category.name)中的第\(index + 1)个项目的详细描述",
        category: category
      )
    }
  }
}

// MARK: - 基础两栏布局示例
struct TwoColumnExample: View {
  @StateObject private var navigator = SplitViewNavigationManager()
  
  var body: some View {
    NavigationSplitView {
      // 侧边栏
      List(navigator.categories, selection: $navigator.selectedCategory) { category in
        Label {
          Text(category.name)
            .font(.body)
        } icon: {
          Image(systemName: category.icon)
            .foregroundStyle(category.color)
            .font(.title3)
        }
        .padding(.vertical, 4)
      }
      .navigationTitle("分类")
      .listStyle(.sidebar)
    } detail: {
      if let category = navigator.selectedCategory {
        List(navigator.items) { item in
          VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
              .font(.headline)
            Text(item.description)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.vertical, 4)
        }
        .navigationTitle(category.name)
        .listStyle(.plain)
      } else {
        ContentUnavailableView(
          "请选择一个分类",
          systemImage: "sidebar.left",
          description: Text("从左侧边栏选择一个分类来查看其内容")
        )
      }
    }
    .navigationSplitViewStyle(.balanced)
  }
}

// MARK: - 三栏布局示例
struct ThreeColumnExample: View {
  @StateObject private var navigator = SplitViewNavigationManager()
  @State private var columnVisibility = NavigationSplitViewVisibility.all
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      // 侧边栏
      List(navigator.categories, selection: $navigator.selectedCategory) { category in
        Label {
          Text(category.name)
            .font(.body)
        } icon: {
          Image(systemName: category.icon)
            .foregroundStyle(category.color)
            .font(.title3)
        }
        .padding(.vertical, 4)
      }
      .navigationTitle("分类")
      .listStyle(.sidebar)
    } content: {
      // 内容列表
      if let category = navigator.selectedCategory {
        List(navigator.items, selection: $navigator.selectedItem) { item in
          VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
              .font(.headline)
            Text(item.description)
              .lineLimit(2)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.vertical, 4)
        }
        .navigationTitle(category.name)
        .listStyle(.plain)
      } else {
        ContentUnavailableView(
          "请选择一个分类",
          systemImage: "sidebar.left",
          description: Text("从左侧边栏选择一个分类来查看其内容")
        )
      }
    } detail: {
      // 详情视图
      if let item = navigator.selectedItem {
        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            HStack {
              Image(systemName: item.category.icon)
                .foregroundStyle(item.category.color)
                .font(.title)
              Text(item.title)
                .font(.title)
                .fontWeight(.bold)
            }
            
            Divider()
            
            Text(item.description)
              .font(.body)
            
            // 模拟的详细内容
            VStack(alignment: .leading, spacing: 16) {
              ForEach(1...3, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                  Text("详细信息 \(index)")
                    .font(.headline)
                  Text("这是关于\(item.title)的详细信息\(index)，包含了更多的描述性内容。")
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
              }
            }
            .padding(.top)
          }
          .padding()
        }
        .navigationTitle("详情")
        .background(Color(.systemGroupedBackground))
      } else {
        ContentUnavailableView(
          "请选择一个项目",
          systemImage: "doc.text",
          description: Text("从中间列表选择一个项目来查看其详细信息")
        )
      }
    }
    .navigationSplitViewStyle(.balanced)
  }
}

// MARK: - 列可见性控制示例
struct ColumnVisibilityExample: View {
  @StateObject private var navigator = SplitViewNavigationManager()
  @State private var columnVisibility = NavigationSplitViewVisibility.all
  @State private var preferredColumn = NavigationSplitViewColumn.sidebar
  
  var body: some View {
    NavigationSplitView(
      columnVisibility: $columnVisibility,
      preferredCompactColumn: $preferredColumn
    ) {
      // 侧边栏
      List(navigator.categories, selection: $navigator.selectedCategory) { category in
        Label {
          Text(category.name)
            .font(.body)
        } icon: {
          Image(systemName: category.icon)
            .foregroundStyle(category.color)
            .font(.title3)
        }
        .padding(.vertical, 4)
      }
      .navigationTitle("分类")
      .listStyle(.sidebar)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Menu {
            Button {
              withAnimation {
                columnVisibility = .all
              }
            } label: {
              Label("显示所有列", systemImage: "rectangle.split.3x1")
            }
            
            Button {
              withAnimation {
                columnVisibility = .detailOnly
              }
            } label: {
              Label("仅显示详情", systemImage: "rectangle.righthalf.inset.filled")
            }
            
            Divider()
            
            Picker("优先显示", selection: $preferredColumn) {
              Label("侧边栏", systemImage: "sidebar.left")
                .tag(NavigationSplitViewColumn.sidebar)
              Label("内容", systemImage: "doc.text")
                .tag(NavigationSplitViewColumn.content)
              Label("详情", systemImage: "doc.text.fill")
                .tag(NavigationSplitViewColumn.detail)
            }
          } label: {
            Image(systemName: "sidebar.left")
              .symbolVariant(columnVisibility == .all ? .fill : .none)
          }
        }
      }
    } content: {
      // 内容列表
      if let category = navigator.selectedCategory {
        List(navigator.items, selection: $navigator.selectedItem) { item in
          VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
              .font(.headline)
            Text(item.description)
              .lineLimit(2)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.vertical, 4)
        }
        .navigationTitle(category.name)
        .listStyle(.plain)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              withAnimation {
                columnVisibility = columnVisibility == .all ? .detailOnly : .all
              }
            } label: {
              Image(systemName: "sidebar.trailing")
                .symbolVariant(columnVisibility == .all ? .fill : .none)
            }
          }
        }
      } else {
        ContentUnavailableView(
          "请选择一个分类",
          systemImage: "sidebar.left",
          description: Text("从左侧边栏选择一个分类来查看其内容")
        )
      }
    } detail: {
      // 详情视图
      if let item = navigator.selectedItem {
        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            HStack {
              Image(systemName: item.category.icon)
                .foregroundStyle(item.category.color)
                .font(.title)
              Text(item.title)
                .font(.title)
                .fontWeight(.bold)
            }
            
            Divider()
            
            Text(item.description)
              .font(.body)
            
            // 模拟的详细内容
            VStack(alignment: .leading, spacing: 16) {
              ForEach(1...3, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                  Text("详细信息 \(index)")
                    .font(.headline)
                  Text("这是关于\(item.title)的详细信息\(index)，包含了更多的描述性内容。")
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
              }
            }
            .padding(.top)
          }
          .padding()
        }
        .navigationTitle("详情")
        .background(Color(.systemGroupedBackground))
      } else {
        ContentUnavailableView(
          "请选择一个项目",
          systemImage: "doc.text",
          description: Text("从中间列表选择一个项目来查看其详细信息")
        )
      }
    }
  }
}

// MARK: - 列宽控制示例
struct ColumnWidthExample: View {
  @StateObject private var navigator = SplitViewNavigationManager()
  @State private var columnVisibility = NavigationSplitViewVisibility.all
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      // 侧边栏 - 较窄
      List(navigator.categories, selection: $navigator.selectedCategory) { category in
        Label {
          Text(category.name)
            .font(.body)
        } icon: {
          Image(systemName: category.icon)
            .foregroundStyle(category.color)
            .font(.title3)
        }
        .padding(.vertical, 4)
      }
      .navigationTitle("分类")
      .listStyle(.sidebar)
      .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
    } content: {
      // 内容列表 - 中等宽度
      if let category = navigator.selectedCategory {
        List(navigator.items, selection: $navigator.selectedItem) { item in
          VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
              .font(.headline)
            Text(item.description)
              .lineLimit(2)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
          .padding(.vertical, 4)
        }
        .navigationTitle(category.name)
        .listStyle(.plain)
        .navigationSplitViewColumnWidth(min: 250, ideal: 300, max: 400)
      } else {
        ContentUnavailableView(
          "请选择一个分类",
          systemImage: "sidebar.left",
          description: Text("从左侧边栏选择一个分类来查看其内容")
        )
      }
    } detail: {
      // 详情视图 - 较宽
      if let item = navigator.selectedItem {
        ScrollView {
          VStack(alignment: .leading, spacing: 20) {
            HStack {
              Image(systemName: item.category.icon)
                .foregroundStyle(item.category.color)
                .font(.title)
              Text(item.title)
                .font(.title)
                .fontWeight(.bold)
            }
            
            Divider()
            
            Text(item.description)
              .font(.body)
            
            // 模拟的详细内容
            VStack(alignment: .leading, spacing: 16) {
              ForEach(1...3, id: \.self) { index in
                VStack(alignment: .leading, spacing: 8) {
                  Text("详细信息 \(index)")
                    .font(.headline)
                  Text("这是关于\(item.title)的详细信息\(index)，包含了更多的描述性内容。这里添加了更多的文本内容来演示较宽列的效果。")
                    .font(.body)
                    .foregroundStyle(.secondary)
                }
              }
            }
            .padding(.top)
            
            // 额外的内容区域
            Group {
              Divider()
                .padding(.vertical)
              
              Text("宽列布局示例")
                .font(.title2)
                .padding(.bottom, 8)
              
              HStack(spacing: 20) {
                ForEach(1...2, id: \.self) { _ in
                  VStack(alignment: .leading, spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                      .fill(Color.gray.opacity(0.2))
                      .frame(height: 120)
                    
                    Text("示例内容区域")
                      .font(.headline)
                    Text("这个区域展示了较宽列布局的优势，可以容纳更多的并排内容。")
                      .font(.subheadline)
                      .foregroundStyle(.secondary)
                  }
                }
              }
            }
          }
          .padding()
        }
        .navigationTitle("详情")
        .background(Color(.systemGroupedBackground))
      } else {
        ContentUnavailableView(
          "请选择一个项目",
          systemImage: "doc.text",
          description: Text("从中间列表选择一个项目来查看其详细信息")
        )
      }
    }
    .navigationSplitViewStyle(.balanced)
  }
}

// MARK: - 设备适配示例
struct AdaptiveNavigationExample: View {
  @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  @StateObject private var navigator = SplitViewNavigationManager()
  
  var body: some View {
    Group {
      if horizontalSizeClass == .compact {
        // iPhone 上使用标准导航
        NavigationStack {
          List(navigator.categories) { category in
            NavigationLink(value: category) {
              Label {
                Text(category.name)
                  .font(.body)
              } icon: {
                Image(systemName: category.icon)
                  .foregroundStyle(category.color)
                  .font(.title3)
              }
              .padding(.vertical, 4)
            }
          }
          .navigationTitle("分类")
          .listStyle(.insetGrouped)
          .navigationDestination(for: NavCategory.self) { category in
            List(navigator.items) { item in
              NavigationLink(value: item) {
                VStack(alignment: .leading, spacing: 8) {
                  Text(item.title)
                    .font(.headline)
                  Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                }
                .padding(.vertical, 4)
              }
            }
            .navigationTitle(category.name)
            .listStyle(.plain)
            .navigationDestination(for: NavItem.self) { item in
              ItemDetailView(item: item)
                .navigationBarTitleDisplayMode(.inline)
            }
          }
        }
      } else {
        // iPad/Mac 上使用分栏导航
        NavigationSplitView {
          List(navigator.categories, selection: $navigator.selectedCategory) { category in
            Label {
              Text(category.name)
                .font(.body)
            } icon: {
              Image(systemName: category.icon)
                .foregroundStyle(category.color)
                .font(.title3)
            }
            .padding(.vertical, 4)
          }
          .navigationTitle("分类")
          .listStyle(.sidebar)
        } content: {
          if let category = navigator.selectedCategory {
            List(navigator.items, selection: $navigator.selectedItem) { item in
              VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                  .font(.headline)
                Text(item.description)
                  .font(.subheadline)
                  .foregroundStyle(.secondary)
                  .lineLimit(2)
              }
              .padding(.vertical, 4)
            }
            .navigationTitle(category.name)
            .listStyle(.plain)
          } else {
            ContentUnavailableView(
              "请选择一个分类",
              systemImage: "sidebar.left",
              description: Text("从左侧边栏选择一个分类来查看其内容")
            )
          }
        } detail: {
          if let item = navigator.selectedItem {
            ItemDetailView(item: item)
          } else {
            ContentUnavailableView(
              "请选择一个项目",
              systemImage: "doc.text",
              description: Text("从中间列表选择一个项目来查看其详细信息")
            )
          }
        }
        .navigationSplitViewStyle(.balanced)
      }
    }
  }
}

// MARK: - 辅助视图
struct ItemDetailView: View {
  let item: NavItem
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        // 标题区域
        HStack {
          Image(systemName: item.category.icon)
            .foregroundStyle(item.category.color)
            .font(.title)
          Text(item.title)
            .font(.title)
            .fontWeight(.bold)
        }
        
        Divider()
        
        // 描述区域
        VStack(alignment: .leading, spacing: 16) {
          Text("基本信息")
            .font(.headline)
          Text(item.description)
            .font(.body)
            .foregroundStyle(.secondary)
        }
        
        // 详细信息区域
        VStack(alignment: .leading, spacing: 16) {
          Text("详细信息")
            .font(.headline)
            .padding(.top)
          
          ForEach(1...3, id: \.self) { index in
            VStack(alignment: .leading, spacing: 8) {
              Text("信息项 \(index)")
                .font(.subheadline)
                .fontWeight(.medium)
              Text("这是关于\(item.title)的详细信息\(index)，包含了更多的描述性内容。")
                .font(.body)
                .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
          }
        }
        
        // 相关内容区域
        VStack(alignment: .leading, spacing: 16) {
          Text("相关内容")
            .font(.headline)
            .padding(.top)
          
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
              ForEach(1...3, id: \.self) { index in
                VStack(alignment: .leading, spacing: 12) {
                  RoundedRectangle(cornerRadius: 8)
                    .fill(item.category.color.opacity(0.2))
                    .frame(width: 200, height: 120)
                    .overlay(
                      Image(systemName: item.category.icon)
                        .font(.largeTitle)
                        .foregroundStyle(item.category.color)
                    )
                  
                  Text("相关项目 \(index)")
                    .font(.headline)
                  Text("这是一个与\(item.title)相关的内容项目。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                }
                .frame(width: 200)
              }
            }
            .padding(.horizontal, 1)
          }
        }
      }
      .padding()
    }
    .navigationTitle("详情")
    .background(Color(.systemGroupedBackground))
  }
}

// MARK: - 主视图
struct NavigationSplitViewDemoView: View {
  var body: some View {
    ShowcaseList {
      // MARK: - 基础布局
      ShowcaseSection("基础布局") {
        ShowcaseItem(title: "两栏布局") {
          Text("使用 NavigationSplitView 创建基础的两栏布局")
          TwoColumnExample()
        }
        
        ShowcaseItem(title: "三栏布局") {
          Text("展示包含侧边栏、内容列表和详情的三栏布局")
          ThreeColumnExample()
        }
      }
      
      // MARK: - 高级特性
      ShowcaseSection("高级特性") {
        ShowcaseItem(title: "列可见性控制") {
          Text("动态控制列的显示和隐藏")
          ColumnVisibilityExample()
        }
        
        ShowcaseItem(title: "列宽控制") {
          Text("自定义每列的最小、理想和最大宽度")
          ColumnWidthExample()
        }
      }
      
      // MARK: - 响应式设计
      ShowcaseSection("响应式设计") {
        ShowcaseItem(title: "设备适配") {
          Text("根据设备类型和屏幕尺寸自动调整导航样式")
          AdaptiveNavigationExample()
        }
      }
    }
    .navigationTitle("NavigationSplitView 示例")
  }
}

// MARK: - 预览
#Preview {
  NavigationSplitViewDemoView()
}
