import SwiftUI

struct ControlItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let type: ControlType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ControlItem, rhs: ControlItem) -> Bool {
        lhs.id == rhs.id
    }
}

enum ControlType: Int, CaseIterable {
    case basic = 0
    case layout = 1
    case container = 2
    case selection = 3
    case indicator = 4
    case graphics = 5
    case list = 6
    case media = 7
    
    var title: String {
        switch self {
        case .basic: return "基础控件"
        case .layout: return "布局控件"
        case .container: return "容器控件"
        case .selection: return "选择控件"
        case .indicator: return "指示器控件"
        case .graphics: return "图形控件"
        case .list: return "列表和集合控件"
        case .media: return "媒体控件"
        }
    }
}

// 扩展 Array 以支持 ControlType 排序
extension Array where Element == ControlType {
    var sorted: [ControlType] {
        self.sorted { $0.rawValue < $1.rawValue }
    }
}