# ProgressView 进度指示器

## 1. 基本介绍

### 控件概述

ProgressView 是 SwiftUI 提供的进度指示器控件，用于显示任务的进度或加载状态。它支持两种主要样式：

- 线性进度条（确定进度）
- 圆形旋转加载指示器（不定进度）

### 使用场景

- 显示文件上传/下载进度
- 展示任务完成百分比
- 指示后台操作的进行状态
- 展示加载或处理过程

### 主要特性

- 支持确定进度和不定进度两种模式
- 提供多种内置样式
- 可自定义外观和动画
- 支持进度标签和当前值显示
- 适配系统主题和动态类型

## 2. 基础用法

### 基本示例

1. 不定进度指示器（圆形旋转动画）

```swift
ProgressView()
```

2. 带标题的不定进度指示器

```swift
ProgressView("加载中...")
```

3. 确定进度条

```swift
ProgressView(value: 0.7)
```

4. 带值范围的进度条

```swift
ProgressView(value: 60, total: 100)
```

5. 自定义值范围和单位

```swift
// 自定义范围的进度条
ProgressView(value: temperature, total: 100) {
    Text("温度")
} currentValueLabel: {
    Text("\(Int(temperature))°C")
}

// 使用 fractionCompleted（0.0 到 1.0）
ProgressView(value: progress.fractionCompleted) {
    Text("下载进度")
}

// 带单位的进度显示（如文件大小）
ProgressView(value: downloadedSize, total: totalSize) {
    Text("下载中")
} currentValueLabel: {
    Text("\(formatFileSize(downloadedSize))/\(formatFileSize(totalSize))")
}
```

6. 带图标的进度指示器

```swift
HStack {
    ProgressView()
    Image(systemName: "icloud.and.arrow.down")
        .foregroundColor(.blue)
    Text("同步中...")
}
```

### 常用属性

- `value`: 当前进度值
- `total`: 进度总值
- `label`: 进度条标签
- `currentValueLabel`: 当前值标签
- `tint`: 进度条颜色

## 3. 样式和自定义

### 内置样式

1. 线性进度条样式

```swift
ProgressView(value: progress)
    .progressViewStyle(.linear)
```

2. 圆形旋转样式

```swift
ProgressView()
    .progressViewStyle(.circular)
```

### 自定义修饰符

```swift
ProgressView(value: progress)
    .tint(.blue)                    // 设置颜色
    .scaleEffect(1.2)              // 调整大小
    .padding()                      // 添加内边距
```

### 自定义进度条样式

1. 渐变色进度条

```swift
struct GradientProgressStyle: ProgressViewStyle {
    let gradient = LinearGradient(
        colors: [.blue, .purple],
        startPoint: .leading,
        endPoint: .trailing
    )

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.2))

                Rectangle()
                    .fill(gradient)
                    .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .frame(height: 8)
    }
}

// 使用自定义样式
ProgressView(value: progress)
    .progressViewStyle(GradientProgressStyle())
```

2. 圆形进度条

```swift
struct CircularProgressStyle: ProgressViewStyle {
    var strokeColor = Color.blue
    var strokeWidth = 8.0

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        return Circle()
            .trim(from: 0, to: fractionCompleted)
            .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            .rotationEffect(.degrees(-90))
            .animation(.linear, value: fractionCompleted)
    }
}

// 使用自定义圆形样式
ProgressView(value: progress)
    .progressViewStyle(CircularProgressStyle())
    .frame(width: 50, height: 50)
```

3. 带缓冲的进度条（视频播放样式）

```swift
struct BufferedProgressStyle: ProgressViewStyle {
    var bufferedProgress: Double

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // 背景
                Rectangle()
                    .foregroundColor(.gray.opacity(0.2))

                // 缓冲进度
                Rectangle()
                    .foregroundColor(.gray.opacity(0.3))
                    .frame(width: geometry.size.width * bufferedProgress)

                // 播放进度
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: geometry.size.width * (configuration.fractionCompleted ?? 0))
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .frame(height: 4)
    }
}

// 使用带缓冲的进度条
ProgressView(value: playProgress)
    .progressViewStyle(BufferedProgressStyle(bufferedProgress: bufferProgress))
```

### 主题适配

- 自动适配深色/浅色模式
- 支持自定义 accent color
- 响应系统颜色方案变化

## 4. 高级特性

### 组合使用

1. 带标签和当前值的进度条

```swift
ProgressView(value: progress) {
    Text("下载进度")
} currentValueLabel: {
    Text("\(Int(progress * 100))%")
}
```

2. 结合 Stack 布局

```swift
VStack {
    ProgressView(value: progress)
    Text("已完成: \(Int(progress * 100))%")
        .font(.caption)
}
```

3. 多任务进度展示

```swift
struct TaskProgress: Identifiable {
    let id = UUID()
    let name: String
    var progress: Double
}

struct MultiTaskProgressView: View {
    @State var tasks: [TaskProgress]

    var body: some View {
        VStack(spacing: 16) {
            ForEach(tasks) { task in
                VStack(alignment: .leading) {
                    Text(task.name)
                        .font(.caption)
                    ProgressView(value: task.progress) {
                        EmptyView()
                    } currentValueLabel: {
                        Text("\(Int(task.progress * 100))%")
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
    }
}
```

4. 分段进度展示

```swift
struct SegmentedProgressView: View {
    var segments: [(title: String, progress: Double)]
    var totalProgress: Double {
        segments.reduce(0) { $0 + $1.progress }
    }

    var body: some View {
        VStack(spacing: 8) {
            // 总进度
            ProgressView(value: totalProgress, total: Double(segments.count))

            // 分段进度
            ForEach(segments, id: \.title) { segment in
                HStack {
                    Text(segment.title)
                        .font(.caption)
                    Spacer()
                    ProgressView(value: segment.progress)
                        .frame(width: 100)
                    Text("\(Int(segment.progress * 100))%")
                        .font(.caption)
                        .frame(width: 40)
                }
            }
        }
        .padding()
    }
}
```

### 动画效果

1. 基础动画

```swift
withAnimation(.linear) {
    progress += 0.1
}
```

2. 弹性动画

```swift
withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
    progress += 0.1
}
```

3. 循环动画

```swift
struct PulsingProgressView: View {
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ProgressView()
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.0).repeatForever()) {
                    scale = 1.2
                }
            }
    }
}
```

### 状态管理

1. 基本状态

```swift
@State private var progress = 0.0

Button("增加进度") {
    withAnimation {
        progress = min(1.0, progress + 0.1)
    }
}
```

2. 带计时器的自动进度

```swift
struct TimedProgressView: View {
    @State private var progress = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ProgressView(value: progress)

            Button(progress < 1.0 ? "暂停" : "重新开始") {
                if progress >= 1.0 {
                    progress = 0.0
                }
            }
        }
        .onReceive(timer) { _ in
            if progress < 1.0 {
                withAnimation {
                    progress = min(1.0, progress + 0.01)
                }
            }
        }
    }
}
```

3. 异步任务进度

```swift
struct AsyncProgressView: View {
    @State private var progress = 0.0
    @State private var isLoading = false

    var body: some View {
        VStack {
            ProgressView(value: progress)

            Button(isLoading ? "取消" : "开始") {
                isLoading.toggle()
                if isLoading {
                    startAsyncTask()
                }
            }
        }
    }

    func startAsyncTask() {
        // 模拟异步任务
        Task {
            progress = 0.0
            while isLoading && progress < 1.0 {
                try? await Task.sleep(nanoseconds: 100_000_000)
                withAnimation {
                    progress = min(1.0, progress + 0.01)
                }
            }
        }
    }
}
```

## 5. 性能优化

### 最佳实践

- 避免频繁更新进度值
- 合理使用动画
- 在后台线程处理耗时操作

### 常见陷阱

- 进度更新过于频繁导致性能问题
- 动画过于复杂影响流畅度
- 未处理边界情况（如进度值超出范围）

### 优化技巧

- 使用 debounce 或 throttle 控制更新频率
- 适当使用 drawingGroup() 优化渲染
- 合理设置动画持续时间

## 6. 辅助功能

### 无障碍支持

- 自动朗读进度值
- 支持 VoiceOver
- 可自定义无障碍标签

### 本地化

- 支持进度文本本地化
- 适配不同语言和地区

### 动态类型

- 自动适配系统字体大小
- 保持布局稳定性

## 7. 示例代码

### 基础示例

参见 ProgressViewDemoView.swift 中的具体实现。

### 进阶示例

1. 文件下载进度（带速度和剩余时间）

```swift
struct FileDownloadProgressView: View {
    @State private var progress = 0.0
    @State private var downloadSpeed = 0.0 // KB/s
    @State private var remainingTime = 0 // 秒
    let totalSize: Double // KB
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress) {
                HStack {
                    Text("下载中")
                    Spacer()
                    Text("\(Int(progress * 100))%")
                }
            }

            HStack {
                Text("速度: \(String(format: "%.1f", downloadSpeed)) KB/s")
                Spacer()
                Text("剩余时间: \(formatTime(remainingTime))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .onReceive(timer) { _ in
            // 模拟下载进度更新
            if progress < 1.0 {
                let oldProgress = progress
                progress = min(1.0, progress + 0.01)

                // 计算下载速度
                let downloadedSize = progress * totalSize
                let previousSize = oldProgress * totalSize
                downloadSpeed = (downloadedSize - previousSize) / 0.1

                // 计算剩余时间
                if downloadSpeed > 0 {
                    let remainingSize = totalSize * (1.0 - progress)
                    remainingTime = Int(remainingSize / downloadSpeed)
                }
            }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        if seconds < 60 {
            return "\(seconds)秒"
        } else if seconds < 3600 {
            return "\(seconds / 60)分\(seconds % 60)秒"
        } else {
            return "\(seconds / 3600)时\((seconds % 3600) / 60)分"
        }
    }
}
```

2. 视频播放进度条

```swift
struct VideoProgressView: View {
    @State private var progress = 0.0
    @State private var bufferedProgress = 0.0
    @State private var isPlaying = false
    let duration: TimeInterval
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            // 视频内容占位
            Rectangle()
                .fill(Color.black)
                .aspectRatio(16/9, contentMode: .fit)

            // 进度控制栏
            HStack {
                // 播放/暂停按钮
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                }

                // 当前时间
                Text(formatTime(progress * duration))
                    .font(.caption)

                // 进度条
                ProgressView(value: progress)
                    .progressViewStyle(BufferedProgressStyle(bufferedProgress: bufferedProgress))

                // 总时长
                Text(formatTime(duration))
                    .font(.caption)
            }
            .padding(.horizontal)
        }
        .onReceive(timer) { _ in
            if isPlaying {
                // 更新播放进度
                progress = min(1.0, progress + 0.001)
                // 模拟缓冲进度
                bufferedProgress = min(1.0, progress + 0.1)
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
```

3. 多文件上传进度

```swift
struct MultiFileUploadView: View {
    @State var files: [UploadFile]
    @State private var totalProgress: Double {
        files.reduce(0.0) { $0 + $1.progress } / Double(files.count)
    }

    struct UploadFile: Identifiable {
        let id = UUID()
        let name: String
        var progress: Double
        var status: UploadStatus

        enum UploadStatus {
            case waiting
            case uploading
            case completed
            case failed
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // 总进度
            ProgressView(value: totalProgress) {
                HStack {
                    Text("总进度")
                    Spacer()
                    Text("\(Int(totalProgress * 100))%")
                }
            }

            // 文件列表
            ForEach($files) { $file in
                HStack {
                    // 文件图标
                    Image(systemName: "doc")

                    VStack(alignment: .leading) {
                        Text(file.name)
                            .font(.caption)
                        ProgressView(value: file.progress)
                    }

                    // 状态图标
                    statusIcon(for: file.status)
                }
            }
        }
        .padding()
    }

    @ViewBuilder
    private func statusIcon(for status: UploadFile.UploadStatus) -> some View {
        switch status {
        case .waiting:
            Image(systemName: "clock")
                .foregroundColor(.secondary)
        case .uploading:
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(0.5)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .failed:
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
        }
    }
}
```

## 8. 注意事项

### 常见问题

- 进度值范围控制
- 动画性能优化
- 状态管理最佳实践

### 兼容性考虑

- iOS 14.0+ 支持
- 不同设备适配
- 系统版本差异

### 使用建议

- 合理选择进度指示器样式
- 注意用户体验
- 保持界面响应性

## 9. 完整运行 Demo

### 源代码

完整示例代码位于 Features/Indicators/ProgressViewDemoView.swift

### 运行说明

1. 打开项目
2. 运行模拟器或真机
3. 在主界面选择 ProgressView 示例

### 功能说明

- 展示各种进度指示器样式
- 演示进度更新和动画效果
- 提供实际应用场景示例
