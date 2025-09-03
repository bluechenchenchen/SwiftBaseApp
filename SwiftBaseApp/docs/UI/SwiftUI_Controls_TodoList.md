# SwiftUI 控件文档和示例代码任务清单

## 文档结构说明

每个控件的文档将包含以下内容：

1. 基本介绍

   - 控件概述
   - 使用场景
   - 主要特性

2. 基础用法

   - 基本示例（尽可能多的示例，最好是全部）
   - 常用属性

3. 样式和自定义

   - 内置样式
   - 自定义修饰符
   - 主题适配

4. 高级特性

   - 组合使用
   - 动画效果
   - 状态管理

5. 性能优化

   - 最佳实践
   - 常见陷阱
   - 优化技巧

6. 辅助功能

   - 无障碍支持
   - 本地化
   - 动态类型

7. 示例代码

   - 基础示例
   - 进阶示例
   - 完整 Demo

8. 注意事项

   - 常见问题
   - 兼容性考虑
   - 使用建议

9. 完整运行 Demo
   - 源代码
   - 运行说明
   - 功能说明

## 任务清单

### 1. 基础控件

- [x] Button.md 和 ButtonDemoView（已完成）
- [x] Text.md 和 TextDemoView（已完成）
- [x] Label.md 和 LabelDemoView（已完成）
- [x] Image.md 和 ImageDemoView（已完成）
- [x] Input.md（包含 TextField、TextEditor、SecureField 的完整文档和示例）
- [x] Link.md 和 LinkDemoView（已完成）

### 2. 布局控件

- [x] HStack.md 和 HStackDemoView（已完成）
- [x] VStack.md 和 VStackDemoView（已完成）
- [x] ZStack.md 和 ZStackDemoView（已完成）
- [x] LazyHStack.md 和 LazyHStackDemoView（已完成）
- [x] LazyVStack.md 和 LazyVStackDemoView（已完成）
- [x] Grid.md 和 GridDemoView（已完成）

### 3. 容器控件

- [x] NavigationStack.md 和 NavigationStackDemoView（已完成）
- [x] NavigationSplitView.md 和 NavigationSplitViewDemoView（已完成）
- [x] TabView.md 和 TabViewDemoView（已完成）
- [x] Group.md 和 GroupDemoView（已完成）
- [x] Form.md 和 FormDemoView（已完成）

### 4. 选择控件

- [x] Picker.md 和 PickerDemoView（已完成）
- [x] DatePicker.md 和 DatePickerDemoView（已完成）
- [x] ColorPicker.md 和 ColorPickerDemoView（已完成）
- [x] Toggle.md 和 ToggleDemoView（已完成）
- [x] Slider.md 和 SliderDemoView（已完成）
- [x] Stepper.md 和 StepperDemoView（已完成）

### 5. 指示器控件

- [x] ProgressView.md 和 ProgressViewDemoView（已完成）
- [x] Gauge.md 和 GaugeDemoView（已完成）
- [x] Badge.md 和 BadgeDemoView（已完成）

### 6. 图形控件

- [x] Shape.md 和 ShapeDemoView（已完成）
- [x] Path.md 和 PathDemoView（已完成）
- [x] Canvas.md 和 CanvasDemoView（已完成）
- [x] Chart.md 和 ChartDemoView （已完成）

### 7. 列表和集合控件

- [x] List.md 和 ListDemoView（已完成）
- [x] ForEach.md 和 ForEachDemoView（已完成）
- [x] LazyGrid.md 和 LazyGridDemoView（已完成）

### 8. 媒体控件

- [x] VideoPlayer.md 和 VideoPlayerDemoView（已完成）
- [ ] PhotosPicker.md 和 PhotosPickerDemoView

### 9. 系统集成控件

- [ ] ShareLink.md 和 ShareLinkDemoView
- [ ] SignInWithAppleButton.md 和 SignInWithAppleButtonDemoView
- [ ] Map.md 和 MapDemoView
- [ ] WebView.md 和 WebViewDemoView

## 工作优先级

1. 基础控件（最高优先级）

   - 这些是最常用的控件
   - 为其他控件的使用奠定基础
   - 示例简单，容易理解

2. 布局控件（高优先级）

   - 是构建界面的基础
   - 影响其他控件的使用
   - 需要结合基础控件来展示

3. 容器控件（中高优先级）

   - 用于组织和管理视图
   - 需要结合多种控件来展示
   - 涉及导航和状态管理

4. 选择控件（中等优先级）

   - 常用于表单和数据输入
   - 需要结合状态管理
   - 有多种样式和用法

5. 其他控件（根据需求调整优先级）
   - 根据项目需求确定顺序
   - 可以并行开发
   - 注意控件之间的依赖关系

## 注意事项

1. 文档规范

   - 保持格式一致
   - 使用清晰的示例
   - 包含完整的说明

2. 代码规范

   - 遵循 Swift 最新语法
   - 使用有意义的命名
   - 添加适当的注释

3. 示例要求

   - 必须可以运行
   - 覆盖常见用例
   - 包含性能考虑
   - 检查命名，不能和其他的冲突
   - 必须尽可能多的各种场景示例

4. 维护建议
   - 定期更新文档
   - 及时修复问题
   - 收集用户反馈

## 导航更新说明

每完成一个控件的 Demo 后，需要在 `HomeViewContent.swift` 中进行以下更新：

1. 在 `basicControls` 数组中添加新控件

```swift
let basicControls = [
    "Text 文本控件",
    "Input 输入控件",
    "Image 图片控件",
    "Button 按钮控件",
    "Label 标签控件",  // 添加新控件
    // 后续可以添加更多控件
]
```

2. 在 `destinationView` 方法中添加对应的 case

```swift
@ViewBuilder
private func destinationView(for control: String) -> some View {
    switch control {
    case "Text 文本控件":
        TextDemoView()
    case "Input 输入控件":
        InputDemoView()
    case "Image 图片控件":
        ImageDemoView()
    case "Button 按钮控件":
        ButtonDemoView()
    case "Label 标签控件":  // 添加新控件的 case
        LabelDemoView()
    default:
        Text("待实现")
    }
}
```

3. 确保新添加的 DemoView 文件已经创建并正确导入

## 完成标准

1. 文档完整性

   - 包含所有规定的章节
   - 示例代码完整
   - 说明清晰详细

2. 代码质量

   - 通过编译
   - 运行正常
   - 性能良好

3. 用户体验

   - 示例直观
   - 操作流畅
   - 适配不同设备

4. 维护性
   - 代码结构清晰
   - 注释完整
   - 易于更新
