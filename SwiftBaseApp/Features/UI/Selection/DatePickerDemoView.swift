import SwiftUI

// MARK: - DatePicker Demo View
struct DatePickerDemoView: View {
    // MARK: - 状态属性
    @StateObject private var viewModel = DatePickerViewModel()
    
    // MARK: - 主视图
    var body: some View {
        List {
            // MARK: - 基础用法
            ShowcaseSection("基础用法") {
                ShowcaseItem(title: "基本日期") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择日期",
                            selection: $viewModel.basicDate,
                            displayedComponents: [.date]
                        )
                        
                        Text("选择的日期：\(viewModel.basicDate, formatter: viewModel.dateFormatter)")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "日期时间") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择日期和时间",
                            selection: $viewModel.dateTimeDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        
                        Text("选择的日期时间：\(viewModel.dateTimeDate, formatter: viewModel.dateTimeFormatter)")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "图形样式") {
                    DatePicker(
                        "选择日期",
                        selection: $viewModel.graphicalDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                }
            }
            
            // MARK: - 时间选择
            ShowcaseSection("时间选择") {
                ShowcaseItem(title: "时间选择器") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择时间",
                            selection: $viewModel.timeOnlyDate,
                            displayedComponents: [.hourAndMinute]
                        )
                        
                        Text("选择的时间：\(viewModel.timeOnlyDate, formatter: viewModel.timeFormatter)")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "滚轮样式") {
                    DatePicker(
                        "选择时间",
                        selection: $viewModel.wheelTimeDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .padding()
                }
                
                ShowcaseItem(title: "时间范围") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择时间",
                            selection: $viewModel.futureTimeDate,
                            in: Date()...,
                            displayedComponents: [.hourAndMinute]
                        )
                        .datePickerStyle(.compact)
                        
                        Text("只能选择未来时间")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 日期范围
            ShowcaseSection("日期范围") {
                ShowcaseItem(title: "范围选择") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "开始日期",
                            selection: $viewModel.startDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        
                        DatePicker(
                            "结束日期",
                            selection: $viewModel.endDate,
                            in: viewModel.startDate...,
                            displayedComponents: [.date]
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("选择的范围：")
                                .font(.headline)
                            Text("从：\(viewModel.startDate, formatter: viewModel.dateFormatter)")
                            Text("到：\(viewModel.endDate, formatter: viewModel.dateFormatter)")
                        }
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "图形范围") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "开始日期",
                            selection: $viewModel.graphicalStartDate,
                            in: Date()...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        
                        DatePicker(
                            "结束日期",
                            selection: $viewModel.graphicalEndDate,
                            in: viewModel.graphicalStartDate...,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                    }
                    .padding()
                }
            }
            
            // MARK: - 样式美化
            ShowcaseSection("样式美化") {
                ShowcaseItem(title: "自定义样式") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择日期",
                            selection: $viewModel.styledDate,
                            displayedComponents: [.date]
                        )
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        
                        DatePicker(
                            "选择日期",
                            selection: $viewModel.styledDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .tint(.blue)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .systemBackground))
                                .shadow(radius: 3)
                        )
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "自定义布局") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("活动日期")
                            .font(.headline)
                        
                        DatePicker(
                            "选择日期",
                            selection: $viewModel.customLayoutDate,
                            displayedComponents: [.date]
                        )
                        .labelsHidden()
                        
                        Text("已选择：\(viewModel.customLayoutDate, formatter: viewModel.dateFormatter)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 高级特性
            ShowcaseSection("高级特性") {
                ShowcaseItem(title: "本地化支持") {
                    VStack(spacing: 20) {
                        DatePicker(
                            NSLocalizedString(
                                "选择日期",
                                comment: "Date picker title"
                            ),
                            selection: $viewModel.localizedDate,
                            displayedComponents: [.date]
                        )
                        .environment(\.locale, .current)
                        
                        Text("当前语言：\(Locale.current.identifier)")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "格式化示例") {
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("日期格式：")
                                .font(.headline)
                            Text(viewModel.formattedDate, style: .date)
                            
                            Text("时间格式：")
                                .font(.headline)
                            Text(viewModel.formattedDate, style: .time)
                            
                            Text("相对格式：")
                                .font(.headline)
                            Text(viewModel.formattedDate, style: .relative)
                            
                            Text("自定义格式：")
                                .font(.headline)
                            Text(viewModel.formattedDate.formatted(.dateTime.year().month().day()))
                        }
                        .padding(.vertical, 4)
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "时区处理") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择日期时间",
                            selection: $viewModel.timezoneDate
                        )
                        .environment(\.timeZone, TimeZone.current)
                        
                        Text("当前时区：\(TimeZone.current.identifier)")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            
            // MARK: - 性能优化
            ShowcaseSection("性能优化") {
                ShowcaseItem(title: "延迟加载") {
                    VStack(spacing: 20) {
                        Toggle("显示高级选项", isOn: $viewModel.showAdvancedOptions.animation())
                        
                        DatePicker(
                            "基本日期",
                            selection: $viewModel.lazyDate,
                            displayedComponents: [.date]
                        )
                        
                        if viewModel.showAdvancedOptions {
                            DatePicker(
                                "高级选项",
                                selection: $viewModel.lazyDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                        }
                    }
                    .padding()
                }
                
                ShowcaseItem(title: "缓存优化") {
                    VStack(spacing: 20) {
                        DatePicker(
                            "选择日期",
                            selection: $viewModel.cachedDate,
                            displayedComponents: [.date]
                        )
                        
                        Text(cachedDateString(for: viewModel.cachedDate))
                            .foregroundStyle(.secondary)
                        
                        Button("重置所有日期") {
                            withAnimation {
                                viewModel.resetDates()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("DatePicker 示例")
    }
    
    // MARK: - 辅助方法
    private func cachedDateString(for date: Date) -> String {
        let key = "\(date.timeIntervalSince1970)"
        let cache = viewModel.dateCache
        if let cached = cache[key] {
            return "缓存的值: \(cached)"
        }
        let formatted = viewModel.dateFormatter.string(from: date)
        viewModel.dateCache[key] = formatted
        return "新计算的值: \(formatted)"
    }
}

// MARK: - View Model
class DatePickerViewModel: ObservableObject {
    // MARK: - 基础日期
    @Published var basicDate = Date()
    @Published var dateTimeDate = Date()
    @Published var graphicalDate = Date()
    
    // MARK: - 时间选择
    @Published var timeOnlyDate = Date()
    @Published var wheelTimeDate = Date()
    @Published var futureTimeDate = Date()
    
    // MARK: - 日期范围
    @Published var startDate = Date()
    @Published var endDate = Date().addingTimeInterval(86400 * 7)  // 一周后
    @Published var graphicalStartDate = Date()
    @Published var graphicalEndDate = Date().addingTimeInterval(86400 * 14)  // 两周后
    
    // MARK: - 样式定制
    @Published var styledDate = Date()
    @Published var customLayoutDate = Date()
    
    // MARK: - 高级特性
    @Published var localizedDate = Date()
    @Published var formattedDate = Date()
    @Published var timezoneDate = Date()
    
    // MARK: - 性能优化
    @Published var lazyDate = Date()
    @Published var cachedDate = Date()
    @Published var showAdvancedOptions = false
    
    // MARK: - 内部状态
    var dateCache: [String: String] = [:]
    
    // MARK: - 格式化工具
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    // MARK: - 方法
    func resetDates() {
        // 基础日期
        basicDate = Date()
        dateTimeDate = Date()
        graphicalDate = Date()
        
        // 时间选择
        timeOnlyDate = Date()
        wheelTimeDate = Date()
        futureTimeDate = Date()
        
        // 日期范围
        startDate = Date()
        endDate = Date().addingTimeInterval(86400 * 7)
        graphicalStartDate = Date()
        graphicalEndDate = Date().addingTimeInterval(86400 * 14)
        
        // 样式定制
        styledDate = Date()
        customLayoutDate = Date()
        
        // 高级特性
        localizedDate = Date()
        formattedDate = Date()
        timezoneDate = Date()
        
        // 性能优化
        lazyDate = Date()
        cachedDate = Date()
        
        // 清理缓存
        dateCache.removeAll()
    }
    
    deinit {
        dateCache.removeAll()
    }
}

// MARK: - 预览
#Preview {
    NavigationStack {
        DatePickerDemoView()
    }
}
