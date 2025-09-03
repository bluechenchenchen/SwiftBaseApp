import SwiftUI

// MARK: - Picker Demo View
struct PickerDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = PickerViewModel()
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本选择器") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.basicSelection) {
                            ForEach(0..<viewModel.basicOptions.count, id: \.self) { index in
                                Text(viewModel.basicOptions[index])
                                    .tag(index)
                            }
                        }
                        
                        Text("当前选择: \(viewModel.basicOptions[viewModel.basicSelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "滚轮样式") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.wheelSelection) {
                            ForEach(0..<viewModel.basicOptions.count, id: \.self) { index in
                                Text(viewModel.basicOptions[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        Text("当前选择: \(viewModel.basicOptions[viewModel.wheelSelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "内联样式") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.inlineSelection) {
                            ForEach(0..<viewModel.basicOptions.count, id: \.self) { index in
                                Text(viewModel.basicOptions[index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Text("当前选择: \(viewModel.basicOptions[viewModel.inlineSelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 分段选择器
            ShowcaseSection("分段选择器") {
                ShowcaseItem(title: "基本分段") {
                    VStack(spacing: 20) {
                        Picker("视图模式", selection: $viewModel.listSegmentedSelection) {
                            Text("列表").tag(0)
                            Text("网格").tag(1)
                            Text("收藏").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Text("当前模式: \(["列表", "网格", "收藏"][viewModel.listSegmentedSelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        Picker("视图模式", selection: $viewModel.customSegmentedSelection) {
                            Label("列表", systemImage: "list.bullet").tag(0)
                            Label("网格", systemImage: "square.grid.2x2").tag(1)
                            Label("收藏", systemImage: "star").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("当前模式: \(["列表", "网格", "收藏"][viewModel.customSegmentedSelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 菜单选择器
            ShowcaseSection("菜单选择器") {
                ShowcaseItem(title: "基本菜单") {
                    VStack(spacing: 20) {
                        Picker("选择颜色", selection: $viewModel.basicMenuSelection) {
                            ForEach(0..<viewModel.colors.count, id: \.self) { index in
                                Text(viewModel.colorNames[index])
                                    .tag(viewModel.colors[index])
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Circle()
                            .fill(viewModel.basicMenuSelection)
                            .frame(width: 50, height: 50)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义菜单") {
                    VStack(spacing: 20) {
                        Picker("选择颜色", selection: $viewModel.customMenuSelection) {
                            ForEach(0..<viewModel.colors.count, id: \.self) { index in
                                Label(
                                    viewModel.colorNames[index],
                                    systemImage: "circle.fill"
                                )
                                .foregroundColor(viewModel.colors[index])
                                .tag(viewModel.colors[index])
                            }
                        }
                        .pickerStyle(.menu)
                        
                        HStack(spacing: 20) {
                            Circle()
                                .fill(viewModel.customMenuSelection)
                                .frame(width: 50, height: 50)
                            
                            Text(viewModel.colorNames[viewModel.colors.firstIndex(of: viewModel.customMenuSelection) ?? 0])
                                .foregroundStyle(viewModel.customMenuSelection)
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 自定义选择器
            ShowcaseSection("自定义选择器") {
                ShowcaseItem(title: "自定义数据类型") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.customTypeSelection) {
                            ForEach(viewModel.customOptions) { option in
                                Text(option.title)
                                    .tag(Optional(option))
                            }
                        }
                        
                        if let selection = viewModel.customTypeSelection {
                            Text("当前选择: \(selection.title) (值: \(selection.value))")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.customStyleSelection) {
                            ForEach(viewModel.customOptions) { option in
                                HStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 10, height: 10)
                                    Text(option.title)
                                    Spacer()
                                    Text("值: \(option.value)")
                                        .foregroundStyle(.secondary)
                                }
                                .tag(Optional(option))
                            }
                        }
                        .pickerStyle(.inline)
                        
                        if let selection = viewModel.customStyleSelection {
                            HStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 20, height: 20)
                                Text(selection.title)
                                    .font(.headline)
                                Text("(\(selection.value))")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 多级选择器
            ShowcaseSection("多级选择器") {
                ShowcaseItem(title: "联动选择") {
                    VStack(spacing: 20) {
                        Picker("主选项", selection: $viewModel.primarySelection) {
                            Text("类别A").tag(0)
                            Text("类别B").tag(1)
                            Text("类别C").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Picker("次选项", selection: $viewModel.secondarySelection) {
                            ForEach(0..<viewModel.secondaryOptions[viewModel.primarySelection].count, id: \.self) { index in
                                Text(viewModel.secondaryOptions[viewModel.primarySelection][index])
                                    .tag(index)
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("当前选择:")
                                .font(.headline)
                            Text("主类别: 类别\(["A", "B", "C"][viewModel.primarySelection])")
                            Text("次类别: \(viewModel.secondaryOptions[viewModel.primarySelection][viewModel.secondarySelection])")
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示更多选项", isOn: $viewModel.showAdvancedOptions.animation())
                        
                        Picker("选择选项", selection: $viewModel.lazySelection) {
                            if viewModel.showAdvancedOptions {
                                ForEach(0..<viewModel.basicOptions.count, id: \.self) { index in
                                    Text(viewModel.basicOptions[index])
                                        .tag(index)
                                }
                            } else {
                                ForEach(0..<3, id: \.self) { index in
                                    Text(viewModel.basicOptions[index])
                                        .tag(index)
                                }
                            }
                        }
                        
                        Text("当前选择: \(viewModel.basicOptions[viewModel.lazySelection])")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        Picker("选择选项", selection: $viewModel.cachedSelection) {
                            ForEach(0..<viewModel.basicOptions.count, id: \.self) { index in
                                Text(cachedTitle(for: index))
                                    .tag(index)
                            }
                        }
                        
                        Text(cachedTitle(for: viewModel.cachedSelection))
                            .foregroundStyle(.secondary)
                        
                        Button("重置所有选择") {
                            withAnimation {
                                viewModel.resetSelections()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Picker 示例")
    }
    
    // MARK: - 辅助方法
    private func cachedTitle(for index: Int) -> String {
        let cache = viewModel.selectionCache
        if let cached = cache[index] {
            return "缓存: \(cached)"
        }
        let title = viewModel.basicOptions[index]
        viewModel.selectionCache[index] = title
        return "新值: \(title)"
    }
}

// MARK: - View Model
class PickerViewModel: ObservableObject {
    // MARK: - 基础选择器
    @Published var basicSelection = 0
    @Published var wheelSelection = 0
    @Published var inlineSelection = 0
    
    // MARK: - 分段选择器
    @Published var listSegmentedSelection = 0
    @Published var customSegmentedSelection = 0
    
    // MARK: - 菜单选择器
    @Published var basicMenuSelection = Color.red
    @Published var customMenuSelection = Color.blue
    
    // MARK: - 自定义选择器
    @Published var customTypeSelection: CustomOption?
    @Published var customStyleSelection: CustomOption?
    
    // MARK: - 多级选择器
    @Published var primarySelection = 0
    @Published var secondarySelection = 0
    
    // MARK: - 性能优化
    @Published var lazySelection = 0
    @Published var cachedSelection = 0
    @Published var showAdvancedOptions = false
    
    // MARK: - 内部状态
    var selectionCache: [Int: String] = [:]
    
    // MARK: - 数据
    let basicOptions = ["选项1", "选项2", "选项3", "选项4", "选项5"]
    let colors: [Color] = [.red, .green, .blue, .yellow, .purple]
    let colorNames = ["红色", "绿色", "蓝色", "黄色", "紫色"]
    
    var customOptions: [CustomOption] {
        [
            CustomOption(title: "选项A", value: 1),
            CustomOption(title: "选项B", value: 2),
            CustomOption(title: "选项C", value: 3)
        ]
    }
    
    var secondaryOptions: [[String]] {
        [
            ["A1", "A2", "A3"],
            ["B1", "B2", "B3"],
            ["C1", "C2", "C3"]
        ]
    }
    
    // MARK: - 方法
    func resetSelections() {
        // 基础选择器
        basicSelection = 0
        wheelSelection = 0
        inlineSelection = 0
        
        // 分段选择器
        listSegmentedSelection = 0
        customSegmentedSelection = 0
        
        // 菜单选择器
        basicMenuSelection = .red
        customMenuSelection = .blue
        
        // 自定义选择器
        customTypeSelection = nil
        customStyleSelection = nil
        
        // 多级选择器
        primarySelection = 0
        secondarySelection = 0
        
        // 性能优化
        lazySelection = 0
        cachedSelection = 0
        
        // 清理缓存
        selectionCache.removeAll()
    }
    
    deinit {
        selectionCache.removeAll()
    }
}

// MARK: - Custom Option
struct CustomOption: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: Int
}

// MARK: - 预览
#Preview {
    NavigationStack {
        PickerDemoView()
    }
}
