import SwiftUI

// MARK: - Toggle Demo View
struct ToggleDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = ToggleViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本开关") {
                    VStack(spacing: 20) {
                        Toggle("开关", isOn: $viewModel.basicToggle)
                        
                        Toggle(isOn: $viewModel.basicToggle) {
                            Text(viewModel.basicToggle ? "开启" : "关闭")
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带图标") {
                    VStack(spacing: 20) {
                        Toggle(isOn: binding(for: "bluetooth")) {
                            Label("蓝牙", systemImage: "bluetooth")
                        }
                        
                        Toggle(isOn: binding(for: "location")) {
                            Label("定位", systemImage: "location")
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "带描述") {
                    VStack(spacing: 20) {
                        VStack(alignment: .leading) {
                            Toggle("通知", isOn: binding(for: "notifications"))
                            Text("接收应用推送通知")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            Toggle("自动锁定", isOn: binding(for: "autoLock"))
                            Text("在无操作时自动锁定应用")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 自定义样式
            ShowcaseSection("自定义样式") {
                ShowcaseItem(title: "自定义颜色") {
                    VStack(spacing: 20) {
                        Toggle("深色模式", isOn: binding(for: "darkMode"))
                            .tint(.blue)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        Toggle(isOn: binding(for: "darkMode")) {
                            HStack {
                                Image(systemName: viewModel.settings["darkMode"] == true ? "moon.fill" : "sun.max.fill")
                                Text("深色模式")
                            }
                        }
                        .toggleStyle(.button)
                        .tint(.blue)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义开关") {
                    VStack(spacing: 20) {
                        Toggle("自定义开关", isOn: $viewModel.customStyleToggle)
                            .toggleStyle(.custom)
                        
                        Toggle("开关选项", isOn: $viewModel.customStyleToggle)
                            .toggleStyle(.switch)
                            .tint(viewModel.customStyleToggle ? .green : .gray)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "预览效果") {
                    VStack(spacing: 20) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.settings["darkMode"] == true ? Color.black : Color.white)
                            .frame(height: 100)
                            .overlay {
                                Text("预览内容")
                                    .foregroundStyle(viewModel.settings["darkMode"] == true ? .white : .black)
                            }
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
            
            // MARK: - 状态管理
            ShowcaseSection("状态管理") {
                ShowcaseItem(title: "基本状态") {
                    VStack(spacing: 20) {
                        ForEach(["notifications", "darkMode", "autoLock", "location", "bluetooth"], id: \.self) { key in
                            Toggle(key.capitalized, isOn: binding(for: key))
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "持久化状态") {
                    VStack(spacing: 20) {
                        Toggle("深色模式", isOn: $isDarkMode)
                            .onChange(of: isDarkMode) { newValue in
                                viewModel.settings["darkMode"] = newValue
                            }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "状态依赖") {
                    VStack(spacing: 20) {
                        Toggle("通知", isOn: binding(for: "notifications"))
                        
                        if viewModel.settings["notifications"] == true {
                            VStack(spacing: 12) {
                                Toggle("电子邮件", isOn: binding(for: "email"))
                                Toggle("短信", isOn: binding(for: "sms"))
                            }
                            .padding(.leading)
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 动画效果
            ShowcaseSection("动画效果") {
                ShowcaseItem(title: "基本动画") {
                    VStack(spacing: 20) {
                        Toggle("动画开关", isOn: $viewModel.springToggle)
                            .animation(.spring(), value: viewModel.springToggle)
                        
                        if viewModel.springToggle {
                            Text("动画内容")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义动画") {
                    VStack(spacing: 20) {
                        Toggle("缩放效果", isOn: $viewModel.scaleToggle)
                            .scaleEffect(viewModel.scaleToggle ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.scaleToggle)
                        
                        Toggle("旋转效果", isOn: binding(for: "rotation"))
                            .rotationEffect(viewModel.settings["rotation"] == true ? .degrees(180) : .degrees(0))
                            .animation(.spring(), value: viewModel.settings["rotation"])
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "组合动画") {
                    VStack(spacing: 20) {
                        Toggle("组合效果", isOn: binding(for: "combined"))
                        
                        if viewModel.settings["combined"] == true {
                            HStack {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 20, height: 20)
                                        .scaleEffect(viewModel.settings["combined"] == true ? 1.0 : 0.5)
                                        .opacity(viewModel.settings["combined"] == true ? 1.0 : 0.3)
                                        .animation(
                                            .spring().delay(Double(index) * 0.1),
                                            value: viewModel.settings["combined"]
                                        )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            
            // MARK: - 组合控件
            ShowcaseSection("组合控件") {
                ShowcaseItem(title: "功能组合") {
                    VStack(spacing: 20) {
                        Toggle("启用功能", isOn: binding(for: "feature"))
                        
                        if viewModel.settings["feature"] == true {
                            Toggle("高级选项", isOn: $viewModel.showAdvancedSettings)
                                .animation(.spring(), value: viewModel.showAdvancedSettings)
                            
                            if viewModel.showAdvancedSettings {
                                VStack(spacing: 12) {
                                    Toggle("选项 A", isOn: binding(for: "optionA"))
                                    Toggle("选项 B", isOn: binding(for: "optionB"))
                                    Toggle("选项 C", isOn: binding(for: "optionC"))
                                }
                                .padding(.leading)
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "交互组合") {
                    VStack(spacing: 20) {
                        Toggle("重要功能", isOn: binding(for: "important"))
                            .onChange(of: viewModel.settings["important"]) { newValue in
                                if newValue == true {
                                    viewModel.showAlert = true
                                }
                            }
                        
                        if viewModel.settings["important"] == true {
                            VStack(spacing: 12) {
                                Toggle("子功能 1", isOn: binding(for: "sub1"))
                                Toggle("子功能 2", isOn: binding(for: "sub2"))
                                Toggle("子功能 3", isOn: binding(for: "sub3"))
                            }
                            .padding(.leading)
                        }
                    }
                    .padding()
                }
                .alert("确认", isPresented: $viewModel.showAlert) {
                    Button("确定") { }
                    Button("取消") {
                        viewModel.settings["important"] = false
                    }
                } message: {
                    Text("是否确定启用此功能？")
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示高级选项", isOn: $viewModel.showAdvancedSettings.animation())
                        
                        Toggle("基本选项", isOn: $viewModel.lazyToggle)
                        
                        if viewModel.showAdvancedSettings {
                            LazyVStack {
                                ForEach(0..<5) { index in
                                    Toggle("高级选项 \(index + 1)", isOn: binding(for: "advanced\(index)"))
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        ForEach(viewModel.settings.keys.sorted(), id: \.self) { key in
                            Toggle(key.capitalized, isOn: binding(for: key))
                                .onChange(of: viewModel.settings[key]) { newValue in
                                    if let newValue = newValue {
                                        viewModel.valueCache[key] = newValue
                                    }
                                }
                        }
                        
                        Button("重置所有设置") {
                            withAnimation {
                                viewModel.resetSettings()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Toggle 示例")
    }
    
    // MARK: - 辅助方法
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
}

// MARK: - View Model
class ToggleViewModel: ObservableObject {
    // MARK: - 基础开关
    @Published var basicToggle = false
    @Published var labeledToggle = false
    @Published var iconToggle = false
    
    // MARK: - 自定义样式
    @Published var coloredToggle = false
    @Published var buttonToggle = false
    @Published var customStyleToggle = false
    
    // MARK: - 状态管理
    @Published var settings: [String: Bool] = [
        "notifications": false,
        "darkMode": false,
        "autoLock": false,
        "location": false,
        "bluetooth": false,
        "email": false,
        "sms": false,
        "feature": false,
        "optionA": false,
        "optionB": false,
        "optionC": false,
        "important": false,
        "sub1": false,
        "sub2": false,
        "sub3": false,
        "rotation": false,
        "combined": false
    ]
    
    // MARK: - 动画效果
    @Published var springToggle = false
    @Published var scaleToggle = false
    @Published var rotateToggle = false
    
    // MARK: - 组合控件
    @Published var showAdvancedSettings = false
    @Published var showAlert = false
    
    // MARK: - 性能优化
    @Published var lazyToggle = false
    @Published var cachedToggle = false
    
    // MARK: - 内部状态
    var valueCache: [String: Bool] = [:]
    
    // MARK: - 方法
    func updateSetting(_ value: Bool, for key: String) {
        settings[key] = value
    }
    
    func resetSettings() {
        // 基础开关
        basicToggle = false
        labeledToggle = false
        iconToggle = false
        
        // 自定义样式
        coloredToggle = false
        buttonToggle = false
        customStyleToggle = false
        
        // 状态管理
        for key in settings.keys {
            settings[key] = false
        }
        
        // 动画效果
        springToggle = false
        scaleToggle = false
        rotateToggle = false
        
        // 组合控件
        showAdvancedSettings = false
        showAlert = false
        
        // 性能优化
        lazyToggle = false
        cachedToggle = false
        
        // 清理缓存
        valueCache.removeAll()
    }
}

// MARK: - Basic Toggle Example
struct BasicToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
    
    var body: some View {
        Form {
            Section("基本开关") {
                Toggle("开关", isOn: $viewModel.basicToggle)
                
                Toggle(isOn: $viewModel.basicToggle) {
                    Text(viewModel.basicToggle ? "开启" : "关闭")
                }
            }
            
            Section("带图标") {
                Toggle(isOn: binding(for: "bluetooth")) {
                    Label("蓝牙", systemImage: "bluetooth")
                }
                
                Toggle(isOn: binding(for: "location")) {
                    Label("定位", systemImage: "location")
                }
            }
            
            Section("带描述") {
                VStack(alignment: .leading) {
                    Toggle("通知", isOn: binding(for: "notifications"))
                    Text("接收应用推送通知")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .leading) {
                    Toggle("自动锁定", isOn: binding(for: "autoLock"))
                    Text("在无操作时自动锁定应用")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - Styled Toggle Example
struct StyledToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    @Environment(\.colorScheme) var colorScheme
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
    
    var body: some View {
        Form {
            Section("自定义样式") {
                Toggle("深色模式", isOn: binding(for: "darkMode"))
                    .tint(.blue)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
                
                Toggle(isOn: binding(for: "darkMode")) {
                    HStack {
                        Image(systemName: viewModel.settings["darkMode"] == true ? "moon.fill" : "sun.max.fill")
                        Text("深色模式")
                    }
                }
                .toggleStyle(.button)
                .tint(.blue)
            }
            
            Section("自定义开关") {
                Toggle("自定义开关", isOn: $viewModel.customStyleToggle)
                    .toggleStyle(.custom)
                
                Toggle("开关选项", isOn: $viewModel.customStyleToggle)
                    .toggleStyle(.switch)
                    .tint(viewModel.customStyleToggle ? .green : .gray)
            }
            
            Section("预览效果") {
                VStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.settings["darkMode"] == true ? Color.black : Color.white)
                        .frame(height: 100)
                        .overlay {
                            Text("预览内容")
                                .foregroundStyle(viewModel.settings["darkMode"] == true ? .white : .black)
                        }
                        .shadow(radius: 5)
                }
                .padding(.vertical)
            }
        }
    }
}

// MARK: - State Toggle Example
struct StateToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        Form {
            Section("状态管理") {
                ForEach(viewModel.settings.keys.sorted(), id: \.self) { key in
                    Toggle(key.capitalized, isOn: binding(for: key))
                }
            }
            
            Section("持久化状态") {
                Toggle("深色模式", isOn: $isDarkMode)
                    .onChange(of: isDarkMode) { newValue in
                        viewModel.settings["darkMode"] = newValue
                    }
            }
            
            Section("状态依赖") {
                Toggle("通知", isOn: binding(for: "notifications"))
                
                if viewModel.settings["notifications"] == true {
                    Toggle("电子邮件", isOn: binding(for: "email"))
                    Toggle("短信", isOn: binding(for: "sms"))
                }
            }
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
}

// MARK: - Animated Toggle Example
struct AnimatedToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
    
    var body: some View {
        Form {
            Group {
                Section("基本动画") {
                    Toggle("动画开关", isOn: $viewModel.springToggle)
                        .animation(.spring(), value: viewModel.springToggle)
                    
                    if viewModel.springToggle {
                        Text("动画内容")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                
                Section("自定义动画") {
                    Toggle("缩放效果", isOn: $viewModel.scaleToggle)
                        .scaleEffect(viewModel.scaleToggle ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: viewModel.scaleToggle)
                    
                    Toggle("旋转效果", isOn: binding(for: "rotation"))
                        .rotationEffect(viewModel.settings["rotation"] == true ? .degrees(180) : .degrees(0))
                        .animation(.spring(), value: viewModel.settings["rotation"])
                }
                
                Section("组合动画") {
                    VStack {
                        Toggle("组合效果", isOn: binding(for: "combined"))
                        
                        if viewModel.settings["combined"] == true {
                            HStack {
                                ForEach(0..<3, id: \.self) { index in
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 20, height: 20)
                                        .scaleEffect(viewModel.settings["combined"] == true ? 1.0 : 0.5)
                                        .opacity(viewModel.settings["combined"] == true ? 1.0 : 0.3)
                                        .animation(
                                            .spring().delay(Double(index) * 0.1),
                                            value: viewModel.settings["combined"]
                                        )
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Combined Toggle Example
struct CombinedToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    @State private var showAlert = false
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
    
    var body: some View {
        Form {
            Section("功能组合") {
                Toggle("启用功能", isOn: binding(for: "feature"))
                
                if viewModel.settings["feature"] == true {
                    Toggle("高级选项", isOn: $viewModel.showAdvancedSettings)
                        .animation(.spring(), value: viewModel.showAdvancedSettings)
                    
                    if viewModel.showAdvancedSettings {
                        Toggle("选项 A", isOn: binding(for: "optionA"))
                        Toggle("选项 B", isOn: binding(for: "optionB"))
                        Toggle("选项 C", isOn: binding(for: "optionC"))
                    }
                }
            }
            
            Section("交互组合") {
                Toggle("重要功能", isOn: binding(for: "important"))
                    .onChange(of: viewModel.settings["important"]) { newValue in
                        if newValue == true {
                            showAlert = true
                        }
                    }
                
                if viewModel.settings["important"] == true {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("子功能 1", isOn: binding(for: "sub1"))
                        Toggle("子功能 2", isOn: binding(for: "sub2"))
                        Toggle("子功能 3", isOn: binding(for: "sub3"))
                    }
                    .padding(.leading)
                }
            }
        }
        .alert("确认", isPresented: $showAlert) {
            Button("确定") { }
            Button("取消") {
                viewModel.settings["important"] = false
            }
        } message: {
            Text("是否确定启用此功能？")
        }
    }
}

// MARK: - Optimized Toggle Example
struct OptimizedToggleExample: View {
    @ObservedObject var viewModel: ToggleViewModel
    @State private var cache: [String: Bool] = [:]
    @State private var updating = false
    
    var body: some View {
        Form {
            Section("延迟加载") {
                Toggle("显示高级选项", isOn: $viewModel.showAdvancedSettings.animation())
                
                Toggle("基本选项", isOn: $viewModel.basicToggle)
                
                if viewModel.showAdvancedSettings {
                    LazyVStack {
                        ForEach(0..<5) { index in
                            Toggle("高级选项 \(index + 1)", isOn: binding(for: "advanced\(index)"))
                        }
                    }
                }
            }
            
            Section("缓存优化") {
                ForEach(viewModel.settings.keys.sorted(), id: \.self) { key in
                    Toggle(key.capitalized, isOn: binding(for: key))
                        .onChange(of: viewModel.settings[key]) { newValue in
                            if let newValue = newValue {
                                cache[key] = newValue
                            }
                        }
                }
            }
            
            Section("批量更新") {
                Button("重置所有设置") {
                    withAnimation {
                        updating = true
                        viewModel.resetSettings()
                        cache.removeAll()
                        updating = false
                    }
                }
                .disabled(updating)
            }
        }
        .onDisappear {
            // 清理缓存
            cache.removeAll()
        }
    }
    
    private func binding(for key: String) -> Binding<Bool> {
        Binding(
            get: { viewModel.settings[key] ?? false },
            set: { viewModel.updateSetting($0, for: key) }
        )
    }
}

// MARK: - Custom Toggle Style
struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                configuration.label
                Spacer()
                Circle()
                    .fill(configuration.isOn ? .green : .gray)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                            .foregroundStyle(.white)
                            .font(.caption2)
                    }
            }
        }
        .buttonStyle(.plain)
        .animation(.spring(), value: configuration.isOn)
    }
}

extension ToggleStyle where Self == CustomToggleStyle {
    static var custom: CustomToggleStyle { .init() }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        ToggleDemoView()
    }
}
