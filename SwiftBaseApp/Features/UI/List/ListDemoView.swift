import SwiftUI

// MARK: - 数据模型
struct ListItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    
    static func == (lhs: ListItem, rhs: ListItem) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.subtitle == rhs.subtitle &&
        lhs.icon == rhs.icon
    }
}

struct ListSection: Identifiable, Equatable {
    let id = UUID()
    let title: String
    var items: [ListItem]
    
    static func == (lhs: ListSection, rhs: ListSection) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.items == rhs.items
    }
}

// MARK: - 视图模型
class ListViewModel: ObservableObject {
    @Published var sections: [ListSection] = []
    @Published var searchText = ""
    @Published var selection: Set<UUID> = []
    @Published var isEditing = false
    
    init() {
        // 初始化示例数据
        sections = [
            ListSection(title: "收藏", items: [
                ListItem(title: "Safari", subtitle: "网页浏览器", icon: "safari"),
                ListItem(title: "邮件", subtitle: "电子邮件客户端", icon: "envelope"),
                ListItem(title: "地图", subtitle: "导航应用", icon: "map")
            ]),
            ListSection(title: "工具", items: [
                ListItem(title: "设置", subtitle: "系统设置", icon: "gear"),
                ListItem(title: "时钟", subtitle: "时间管理", icon: "clock"),
                ListItem(title: "计算器", subtitle: "数字计算", icon: "number")
            ]),
            ListSection(title: "娱乐", items: [
                ListItem(title: "音乐", subtitle: "音乐播放器", icon: "music.note"),
                ListItem(title: "照片", subtitle: "图片管理", icon: "photo"),
                ListItem(title: "游戏", subtitle: "游戏中心", icon: "gamecontroller")
            ])
        ]
    }
    
    // 检查项目是否匹配搜索文本
    private func itemMatches(_ item: ListItem, searchText: String) -> Bool {
        item.title.localizedCaseInsensitiveContains(searchText) ||
        item.subtitle.localizedCaseInsensitiveContains(searchText)
    }
    
    // 过滤单个分区
    private func filterSection(_ section: ListSection) -> ListSection? {
        let filteredItems = section.items.filter { itemMatches($0, searchText: searchText) }
        return filteredItems.isEmpty ? nil : ListSection(title: section.title, items: filteredItems)
    }
    
    var filteredSections: [ListSection] {
        if searchText.isEmpty {
            return sections
        }
        return sections.compactMap { filterSection($0) }
    }
    
    func moveItem(from source: IndexSet, to destination: Int, in sectionIndex: Int) {
        sections[sectionIndex].items.move(fromOffsets: source, toOffset: destination)
    }
    
    func deleteItems(at offsets: IndexSet, in sectionIndex: Int) {
        sections[sectionIndex].items.remove(atOffsets: offsets)
    }
}

// MARK: - 列表项视图
struct ListItemRow: View {
    let item: ListItem
    
    var body: some View {
        HStack {
            Image(systemName: item.icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.body)
                Text(item.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - 样式示例视图
struct ListStyleExampleView: View {
    var body: some View {
        List {
            Section("1. 内置样式") {
                Group {
                    Text("1.1 Plain Style")
                    Text("简单的列表样式")
                }
                .listStyle(.plain)
                
                Group {
                    Text("1.2 Grouped Style")
                    Text("分组列表样式")
                }
                .listStyle(.grouped)
                
                Group {
                    Text("1.3 Inset Style")
                    Text("嵌入式列表样式")
                }
                .listStyle(.inset)
                
                Group {
                    Text("1.4 Inset Grouped Style")
                    Text("嵌入式分组列表样式")
                }
                .listStyle(.insetGrouped)
                
                Group {
                    Text("1.5 Sidebar Style")
                    Text("侧边栏列表样式")
                }
                .listStyle(.sidebar)
            }
            
            Section("2. 自定义样式") {
                Text("2.1 自定义行间距")
                    .listRowSpacing(20)
                
                Text("2.2 自定义背景色")
                    .listRowBackground(Color.blue.opacity(0.1))
                
                Text("2.3 自定义分隔线")
                    .listRowSeparatorTint(.red)
                
                Text("2.4 隐藏分隔线")
                    .listRowSeparator(.hidden)
                
                Text("2.5 自定义内边距")
                    .listRowInsets(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
            }
        }
    }
}

// MARK: - 高级功能示例视图
struct ListAdvancedExampleView: View {
    @StateObject private var viewModel = ListViewModel()
    @State private var showLoadingMore = false
    @State private var isRefreshing = false
    
    private func deleteItem(_ item: ListItem, from section: ListSection) {
        if let sectionIndex = viewModel.sections.firstIndex(where: { $0.id == section.id }),
           let itemIndex = section.items.firstIndex(where: { $0.id == item.id }) {
            viewModel.deleteItems(at: IndexSet([itemIndex]), in: sectionIndex)
        }
    }
    
    private func moveItems(from source: IndexSet, to destination: Int, in section: ListSection) {
        if let sectionIndex = viewModel.sections.firstIndex(where: { $0.id == section.id }) {
            viewModel.moveItem(from: source, to: destination, in: sectionIndex)
        }
    }
    
    var body: some View {
        List {
            Section("1. 滑动删除和拖拽排序") {
                ForEach(viewModel.sections) { section in
                    ForEach(section.items) { item in
                        ListItemRow(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteItem(item, from: section)
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                                
                                Button {
                                    // 分享操作
                                } label: {
                                    Label("分享", systemImage: "square.and.arrow.up")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    // 收藏操作
                                } label: {
                                    Label("收藏", systemImage: "star")
                                }
                                .tint(.yellow)
                            }
                    }
                    .onMove { source, destination in
                        moveItems(from: source, to: destination, in: section)
                    }
                }
            }
            
            Section("2. 下拉刷新和加载更多") {
                ForEach(viewModel.sections.flatMap(\.items)) { item in
                    ListItemRow(item: item)
                }
                
                if showLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                        Spacer()
                    }
                    .onAppear {
                        // 模拟加载更多
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showLoadingMore = false
                        }
                    }
                }
            }
            
            Section("3. 性能优化") {
                Text("3.1 ID 优化")
                    .id(UUID()) // 使用稳定的 ID
                
                Text("3.2 视图回收")
                    .id("recycled-view") // 使用固定 ID 以便视图回收
                
                Text("3.3 状态管理")
                    .onChange(of: viewModel.sections) { _ in
                        // 仅在必要时更新
                    }
            }
        }
        .refreshable {
            isRefreshing = true
            // 模拟刷新操作
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            isRefreshing = false
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - 主视图
struct ListDemoView: View {
    @StateObject private var viewModel = ListViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // 1. 基础示例
            List(selection: $viewModel.selection) {
                // 1.1 静态列表
                Section("静态列表") {
                    Text("基本文本项")
                    Label("带图标的项", systemImage: "star")
                    HStack {
                        Image(systemName: "person")
                        VStack(alignment: .leading) {
                            Text("自定义布局项")
                            Text("副标题")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // 1.2 动态列表
                Section("动态列表") {
                    ForEach(viewModel.sections) { section in
                        ForEach(section.items) { item in
                            ListItemRow(item: item)
                        }
                    }
                }
                
                // 1.3 分组列表
                Section("分组列表") {
                    ForEach(viewModel.sections) { section in
                        Section(section.title) {
                            ForEach(section.items) { item in
                                ListItemRow(item: item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("基础示例")
            .tabItem {
                Label("基础", systemImage: "1.circle")
            }
            .tag(0)
            
            // 2. 样式示例
            ListStyleExampleView()
                .navigationTitle("样式示例")
                .tabItem {
                    Label("样式", systemImage: "2.circle")
                }
                .tag(1)
            
            // 3. 高级功能
            ListAdvancedExampleView()
                .navigationTitle("高级功能")
                .tabItem {
                    Label("高级", systemImage: "3.circle")
                }
                .tag(2)
        }
        .navigationTitle("List 示例")
        .searchable(text: $viewModel.searchText, prompt: "搜索")
        .refreshable {
            // 模拟刷新操作
            try? await Task.sleep(nanoseconds: 1_000_000_000)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .environment(\.editMode, .constant(viewModel.isEditing ? .active : .inactive))
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        ListDemoView()
    }
}