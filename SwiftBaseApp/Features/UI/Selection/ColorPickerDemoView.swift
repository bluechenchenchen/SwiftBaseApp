import SwiftUI

// MARK: - ColorPicker Demo View
struct ColorPickerDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = ColorPickerViewModel()
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本选择器") {
                    VStack(spacing: 20) {
                        ColorPicker("选择颜色", selection: $viewModel.basicColor)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.basicColor)
                            .frame(height: 100)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "透明度支持") {
                    VStack(spacing: 20) {
                        ColorPicker(
                            "选择颜色",
                            selection: $viewModel.opacityColor,
                            supportsOpacity: true
                        )
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.opacityColor)
                            .frame(height: 100)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义标签") {
                    ColorPicker(selection: $viewModel.labelColor) {
                        Label("调色板", systemImage: "paintpalette.fill")
                    }
                    .padding()
                }
            }
            
            // MARK: - 主题定制
            ShowcaseSection("主题定制") {
                ShowcaseItem(title: "主题颜色") {
                    VStack(spacing: 20) {
                        Group {
                            ColorPicker("主要颜色", selection: binding(for: "primary"))
                            ColorPicker("次要颜色", selection: binding(for: "secondary"))
                            ColorPicker("强调色", selection: binding(for: "accent"))
                        }
                        
                        VStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.themeColors["primary"] ?? .blue)
                                .frame(height: 60)
                                .overlay {
                                    Text("主要颜色")
                                        .foregroundStyle(.white)
                                }
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.themeColors["secondary"] ?? .gray)
                                .frame(height: 60)
                                .overlay {
                                    Text("次要颜色")
                                        .foregroundStyle(.white)
                                }
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.themeColors["accent"] ?? .orange)
                                .frame(height: 60)
                                .overlay {
                                    Text("强调色")
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "渐变颜色") {
                    VStack(spacing: 20) {
                        ColorPicker("起始颜色", selection: $viewModel.gradientStartColor)
                        ColorPicker("结束颜色", selection: $viewModel.gradientEndColor)
                        
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.gradient)
                            .frame(height: 200)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(presetGradients, id: \.name) { preset in
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(preset.gradient)
                                            .frame(width: 60, height: 60)
                                        
                                        Text(preset.name)
                                            .font(.caption)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            viewModel.gradientStartColor = preset.colors[0]
                                            viewModel.gradientEndColor = preset.colors[1]
                                        }
                                    }
                                }
                            }
                        }
                        .frame(height: 100)
                    }
                    .padding()
                }
            }
            
            // MARK: - 样式美化
            ShowcaseSection("样式美化") {
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        ColorPicker("选择颜色", selection: $viewModel.styledColor)
                            .padding()
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        
                        VStack(spacing: 16) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.styledColor)
                                .frame(height: 200)
                                .shadow(radius: 5)
                            
                            Text("预览文本")
                                .font(.title)
                                .foregroundStyle(viewModel.styledColor)
                            
                            Circle()
                                .fill(viewModel.styledColor)
                                .frame(width: 60, height: 60)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .systemBackground))
                                .shadow(radius: 8)
                        )
                    }
                    .padding()
                }
            }
            
            // MARK: - 高级特性
            ShowcaseSection("高级特性") {
                ShowcaseItem(title: "本地化支持") {
                    VStack(spacing: 20) {
                        ColorPicker(
                            NSLocalizedString(
                                "color_picker_title",
                                comment: "Color picker title"
                            ),
                            selection: $viewModel.localizedColor
                        )
                        .environment(\.locale, .current)
                        
                        Text("当前语言：\(Locale.current.identifier)")
                            .foregroundStyle(.secondary)
                            
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.localizedColor)
                            .frame(height: 60)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "辅助功能") {
                    VStack(spacing: 20) {
                        ColorPicker("选择颜色", selection: $viewModel.accessibilityColor)
                            .accessibilityLabel("颜色选择器")
                            .accessibilityHint("选择界面主题颜色")
                        
                        ColorPicker(selection: $viewModel.accessibilityColor) {
                            Label("主题色", systemImage: "paintpalette")
                                .accessibilityLabel("主题颜色选择器")
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.accessibilityColor)
                            .frame(height: 60)
                    }
                    .padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示高级选项", isOn: $viewModel.showAdvancedOptions.animation())
                        
                        ColorPicker("基本颜色", selection: $viewModel.lazyColor)
                        
                        if viewModel.showAdvancedOptions {
                            ColorPicker(
                                "高级选项",
                                selection: $viewModel.lazyColor,
                                supportsOpacity: true
                            )
                        }
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.lazyColor)
                            .frame(height: 60)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        ColorPicker("选择颜色", selection: $viewModel.cachedColor)
                        
                        Text(cachedColorDescription(for: viewModel.cachedColor))
                            .foregroundStyle(.secondary)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(viewModel.cachedColor)
                            .frame(height: 60)
                        
                        Button("重置所有颜色") {
                            withAnimation {
                                viewModel.resetColors()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("ColorPicker 示例")
    }
    
    // MARK: - 辅助方法
    private func binding(for key: String) -> Binding<Color> {
        Binding(
            get: { viewModel.themeColors[key] ?? .clear },
            set: { viewModel.updateThemeColor($0, for: key) }
        )
    }
    
    private func cachedColorDescription(for color: Color) -> String {
        let key = "\(color)"
        let cache = viewModel.colorCache
        if let cached = cache[key] {
            return "缓存的颜色: \(cached)"
        }
        let description = "新颜色: \(color)"
        viewModel.colorCache[key] = color
        return description
    }
    
    // MARK: - 预设数据
    private struct GradientPreset {
        let name: String
        let colors: [Color]
        var gradient: LinearGradient {
            LinearGradient(
                colors: colors,
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private let presetGradients = [
        GradientPreset(name: "海洋", colors: [.blue, .cyan]),
        GradientPreset(name: "日落", colors: [.orange, .pink]),
        GradientPreset(name: "森林", colors: [.green, .mint]),
        GradientPreset(name: "紫罗兰", colors: [.purple, .indigo]),
        GradientPreset(name: "金属", colors: [.gray, .white])
    ]
}

// MARK: - View Model
class ColorPickerViewModel: ObservableObject {
    // MARK: - 基础示例颜色
    @Published var basicColor = Color.red
    @Published var opacityColor = Color.blue.opacity(0.5)
    @Published var labelColor = Color.green
    
    // MARK: - 主题颜色
    @Published var themeColors: [String: Color] = [
        "primary": .blue,
        "secondary": .gray,
        "accent": .orange
    ]
    
    // MARK: - 渐变颜色
    @Published var gradientStartColor = Color.blue
    @Published var gradientEndColor = Color.purple
    var gradient: LinearGradient {
        LinearGradient(
            colors: [gradientStartColor, gradientEndColor],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - 样式示例颜色
    @Published var styledColor = Color.indigo
    
    // MARK: - 高级特性颜色
    @Published var localizedColor = Color.orange
    @Published var accessibilityColor = Color.purple
    
    // MARK: - 性能优化颜色
    @Published var lazyColor = Color.mint
    @Published var cachedColor = Color.teal
    @Published var showAdvancedOptions = false
    
    // MARK: - 内部状态
    var colorCache: [String: Color] = [:]
    
    // MARK: - 方法
    func updateThemeColor(_ color: Color, for key: String) {
        themeColors[key] = color
    }
    
    func resetColors() {
        // 基础示例颜色
        basicColor = .red
        opacityColor = .blue.opacity(0.5)
        labelColor = .green
        
        // 主题颜色
        themeColors = [
            "primary": .blue,
            "secondary": .gray,
            "accent": .orange
        ]
        
        // 渐变颜色
        gradientStartColor = .blue
        gradientEndColor = .purple
        
        // 样式示例颜色
        styledColor = .indigo
        
        // 高级特性颜色
        localizedColor = .orange
        accessibilityColor = .purple
        
        // 性能优化颜色
        lazyColor = .mint
        cachedColor = .teal
        
        // 清理缓存
        colorCache.removeAll()
    }
    
    deinit {
        colorCache.removeAll()
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        ColorPickerDemoView()
    }
}
