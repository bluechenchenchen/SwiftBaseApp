import SwiftUI

// MARK: - 自定义样式
struct CustomGaugeStyle: GaugeStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: configuration.value)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            VStack {
                configuration.currentValueLabel
                    .font(.system(.title2, design: .rounded))
                    .bold()
                configuration.label
                    .font(.caption)
            }
        }
    }
}

// MARK: - 辅助视图

/// CPU 使用率监控
struct CPUGaugeView: View {
    @State private var cpuUsage: Double = 30
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Gauge(value: cpuUsage, in: 0...100) {
            Image(systemName: "cpu")
        } currentValueLabel: {
            Text("\(Int(cpuUsage))%")
        } minimumValueLabel: {
            Text("0")
        } maximumValueLabel: {
            Text("100")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(Gradient(colors: [.green, .yellow, .red]))
        .onReceive(timer) { _ in
            // 模拟 CPU 使用率变化
            withAnimation {
                cpuUsage = Double.random(in: 20...80)
            }
        }
    }
}

/// 电池电量显示
struct BatteryGaugeView: View {
    let batteryLevel: Double
    
    var body: some View {
        Gauge(value: batteryLevel, in: 0...100) {
            Image(systemName: batteryIcon)
        } currentValueLabel: {
            Text("\(Int(batteryLevel))%")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(batteryColor)
    }
    
    var batteryColor: Color {
        switch batteryLevel {
        case 0..<20: return .red
        case 20..<40: return .orange
        default: return .green
        }
    }
    
    var batteryIcon: String {
        switch batteryLevel {
        case 0..<20: return "battery.25"
        case 20..<40: return "battery.50"
        case 40..<80: return "battery.75"
        default: return "battery.100"
        }
    }
}

/// 温度计
struct ThermometerGaugeView: View {
    @State private var temperature: Double
    let range: ClosedRange<Double>
    
    init(temperature: Double = 25, range: ClosedRange<Double> = 0...50) {
        self._temperature = State(initialValue: temperature)
        self.range = range
    }
    
    var body: some View {
        Gauge(value: temperature, in: range) {
            Image(systemName: "thermometer")
        } currentValueLabel: {
            Text("\(Int(temperature))°C")
        } minimumValueLabel: {
            Text("\(Int(range.lowerBound))°")
        } maximumValueLabel: {
            Text("\(Int(range.upperBound))°")
        }
        .gaugeStyle(.accessoryCircular)
        .tint(temperatureGradient)
    }
    
    var temperatureGradient: Gradient {
        Gradient(colors: [.blue, .green, .yellow, .orange, .red])
    }
}

/// 速度计
struct SpeedometerGaugeView: View {
    @State private var speed: Double
    let maxSpeed: Double
    
    init(speed: Double = 0, maxSpeed: Double = 180) {
        self._speed = State(initialValue: speed)
        self.maxSpeed = maxSpeed
    }
    
    var body: some View {
        VStack {
            Gauge(value: speed, in: 0...maxSpeed) {
                Image(systemName: "speedometer")
            } currentValueLabel: {
                Text("\(Int(speed)) km/h")
            }
            .gaugeStyle(.accessoryCircularCapacity)
            .tint(speedGradient)
            .scaleEffect(1.5)
            
            HStack {
                Button("加速") {
                    withAnimation {
                        speed = min(maxSpeed, speed + 20)
                    }
                }
                .buttonStyle(.borderless)
                
                Button("减速") {
                    withAnimation {
                        speed = max(0, speed - 20)
                    }
                }
                .buttonStyle(.borderless)
            }
            .padding(.top)
        }
    }
    
    var speedGradient: Gradient {
        Gradient(colors: [.green, .yellow, .orange, .red])
    }
}

// MARK: - 主视图
struct GaugeDemoView: View {
    @State private var value = 0.0
    @State private var isAutoUpdating = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        List {
            // MARK: - 基础样式
            Section("基础样式") {
                // 1. 基础仪表盘
                VStack(alignment: .leading) {
                    Text("基础仪表盘")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Gauge(value: value, in: 0...100) {
                        Text("进度")
                    }
                }
                
                // 2. 带标签的仪表盘
                VStack(alignment: .leading) {
                    Text("带标签的仪表盘")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Gauge(value: value, in: 0...100) {
                        Text("进度")
                    } currentValueLabel: {
                        Text("\(Int(value))%")
                    }
                }
                
                // 3. 完整标签仪表盘
                VStack(alignment: .leading) {
                    Text("完整标签仪表盘")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Gauge(value: value, in: 0...100) {
                        Text("进度")
                    } currentValueLabel: {
                        Text("\(Int(value))%")
                    } minimumValueLabel: {
                        Text("0")
                    } maximumValueLabel: {
                        Text("100")
                    }
                }
            }
            
            // MARK: - 样式定制
            Section("样式定制") {
                // 1. 线性样式
                VStack(alignment: .leading) {
                    Text("线性样式")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Gauge(value: value, in: 0...100) {
                        Text("进度")
                    }
                    .gaugeStyle(.linearCapacity)
                }
                
                // 2. 圆形样式
                VStack(alignment: .leading) {
                    Text("圆形样式")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        Gauge(value: value, in: 0...100) {
                            Text("进度")
                        }
                        .gaugeStyle(.accessoryCircular)
                        .scaleEffect(1.5)
                        Spacer()
                    }
                }
                
                // 3. 访问计量表样式
                VStack(alignment: .leading) {
                    Text("访问计量表样式")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        Gauge(value: value, in: 0...100) {
                            Text("进度")
                        }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(Gradient(colors: [.green, .yellow, .red]))
                        .scaleEffect(1.5)
                        Spacer()
                    }
                }
                
                // 4. 自定义样式
                VStack(alignment: .leading) {
                    Text("自定义样式")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        Gauge(value: value, in: 0...100) {
                            Text("进度")
                        } currentValueLabel: {
                            Text("\(Int(value))%")
                        }
                        .gaugeStyle(CustomGaugeStyle())
                        .frame(width: 100, height: 100)
                        Spacer()
                    }
                }
            }
            
            // MARK: - 实际应用场景
            Section("实际应用场景") {
                // 1. CPU 监控
                VStack(alignment: .leading) {
                    Text("CPU 监控")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        CPUGaugeView()
                            .scaleEffect(1.5)
                        Spacer()
                    }
                }
                
                // 2. 电池电量
                VStack(alignment: .leading) {
                    Text("电池电量")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        BatteryGaugeView(batteryLevel: 85)
                            .scaleEffect(1.5)
                        Spacer()
                    }
                }
                
                // 3. 温度计
                VStack(alignment: .leading) {
                    Text("温度计")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Spacer()
                        ThermometerGaugeView()
                            .scaleEffect(1.5)
                        Spacer()
                    }
                }
                
                // 4. 速度计
                VStack(alignment: .leading) {
                    Text("速度计")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    SpeedometerGaugeView()
                }
            }
            
            // MARK: - 控制按钮
            Section("控制") {
                VStack {
                    HStack {
                        Button("增加") {
                            withAnimation {
                                value = min(100, value + 10)
                            }
                        }
                        .buttonStyle(.borderless)
                        
                        Spacer()
                        
                        Button("重置") {
                            withAnimation {
                                value = 0
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    Toggle("自动更新", isOn: $isAutoUpdating)
                }
            }
        }
        .onReceive(timer) { _ in
            if isAutoUpdating {
                withAnimation {
                    value = value < 100 ? value + 1 : 0
                }
            }
        }
        .navigationTitle("Gauge 示例")
    }
}

#Preview {
    NavigationStack {
        GaugeDemoView()
    }
}
