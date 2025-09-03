import SwiftUI
import AVKit

struct VideoPlayerDemoView: View {
    // MARK: - Properties
    @State private var selectedDemo = 0
    @State private var isPlaying = false
    
    // 示例视频URL
    private let localVideoURL = Bundle.main.url(forResource: "demo", withExtension: "mp4")
    private let remoteVideoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
    
    // MARK: - Demo List
    private let demos = [
        "基础播放器",
        "自定义控制器",
        "全屏播放",
        "状态监控",
        "错误处理"
    ]
    
    // MARK: - Body
    var body: some View {
        List {
            Section(header: Text("示例列表")) {
                Picker("选择示例", selection: $selectedDemo) {
                    ForEach(0..<demos.count, id: \.self) { index in
                        Text(demos[index]).tag(index)
                    }
                }
                .pickerStyle(.menu)
                
                switch selectedDemo {
                case 0:
                    basicPlayerDemo
                case 1:
                    customControllerDemo
                case 2:
                    fullscreenPlayerDemo
                case 3:
                    stateMonitoringDemo
                case 4:
                    errorHandlingDemo
                default:
                    Text("未知示例")
                }
            }
            
            Section(header: Text("说明")) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("VideoPlayer 控件示例")
                        .font(.headline)
                    Text("本示例展示了 SwiftUI VideoPlayer 的各种用法，包括基础播放、自定义控制、全屏播放等功能。")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("VideoPlayer")
    }
    
    // MARK: - Basic Player Demo
    private var basicPlayerDemo: some View {
        VStack {
            Text("基础视频播放器")
                .font(.headline)
            
            VideoPlayer(player: AVPlayer(url: remoteVideoURL))
                .frame(height: 300)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding()
    }
    
    // MARK: - Custom Controller Demo
    private var customControllerDemo: some View {
        VStack {
            Text("自定义控制器")
                .font(.headline)
            
            let player = AVPlayer(url: remoteVideoURL)
            
            VideoPlayer(player: player)
                .frame(height: 300)
                .cornerRadius(8)
                .overlay(
                    Button(action: {
                        isPlaying.toggle()
                        if isPlaying {
                            player.play()
                        } else {
                            player.pause()
                        }
                    }) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                    }
                )
                .padding()
        }
    }
    
    // MARK: - Fullscreen Player Demo
    private var fullscreenPlayerDemo: some View {
        VStack {
            Text("全屏播放")
                .font(.headline)
            
            let player = AVPlayer(url: remoteVideoURL)
            
            VideoPlayer(player: player)
                .frame(height: 300)
                .cornerRadius(8)
                .onAppear {
                    // 配置全屏播放
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.allowsPictureInPicturePlayback = true
                    playerViewController.entersFullScreenWhenPlaybackBegins = true
                }
        }
        .padding()
    }
    
    // MARK: - State Monitoring Demo
    private var stateMonitoringDemo: some View {
        VStack {
            Text("状态监控")
                .font(.headline)
            
            let player = AVPlayer(url: remoteVideoURL)
            
            VideoPlayer(player: player)
                .frame(height: 300)
                .cornerRadius(8)
                .onAppear {
                    // 添加状态观察
                    player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { time in
                        let seconds = CMTimeGetSeconds(time)
                        print("当前播放时间: \(seconds)秒")
                    }
                }
        }
        .padding()
    }
    
    // MARK: - Error Handling Demo
    private var errorHandlingDemo: some View {
        VStack {
            Text("错误处理")
                .font(.headline)
            
            // 使用一个无效的URL来演示错误处理
            let invalidURL = URL(string: "https://invalid-url.com/video.mp4")!
            let player = AVPlayer(url: invalidURL)
            
            VideoPlayer(player: player)
                .frame(height: 300)
                .cornerRadius(8)
                .overlay(
                    Text("视频加载失败")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                )
        }
        .padding()
    }
}

// MARK: - Preview
struct VideoPlayerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VideoPlayerDemoView()
        }
    }
}
