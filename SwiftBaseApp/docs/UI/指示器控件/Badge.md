# Badge 角标控件

## 1. 基本介绍

### 控件概述

Badge 是 SwiftUI 提供的角标控件，用于在视图上显示简短的补充信息或通知数量。它通常以小圆点或包含数字的小圆形标记的形式出现，是一种直观的方式来显示状态、计数或提醒。

### 使用场景

- TabView 项目上显示未读消息数
- List 项目上显示状态标记
- 导航项上显示提醒标记
- 按钮或图标上显示通知数量
- 列表项状态指示
- 功能更新提示

### 主要特性

- 支持数字和文本显示
- 自动适配系统样式
- 支持自定义颜色和样式
- 适配深色模式
- 支持动态更新
- 自动处理本地化

## 2. 基础用法

### 基本示例

1. 数字角标

```swift
Text("消息")
    .badge(5)
```

2. 文本角标

```swift
Text("设置")
    .badge("新")
```

3. 空角标（红点提示）

```swift
Text("更新")
    .badge("")
```

### 常用属性

- `badge()`: 添加角标
- `foregroundColor`: 设置角标颜色
- `font`: 设置角标字体
- `padding`: 调整角标内边距
- `background`: 设置角标背景

## 3. 样式和自定义

### 内置样式

1. 默认样式

```swift
Text("消息")
    .badge(10)
```

2. TabView 样式

```swift
TabView {
    Text("消息")
        .badge(5)
        .tabItem {
            Image(systemName: "message")
            Text("消息")
        }
}
```

### 自定义修饰符

1. 自定义颜色

```swift
Text("通知")
    .badge(3)
    .foregroundColor(.white)
    .tint(.blue)
```

2. 自定义位置和大小

```swift
ZStack(alignment: .topTrailing) {
    Text("消息")
    Text("99+")
        .font(.caption2)
        .padding(4)
        .background(Color.red)
        .clipShape(Circle())
        .offset(x: 10, y: -10)
}
```

### 主题适配

- 自动适配深色/浅色模式
- 支持自定义颜色方案
- 响应系统颜色变化

## 4. 高级特性

### 组合使用

1. 带角标的导航项

```swift
NavigationLink {
    MessageListView()
} label: {
    Label("消息", systemImage: "message")
        .badge(unreadCount)
}
```

2. 带角标的自定义按钮

```swift
Button {
    showMessages()
} label: {
    ZStack(alignment: .topTrailing) {
        Image(systemName: "bell.fill")
            .font(.title2)

        if notificationCount > 0 {
            Text("\(notificationCount)")
                .font(.caption2)
                .padding(4)
                .background(Color.red)
                .clipShape(Circle())
                .offset(x: 10, y: -10)
        }
    }
}
```

### 动画效果

1. 角标数量变化动画

```swift
Text("消息")
    .badge(messageCount)
    .animation(.spring(), value: messageCount)
```

2. 角标显示/隐藏动画

```swift
ZStack(alignment: .topTrailing) {
    Text("通知")
    if showBadge {
        Circle()
            .fill(Color.red)
            .frame(width: 8, height: 8)
            .offset(x: 10, y: -10)
            .transition(.scale.combined(with: .opacity))
    }
}
.animation(.spring(), value: showBadge)
```

### 状态管理

1. 基本状态

```swift
@State private var unreadCount = 0

Button("增加未读") {
    withAnimation {
        unreadCount += 1
    }
}
.badge(unreadCount)
```

2. 条件显示

```swift
struct NotificationItem: View {
    let title: String
    let count: Int

    var body: some View {
        Text(title)
            .badge(count > 0 ? count : nil)
    }
}
```

## 5. 性能优化

### 最佳实践

- 避免频繁更新角标
- 合理使用动画
- 适当缓存角标值
- 注意内存使用

### 常见陷阱

- 角标更新过于频繁
- 动画过于复杂
- 未处理大数值显示
- 位置计算不准确

### 优化技巧

- 使用防抖动控制更新频率
- 大数值使用"99+"等形式显示
- 避免复杂的自定义动画
- 注意角标在不同设备上的显示效果

## 6. 辅助功能

### 无障碍支持

- 支持 VoiceOver 读取角标内容
- 可自定义辅助标签
- 支持动态类型

### 本地化

- 支持数字格式本地化
- 文本内容本地化
- 适配不同语言和地区

### 动态类型

- 自动适配系统字体大小
- 保持布局稳定性
- 支持自定义字体大小

## 7. 示例代码

### 基础示例

参见 BadgeDemoView.swift 中的具体实现。

### 进阶示例

参见 BadgeDemoView.swift 中的消息列表和 TabView 示例。

## 8. 注意事项

### 常见问题

- 角标位置调整
- 数值格式化
- 动画性能优化
- 样式自定义限制

### 兼容性考虑

- iOS 15.0+ 支持
- 不同设备适配
- 系统版本差异

### 使用建议

- 合理使用角标提示
- 避免过多角标同时显示
- 注意用户体验
- 保持界面简洁

## 9. 完整运行 Demo

### 源代码

完整示例代码位于 Features/Indicators/BadgeDemoView.swift

### 运行说明

1. 打开项目
2. 运行模拟器或真机
3. 在主界面选择 Badge 示例

### 功能说明

- 展示各种角标样式
- 演示动画效果
- 提供实际应用场景示例
