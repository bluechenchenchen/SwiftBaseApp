//
//  ResourceHomeView.swift
//  SwiftBaseApp
//
//  Created by Assistant on 2025/1/14.
//

import SwiftUI

struct ResourceHomeView: View {
  @StateObject private var viewModel = ResourceViewModel()
  
  private var sortedResourceTypes: [ResourceType] {
    Array(viewModel.resources.keys).sorted { $0.title < $1.title }
  }
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(sortedResourceTypes, id: \.self) { type in
          if let resources = viewModel.resources[type] {
            Section {
              ForEach(resources) { resource in
                NavigationLink {
                  viewModel.destinationView(for: resource)
                } label: {
                  HStack(spacing: 16) {
                    Image(systemName: iconName(for: resource))
                      .font(.title2)
                      .foregroundColor(.accentColor)
                      .frame(width: 32)
                    
                    VStack(alignment: .leading, spacing: 4) {
                      Text(resource.title)
                        .font(.body)
                        .foregroundColor(.primary)
                      Text(resource.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    }
                  }
                  .padding(.vertical, 8)
                }
              }
            } header: {
              HStack {
                Text(type.title)
                  .font(.headline)
                  .foregroundColor(.primary)
                  .textCase(nil)
                Spacer()
                Text("共 \(resources.count) 项")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
              .padding(.vertical, 8)
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("开发资源")
      .navigationBarTitleDisplayMode(.large)
    }
  }
  
  private func iconName(for resource: ResourceItem) -> String {
    switch resource.type {
    case .design:
      switch resource.title {
      case "SF Symbols 图标库": return "star.circle"
      case "颜色调色板": return "paintpalette"
      case "设计规范": return "ruler"
      default: return "paintbrush"
      }
    case .tools:
      switch resource.title {
      case "代码生成器": return "chevron.left.forwardslash.chevron.right"
      case "调试工具": return "ant"
      case "性能分析": return "speedometer"
      default: return "wrench.and.screwdriver"
      }
    case .reference:
      switch resource.title {
      case "API 参考": return "doc.text"
      case "最佳实践": return "star.square"
      case "代码示例": return "curlybraces"
      default: return "book"
      }
    }
  }
}

// MARK: - Resource Models

enum ResourceType: CaseIterable {
  case design
  case tools
  case reference
  
  var title: String {
    switch self {
    case .design: return "设计资源"
    case .tools: return "开发工具"
    case .reference: return "参考文档"
    }
  }
}

struct ResourceItem: Identifiable {
  let id = UUID()
  let title: String
  let description: String
  let type: ResourceType
}

// MARK: - Resource ViewModel

class ResourceViewModel: ObservableObject {
  @Published var resources: [ResourceType: [ResourceItem]] = [:]
  
  init() {
    setupResources()
  }
  
  private func setupResources() {
    // 设计资源
    let designResources = [
      ResourceItem(
        title: "SF Symbols 图标库",
        description: "iOS 内置图标展示和配置工具",
        type: .design
      ),
      ResourceItem(
        title: "颜色调色板",
        description: "系统颜色和自定义颜色管理",
        type: .design
      ),
      ResourceItem(
        title: "系统字体样式库",
        description: "SF Pro 字体族和排版样式展示",
        type: .design
      ),
      ResourceItem(
        title: "设计规范",
        description: "iOS 设计指南和最佳实践",
        type: .design
      )
    ]
    
    // 开发工具
    let toolResources = [
      ResourceItem(
        title: "代码生成器",
        description: "快速生成常用代码模板",
        type: .tools
      ),
      ResourceItem(
        title: "调试工具",
        description: "开发调试辅助工具",
        type: .tools
      ),
      ResourceItem(
        title: "性能分析",
        description: "应用性能监控和分析",
        type: .tools
      )
    ]
    
    // 参考文档
    let referenceResources = [
      ResourceItem(
        title: "API 参考",
        description: "SwiftUI API 快速参考",
        type: .reference
      ),
      ResourceItem(
        title: "最佳实践",
        description: "代码规范和最佳实践指南",
        type: .reference
      ),
      ResourceItem(
        title: "代码示例",
        description: "常用功能代码示例库",
        type: .reference
      )
    ]
    
    resources = [
      .design: designResources,
      .tools: toolResources,
      .reference: referenceResources
    ]
  }
  
  @ViewBuilder
  func destinationView(for resource: ResourceItem) -> some View {
    switch resource.title {
    case "SF Symbols 图标库":
      ResSFSymbolsShowcaseView()
    case "颜色调色板":
      ResColorPaletteView()
    case "系统字体样式库":
      ResFontLibraryView()
    case "设计规范":
      ResDesignGuideView()
    case "代码生成器":
      ResCodeGeneratorView()
    case "调试工具":
      ResDebugToolsView()
    case "性能分析":
      ResPerformanceAnalysisView()
    case "API 参考":
      ResAPIReferenceView()
    case "最佳实践":
      ResBestPracticesView()
    case "代码示例":
      ResCodeExamplesView()
    default:
      ResPlaceholderView(title: resource.title)
    }
  }
}

// MARK: - Placeholder Views (待实现的视图)

struct ResSFSymbolsShowcaseView: View {
  var body: some View {
    SFSymbolsShowcaseView()
  }
}

struct ResColorPaletteView: View {
  var body: some View {
    Text("颜色调色板")
      .navigationTitle("颜色调色板")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResFontLibraryView: View {
  var body: some View {
    FontLibraryView()
  }
}

struct ResDesignGuideView: View {
  var body: some View {
    Text("设计规范")
      .navigationTitle("设计规范")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResCodeGeneratorView: View {
  var body: some View {
    Text("代码生成器")
      .navigationTitle("代码生成器")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResDebugToolsView: View {
  var body: some View {
    Text("调试工具")
      .navigationTitle("调试工具")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResPerformanceAnalysisView: View {
  var body: some View {
    Text("性能分析")
      .navigationTitle("性能分析")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResAPIReferenceView: View {
  var body: some View {
    Text("API 参考")
      .navigationTitle("API 参考")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResBestPracticesView: View {
  var body: some View {
    Text("最佳实践")
      .navigationTitle("最佳实践")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResCodeExamplesView: View {
  var body: some View {
    Text("代码示例")
      .navigationTitle("代码示例")
      .navigationBarTitleDisplayMode(.large)
  }
}

struct ResPlaceholderView: View {
  let title: String
  
  var body: some View {
    VStack(spacing: 20) {
      Image(systemName: "wrench.and.screwdriver")
        .font(.system(size: 60))
        .foregroundColor(.secondary)
      
      Text("\(title)")
        .font(.title2)
        .fontWeight(.medium)
      
      Text("功能开发中...")
        .font(.body)
        .foregroundColor(.secondary)
    }
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.large)
  }
}

#Preview {
  ResourceHomeView()
}
