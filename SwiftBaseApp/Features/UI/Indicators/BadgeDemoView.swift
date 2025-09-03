import SwiftUI

// MARK: - 辅助视图

/// 消息列表项
struct MessageListItem: View {
    let title: String
    let subtitle: String
    let time: String
    let unreadCount: Int
    
    var body: some View {
        HStack {
            // 头像
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(String(title.prefix(1)))
                        .font(.title2)
                        .foregroundColor(.gray)
                )
            
            // 内容
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // 时间和未读数
            VStack(alignment: .trailing, spacing: 4) {
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if unreadCount > 0 {
                    Text("\(unreadCount)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

/// 带角标的自定义按钮
struct BadgedButton: View {
    let title: String
    let icon: String
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topTrailing) {
                VStack {
                    Image(systemName: icon)
                        .font(.title2)
                    Text(title)
                        .font(.caption)
                }
                .frame(width: 60, height: 60)
                
                if count > 0 {
                    Text(count > 99 ? "99+" : "\(count)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, count > 99 ? 4 : 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .offset(x: 15, y: -5)
                }
            }
        }
    }
}

/// 带角标的 TabView 示例
struct TabViewWithBadges: View {
    @State private var selectedTab = 0
    @State private var messageCount = 3
    @State private var notificationCount = 12
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("首页内容")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("首页")
                }
                .tag(0)
            
            Text("消息内容")
                .badge(messageCount)
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("消息")
                }
                .tag(1)
            
            Text("通知内容")
                .badge(notificationCount)
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("通知")
                }
                .tag(2)
            
            Text("我的内容")
                .badge("")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("我的")
                }
                .tag(3)
        }
    }
}

// MARK: - 主视图
struct BadgeDemoView: View {
    @State private var messageCount = 5
    @State private var showNewFeature = true
    @State private var selectedTab = 0
    
    // 模拟消息列表数据
    let messages = [
        (title: "产品团队", subtitle: "新功能发布说明", time: "10:30", count: 3),
        (title: "系统通知", subtitle: "您的账号有新的登录", time: "09:15", count: 1),
        (title: "技术支持", subtitle: "问题已解决", time: "昨天", count: 0),
        (title: "运营团队", subtitle: "活动预告", time: "昨天", count: 2)
    ]
    
    var body: some View {
        List {
            // MARK: - 基础用法
            Section("基础用法") {
                // 1. 数字角标
                HStack {
                    Text("数字角标")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("消息")
                        .badge(messageCount)
                }
                
                // 2. 文本角标
                HStack {
                    Text("文本角标")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("设置")
                        .badge("新")
                }
                
                // 3. 空角标（红点提示）
                HStack {
                    Text("空角标（红点）")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("更新")
                        .badge("")
                }
            }
            
            // MARK: - 样式定制
            Section("样式定制") {
                // 1. 自定义颜色
                HStack {
                    Text("自定义颜色")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("通知")
                        .badge(3)
                        .foregroundColor(.white)
                        .tint(.blue)
                }
                
                // 2. 自定义位置和大小
                VStack(alignment: .leading) {
                    Text("自定义位置和大小")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Spacer()
                        ZStack(alignment: .topTrailing) {
                            Text("消息中心")
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            Text("\(messageCount)")
                                .font(.caption2)
                                .padding(4)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .offset(x: 10, y: -10)
                        }
                        Spacer()
                    }
                }
            }
            
            // MARK: - 实际应用场景
            Section("实际应用场景") {
                // 1. 消息列表
                VStack(alignment: .leading) {
                    Text("消息列表")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    
                    ForEach(messages, id: \.title) { message in
                        MessageListItem(
                            title: message.title,
                            subtitle: message.subtitle,
                            time: message.time,
                            unreadCount: message.count
                        )
                        if message.title != messages.last?.title {
                            Divider()
                        }
                    }
                }
                
                // 2. 功能按钮
                VStack(alignment: .leading) {
                    Text("功能按钮")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 4)
                    
                    HStack {
                        Spacer()
                        BadgedButton(
                            title: "消息",
                            icon: "message.fill",
                            count: messageCount
                        ) {
                            messageCount += 1
                        }
                        
                        Spacer()
                        BadgedButton(
                            title: "通知",
                            icon: "bell.fill",
                            count: 99
                        ) {
                            // 处理点击事件
                        }
                        
                        Spacer()
                        BadgedButton(
                            title: "设置",
                            icon: "gear",
                            count: showNewFeature ? 1 : 0
                        ) {
                            showNewFeature.toggle()
                        }
                        Spacer()
                    }
                }
                
                // 3. TabView 示例
                VStack(alignment: .leading) {
                    Text("TabView 示例")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TabViewWithBadges()
                        .frame(height: 200)
                }
            }
            
            // MARK: - 控制按钮
            Section("控制") {
                HStack {
                    Button("增加消息数") {
                        withAnimation {
                            messageCount += 1
                        }
                    }
                    .buttonStyle(.borderless)
                    
                    Spacer()
                    
                    Button("重置") {
                        withAnimation {
                            messageCount = 0
                            showNewFeature = false
                        }
                    }
                    .buttonStyle(.borderless)
                }
                
                Toggle("显示新功能标记", isOn: $showNewFeature)
            }
        }
        .navigationTitle("Badge 示例")
    }
}

#Preview {
    NavigationStack {
        BadgeDemoView()
    }
}
