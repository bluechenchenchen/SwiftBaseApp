import SwiftUI

struct UIHomeContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(viewModel.controls.keys).sorted, id: \.self) { type in
                    if let controls = viewModel.controls[type] {
                        Section {
                            ForEach(controls) { control in
                                NavigationLink {
                                    viewModel.destinationView(for: control)
                                } label: {
                                    HStack(spacing: 16) {
                                        Image(systemName: iconName(for: control))
                                            .font(.title2)
                                            .foregroundColor(.accentColor)
                                            .frame(width: 32)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(control.title)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            Text(control.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                        } header: {
                            HStack {
                                Text(type.title)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .textCase(nil)
                                Spacer()
                                Text("共 \(controls.count) 项")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SwiftUI 控件")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func iconName(for control: ControlItem) -> String {
        switch control.type {
        case .basic:
            switch control.title {
            case "Text 文本控件": return "text.alignleft"
            case "Input 输入控件": return "keyboard"
            case "Image 图片控件": return "photo"
            case "Button 按钮控件": return "hand.tap"
            case "Label 标签控件": return "tag"
            case "Link 链接控件": return "link"
            default: return "questionmark.circle"
            }
        case .layout:
            switch control.title {
            case "HStack 水平布局": return "arrow.left.and.right"
            case "VStack 垂直布局": return "arrow.up.and.down"
            case "ZStack 层叠布局": return "square.stack"
            case "LazyHStack 延迟水平布局": return "arrow.left.and.right"
            case "LazyVStack 延迟垂直布局": return "arrow.up.and.down"
            case "Grid 网格布局": return "square.grid.2x2"
            case "LazyGrid 网格布局": return "square.grid.3x3"
            default: return "square.grid.2x2"
            }
        case .container:
            switch control.title {
            case "NavigationStack 导航栈": return "arrow.triangle.turn.up.right.diamond"
            case "NavigationSplitView 分栏导航": return "rectangle.split.2x1"
            case "TabView 选项卡视图": return "rectangle.bottomthird.inset.filled"
            case "Group 分组容器": return "square.stack.3d.up"
            case "Form 表单容器": return "list.bullet.rectangle"
            default: return "square.3.stack.3d"
            }
        case .selection:
            switch control.title {
            case "Picker 选择器": return "slider.horizontal.3"
            case "DatePicker 日期选择器": return "calendar"
            case "ColorPicker 颜色选择器": return "eyedropper"
            case "Toggle 开关": return "switch.2"
            case "Slider 滑块": return "slider.horizontal.below.rectangle"
            case "Stepper 步进器": return "plusminus.circle"
            default: return "checkmark.circle"
            }
        case .indicator:
            switch control.title {
            case "ProgressView 进度指示器": return "circle.dotted.circle"
            case "Gauge 仪表控件": return "gauge"
            case "Badge 角标控件": return "bell.badge"
            default: return "gauge"
            }
        case .graphics:
            switch control.title {
            case "Shape 形状控件": return "square.on.circle"
            case "Path 路径控件": return "pencil.tip"
            case "Canvas 画布控件": return "paintbrush"
            case "Chart 图表控件": return "chart.bar"
            default: return "scribble"
            }
        case .list:
            switch control.title {
            case "List 列表控件": return "list.bullet"
            case "ForEach 循环控件": return "arrow.triangle.2.circlepath"
            default: return "list.bullet"
            }
        case .media:
            switch control.title {
            case "VideoPlayer 视频播放器": return "play.rectangle"
            default: return "play.circle"
            }
        }
    }
}

#Preview {
    UIHomeContentView()
}