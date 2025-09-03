import SwiftUI

// MARK: - 自定义进度条样式

/// 渐变色进度条样式
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

/// 自定义圆形进度条样式
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

/// 带缓冲的进度条样式（视频播放样式）
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

// MARK: - 辅助视图组件

/// 文件下载进度视图
struct FileDownloadProgressView: View {
    @State private var progress = 0.0
    @State private var downloadSpeed = 0.0 // KB/s
    @State private var remainingTime = 0 // 秒
    let totalSize: Double = 1024 // KB
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var isDownloading = false
    
    var body: some View {
        VStack(spacing: 8) {
            ProgressView(value: progress) {
                HStack {
                    Text("下载中")
                    Spacer()
                    Text("\(Int(progress * 100))%")
                }
            }
            .progressViewStyle(GradientProgressStyle())
            
            HStack {
                Text("速度: \(String(format: "%.1f", downloadSpeed)) KB/s")
                Spacer()
                Text("剩余时间: \(formatTime(remainingTime))")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            
            Button(isDownloading ? "暂停下载" : "开始下载") {
                isDownloading.toggle()
                if !isDownloading {
                    // 重置状态
                    progress = 0.0
                    downloadSpeed = 0.0
                    remainingTime = 0
                }
            }
            .buttonStyle(.borderless)
        }
        .onReceive(timer) { _ in
            if isDownloading && progress < 1.0 {
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
                
                if progress >= 1.0 {
                    isDownloading = false
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

/// 视频播放进度视图
struct VideoProgressView: View {
    @State private var progress = 0.0
    @State private var bufferedProgress = 0.0
    @State private var isPlaying = false
    let duration: TimeInterval = 300 // 5分钟视频
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            // 视频内容占位
            Rectangle()
                .fill(Color.black)
                .aspectRatio(16/9, contentMode: .fit)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .opacity(isPlaying ? 0 : 0.8)
                )
            
            // 进度控制栏
            HStack {
                // 播放/暂停按钮
                Button(action: { isPlaying.toggle() }) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                }
                .foregroundColor(.primary)
                
                // 当前时间
                Text(formatTime(progress * duration))
                    .font(.caption)
                    .monospacedDigit()
                
                // 进度条
                ProgressView(value: progress)
                    .progressViewStyle(BufferedProgressStyle(bufferedProgress: bufferedProgress))
                
                // 总时长
                Text(formatTime(duration))
                    .font(.caption)
                    .monospacedDigit()
            }
            .padding(.horizontal)
        }
        .onReceive(timer) { _ in
            if isPlaying {
                // 更新播放进度
                progress = min(1.0, progress + 0.001)
                // 模拟缓冲进度
                bufferedProgress = min(1.0, progress + 0.1)
                
                if progress >= 1.0 {
                    isPlaying = false
                }
            }
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

/// 多文件上传进度视图
struct MultiFileUploadView: View {
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
    
    @State var files: [UploadFile] = [
        UploadFile(name: "文档1.pdf", progress: 0.0, status: .waiting),
        UploadFile(name: "图片1.jpg", progress: 0.0, status: .waiting),
        UploadFile(name: "视频1.mp4", progress: 0.0, status: .waiting)
    ]
    
    var totalProgress: Double {
        files.reduce(0.0) { $0 + $1.progress } / Double(files.count)
    }
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var currentUploadIndex = 0
    @State private var isUploading = false
    
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
            .progressViewStyle(GradientProgressStyle())
            
            // 文件列表
            ForEach(files.indices, id: \.self) { index in
                HStack {
                    // 文件图标
                    Image(systemName: "doc")
                    
                    VStack(alignment: .leading) {
                        Text(files[index].name)
                            .font(.caption)
                        ProgressView(value: files[index].progress)
                    }
                    
                    // 状态图标
                    statusIcon(for: files[index].status)
                }
            }
            
            Button(isUploading ? "暂停上传" : "开始上传") {
                isUploading.toggle()
                if !isUploading {
                    // 重置所有未完成的文件
                    for index in currentUploadIndex..<files.count {
                        if files[index].status != .completed {
                            files[index].progress = 0.0
                            files[index].status = .waiting
                        }
                    }
                } else {
                    // 开始上传当前文件
                    if files[currentUploadIndex].status == .waiting {
                        files[currentUploadIndex].status = .uploading
                    }
                }
            }
            .buttonStyle(.borderless)
        }
        .padding()
        .onReceive(timer) { _ in
            if isUploading && currentUploadIndex < files.count {
                // 更新当前文件的进度
                if files[currentUploadIndex].status == .uploading {
                    files[currentUploadIndex].progress = min(1.0, files[currentUploadIndex].progress + 0.01)
                    
                    // 检查是否完成
                    if files[currentUploadIndex].progress >= 1.0 {
                        files[currentUploadIndex].status = .completed
                        currentUploadIndex += 1
                        
                        // 检查是否还有下一个文件
                        if currentUploadIndex < files.count {
                            files[currentUploadIndex].status = .uploading
                        } else {
                            isUploading = false
                        }
                    }
                }
            }
        }
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

// MARK: - 主视图
struct ProgressViewDemoView: View {
    @State private var progress = 0.0
    @State private var isUploading = false
    @State private var uploadProgress = 0.0
    
    // 模拟上传进度的定时器
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        List {
            // MARK: - 基础样式
            Section("基础样式") {
                // 1. 不定进度指示器
                VStack(alignment: .leading) {
                    Text("不定进度指示器")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ProgressView()
                }
                
                // 2. 带标题的不定进度指示器
                VStack(alignment: .leading) {
                    Text("带标题的不定进度指示器")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ProgressView("加载中...")
                }
                
                // 3. 确定进度条
                VStack(alignment: .leading) {
                    Text("确定进度条")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ProgressView(value: progress)
                    Button("重置进度") {
                        progress = 0.0
                    }
                    .buttonStyle(.borderless)
                }
            }
            
            // MARK: - 样式定制
            Section("样式定制") {
                // 1. 渐变进度条
                VStack(alignment: .leading) {
                    Text("渐变进度条")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ProgressView(value: progress)
                        .progressViewStyle(GradientProgressStyle())
                }
                
                // 2. 圆形进度条
                VStack(alignment: .leading) {
                    Text("圆形进度条")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        ProgressView(value: progress)
                            .progressViewStyle(CircularProgressStyle())
                            .frame(width: 50, height: 50)
                        Spacer()
                    }
                }
                
                // 3. 带缓冲的进度条
                VStack(alignment: .leading) {
                    Text("带缓冲的进度条")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ProgressView(value: progress)
                        .progressViewStyle(BufferedProgressStyle(bufferedProgress: min(1.0, progress + 0.2)))
                }
            }
            
            // MARK: - 实际应用场景
            Section("实际应用场景") {
                // 1. 文件下载进度
                VStack(alignment: .leading) {
                    Text("文件下载进度")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    FileDownloadProgressView()
                }
                
                // 2. 视频播放进度
                VStack(alignment: .leading) {
                    Text("视频播放进度")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    VideoProgressView()
                }
                
                // 3. 多文件上传
                VStack(alignment: .leading) {
                    Text("多文件上传")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    MultiFileUploadView()
                }
            }
            
            // MARK: - 控制按钮
            Section("控制") {
                HStack {
                    Button("增加进度") {
                        withAnimation {
                            progress = min(1.0, progress + 0.1)
                        }
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                    
                    Button("重置") {
                        withAnimation {
                            progress = 0.0
                        }
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .navigationTitle("ProgressView 示例")
    }
}

#Preview {
    NavigationStack {
        ProgressViewDemoView()
    }
}