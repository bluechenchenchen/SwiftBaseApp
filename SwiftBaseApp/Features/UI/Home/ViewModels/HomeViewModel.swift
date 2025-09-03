import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var controls: [ControlType: [ControlItem]] = [:]
    
    init() {
        setupControls()
    }
    
    private func setupControls() {
        // 基础控件
        controls[.basic] = [
            ControlItem(title: "Text 文本控件", description: "文本显示控件", type: .basic),
            ControlItem(title: "Input 输入控件", description: "输入控件", type: .basic),
            ControlItem(title: "Image 图片控件", description: "图片显示控件", type: .basic),
            ControlItem(title: "Button 按钮控件", description: "按钮控件", type: .basic),
            ControlItem(title: "Label 标签控件", description: "标签控件", type: .basic),
            ControlItem(title: "Link 链接控件", description: "链接控件", type: .basic)
        ]
        
        // 布局控件
        controls[.layout] = [
            ControlItem(title: "HStack 水平布局", description: "水平布局容器", type: .layout),
            ControlItem(title: "VStack 垂直布局", description: "垂直布局容器", type: .layout),
            ControlItem(title: "ZStack 层叠布局", description: "层叠布局容器", type: .layout),
            ControlItem(title: "LazyHStack 延迟水平布局", description: "延迟加载的水平布局", type: .layout),
            ControlItem(title: "LazyVStack 延迟垂直布局", description: "延迟加载的垂直布局", type: .layout),
            ControlItem(title: "Grid 网格布局", description: "网格布局容器", type: .layout),
            ControlItem(title: "LazyGrid 网格布局", description: "延迟加载的网格布局", type: .layout)
        ]
        
        // 容器控件
        controls[.container] = [
            ControlItem(title: "NavigationStack 导航栈", description: "导航栈容器", type: .container),
            ControlItem(title: "NavigationSplitView 分栏导航", description: "分栏导航容器", type: .container),
            ControlItem(title: "TabView 选项卡视图", description: "选项卡容器", type: .container),
            ControlItem(title: "Group 分组容器", description: "分组容器", type: .container),
            ControlItem(title: "Form 表单容器", description: "表单容器", type: .container)
        ]
        
        // 选择控件
        controls[.selection] = [
            ControlItem(title: "Picker 选择器", description: "通用选择器", type: .selection),
            ControlItem(title: "DatePicker 日期选择器", description: "日期选择器", type: .selection),
            ControlItem(title: "ColorPicker 颜色选择器", description: "颜色选择器", type: .selection),
            ControlItem(title: "Toggle 开关", description: "开关控件", type: .selection),
            ControlItem(title: "Slider 滑块", description: "滑块控件", type: .selection),
            ControlItem(title: "Stepper 步进器", description: "步进器控件", type: .selection)
        ]
        
        // 指示器控件
        controls[.indicator] = [
            ControlItem(title: "ProgressView 进度指示器", description: "进度指示器", type: .indicator),
            ControlItem(title: "Gauge 仪表控件", description: "仪表控件", type: .indicator),
            ControlItem(title: "Badge 角标控件", description: "角标控件", type: .indicator)
        ]
        
        // 图形控件
        controls[.graphics] = [
            ControlItem(title: "Shape 形状控件", description: "形状控件", type: .graphics),
            ControlItem(title: "Path 路径控件", description: "路径控件", type: .graphics),
            ControlItem(title: "Canvas 画布控件", description: "画布控件", type: .graphics),
            ControlItem(title: "Chart 图表控件", description: "图表控件", type: .graphics)
        ]
        
        // 列表和集合控件
        controls[.list] = [
            ControlItem(title: "List 列表控件", description: "列表控件", type: .list),
            ControlItem(title: "ForEach 循环控件", description: "循环控件", type: .list)
        ]
        
        // 媒体控件
        controls[.media] = [
            ControlItem(title: "VideoPlayer 视频播放器", description: "视频播放控件", type: .media)
        ]
    }
    
    @ViewBuilder
    func destinationView(for control: ControlItem) -> some View {
        NavigationStack {
            switch control.title {
            case "Text 文本控件":
                TextDemoView()
            case "Input 输入控件":
                InputDemoView()
            case "Image 图片控件":
                ImageDemoView()
            case "Button 按钮控件":
                ButtonDemoView()
            case "Label 标签控件":
                LabelDemoView()
            case "Link 链接控件":
                LinkDemoView()
            case "HStack 水平布局":
                HStackDemoView()
            case "VStack 垂直布局":
                VStackDemoView()
            case "ZStack 层叠布局":
                ZStackDemoView()
            case "LazyHStack 延迟水平布局":
                LazyHStackDemoView()
            case "LazyVStack 延迟垂直布局":
                LazyVStackDemoView()
            case "Grid 网格布局":
                GridDemoView()
            case "NavigationStack 导航栈":
                NavigationStackDemoView()
            case "NavigationSplitView 分栏导航":
                NavigationSplitViewDemoView()
            case "TabView 选项卡视图":
                TabViewDemoView()
            case "Group 分组容器":
                GroupDemoView()
            case "Form 表单容器":
                FormDemoView()
            case "Picker 选择器":
                PickerDemoView()
            case "DatePicker 日期选择器":
                DatePickerDemoView()
            case "ColorPicker 颜色选择器":
                ColorPickerDemoView()
            case "Toggle 开关":
                ToggleDemoView()
            case "Slider 滑块":
                SliderDemoView()
            case "Stepper 步进器":
                StepperDemoView()
            case "ProgressView 进度指示器":
                ProgressViewDemoView()
            case "Gauge 仪表控件":
                GaugeDemoView()
            case "Badge 角标控件":
                BadgeDemoView()
            case "Shape 形状控件":
                ShapeDemoView()
            case "Path 路径控件":
                PathDemoView()
            case "Canvas 画布控件":
                CanvasDemoView()
            case "Chart 图表控件":
                ChartDemoView()
            case "List 列表控件":
                ListDemoView()
            case "ForEach 循环控件":
                ForEachDemoView()
            case "LazyGrid 网格布局":
                LazyGridDemoView()
            case "VideoPlayer 视频播放器":
                VideoPlayerDemoView()
            default:
                Text("待实现")
            }
        }
    }
}