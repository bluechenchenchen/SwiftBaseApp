import SwiftUI

// MARK: - 主视图
struct TextDemoView: View {
  // MARK: - 状态属性
  @State private var count = 0
  @State private var showError = false
  @State private var selectedDate = Date()
  @State private var selectedStyle = 0
  @State private var textInput = ""
  
  // 示例数据
  let textStyles = ["默认", "标题", "副标题", "说明"]
  let textColors: [(name: String, color: Color)] = [
    ("蓝色", .blue),
    ("绿色", .green),
    ("红色", .red),
    ("紫色", .purple)
  ]
  
  var body: some View {
    ShowcaseList {
      // MARK: - 基础文本
      ShowcaseSection("基础文本") {
        ShowcaseItem(title: "普通文本",backgroundColor: Color.cyan.opacity(0.1)) {
          Text("这是一个普通文本示例")
            .font(.body)
            .padding(.vertical, 10)
        }
        
        ShowcaseItem(title: "格式化文本", backgroundColor: Color.green.opacity(0.1)) {
          VStack(alignment: .leading, spacing: 12) {
            Group {
              Text("数字格式化:")
                .font(.headline)
              Text("\(123.456, format: .number.precision(.fractionLength(2)))")
                .font(.body)
                .padding(.leading)
            }
            
            Group {
              Text("日期格式化:")
                .font(.headline)
              Text("\(Date(), style: .date)")
                .font(.body)
                .padding(.leading)
            }
          }
          .padding(.vertical, 10)
        }
        
        ShowcaseItem(title: "富文本") {
          VStack(alignment: .center, spacing: 12) {
            let attributedString: AttributedString = {
              var str = AttributedString("富文本示例")
              str.foregroundColor = .blue
              str.backgroundColor = .yellow.opacity(0.3)
              str.font = .title2.bold()
              return str
            }()
            
            Text(attributedString)
              .padding(.vertical, 4)
            
            Text("使用 AttributedString 可以创建更丰富的文本效果")
              .font(.caption)
              .foregroundStyle(.secondary)
          }
        }
      }
      
      // MARK: - 文本对齐
      ShowcaseSection("文本对齐") {
        ShowcaseItem(title: "多行文本对齐") {
          VStack(spacing: 20) {
            Group {
              Text("左对齐")
                .font(.headline)
              Text("这是一段较长的文本，用来演示左对齐效果。这是第二行文本，可以更好地看到对齐效果。")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .multilineTextAlignment(.leading)
            }
            
            Group {
              Text("居中对齐")
                .font(.headline)
              Text("这是一段较长的文本，用来演示居中对齐效果。这是第二行文本，可以更好地看到对齐效果。")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
                .multilineTextAlignment(.center)
            }
            
            Group {
              Text("右对齐")
                .font(.headline)
              Text("这是一段较长的文本，用来演示右对齐效果。这是第二行文本，可以更好地看到对齐效果。")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                .multilineTextAlignment(.trailing)
            }
          }
        }
        
        ShowcaseItem(title: "容器对齐") {
          VStack(spacing: 16) {
            Text("容器内文本对齐")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
              VStack(spacing: 12) {
                Text("左对齐")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
                  .background(Color.orange.opacity(0.1))
                  .cornerRadius(10)
                
                Text("居中对齐")
                  .frame(maxWidth: .infinity, alignment: .center)
                  .padding()
                  .background(Color.purple.opacity(0.1))
                  .cornerRadius(10)
                
                Text("右对齐")
                  .frame(maxWidth: .infinity, alignment: .trailing)
                  .padding()
                  .background(Color.pink.opacity(0.1))
                  .cornerRadius(10)
              }
            }
            //            .padding(.horizontal)
          }
        }
        
        ShowcaseItem(title: "文本截断") {
          VStack(spacing: 16) {
            Text("文本截断方式")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            Group {
              VStack(alignment: .leading, spacing: 8) {
                Text("头部截断")
                  .font(.subheadline)
                Text("这是一段很长的文本，超出部分会被截断。这段文本足够长，可以测试不同的截断对齐方式。")
                  .lineLimit(1)
                  .truncationMode(.head)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.brown.opacity(0.1))
              .cornerRadius(10)
              
              VStack(alignment: .leading, spacing: 8) {
                Text("中间截断")
                  .font(.subheadline)
                Text("这是一段很长的文本，超出部分会被截断。这段文本足够长，可以测试不同的截断对齐方式。")
                  .lineLimit(1)
                  .truncationMode(.middle)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.cyan.opacity(0.1))
              .cornerRadius(10)
              
              VStack(alignment: .leading, spacing: 8) {
                Text("尾部截断")
                  .font(.subheadline)
                Text("这是一段很长的文本，超出部分会被截断。这段文本足够长，可以测试不同的截断对齐方式。")
                  .lineLimit(1)
                  .truncationMode(.tail)
              }
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.indigo.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
      }
      
      // MARK: - 样式修饰
      ShowcaseSection("样式修饰") {
        ShowcaseItem(title: "字体样式") {
          VStack(spacing: 16) {
            Text("系统字体设计")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                Text("默认系统字体")
                  .font(.system(.body))
                Text("圆角字体设计")
                  .font(.system(.body, design: .rounded))
                Text("等宽字体设计")
                  .font(.system(.body, design: .monospaced))
                Text("衬线字体设计")
                  .font(.system(.body, design: .serif))
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
              .background(Color.blue.opacity(0.1))
              .cornerRadius(10)
            }
            
            Text("字体大小示例")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.top)
            
            VStack(spacing: 12) {
              Group {
                Text("大标题").font(.largeTitle)
                Text("标题").font(.title)
                Text("副标题").font(.headline)
                Text("正文").font(.body)
                Text("脚注").font(.footnote)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
              .background(Color.purple.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
        
        ShowcaseItem(title: "文本修饰") {
          VStack(spacing: 16) {
            Text("文本样式修饰")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                Text("粗体文本").bold()
                Text("斜体文本").italic()
                Text("下划线文本").underline()
                Text("删除线文本").strikethrough()
                Text("组合样式文本")
                  .bold()
                  .italic()
                  .underline()
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
              .background(Color.green.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
        
        ShowcaseItem(title: "颜色和背景") {
          VStack(spacing: 16) {
            Text("颜色样式")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              ForEach(textColors, id: \.name) { colorInfo in
                Text(colorInfo.name)
                  .foregroundStyle(colorInfo.color)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
                  .background(colorInfo.color.opacity(0.1))
                  .cornerRadius(10)
              }
            }
            
            Text("背景效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.top)
            
            HStack(spacing: 20) {
              Text("渐变背景")
                .foregroundStyle(.white)
                .padding()
                .background(
                  LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                  )
                )
                .cornerRadius(10)
              
              Text("阴影效果")
                .padding()
                .background(.white)
                .cornerRadius(10)
                .shadow(
                  color: .gray.opacity(0.3),
                  radius: 5,
                  x: 0,
                  y: 2
                )
            }
          }
        }
      }
      
      // MARK: - Markdown 支持
      ShowcaseSection("Markdown 支持") {
        ShowcaseItem(title: "基础语法") {
          VStack(spacing: 16) {
            Text("Markdown 基础语法")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                HStack {
                  Text("**粗体文本**")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("粗体文本")
                    .bold()
                }
                
                HStack {
                  Text("*斜体文本*")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("斜体文本")
                    .italic()
                }
                
                HStack {
                  Text("~~删除线文本~~")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("删除线文本")
                    .strikethrough()
                }
              }
              .padding()
              .background(Color.blue.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
        
        ShowcaseItem(title: "高级语法") {
          VStack(spacing: 16) {
            Text("Markdown 高级语法")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                HStack {
                  Text("`代码文本`")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("代码文本")
                    .font(.system(.body, design: .monospaced))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(4)
                }
                
                HStack {
                  Text("[链接文本](https://apple.com)")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("链接文本")
                    .foregroundStyle(.blue)
                    .underline()
                }
                
                HStack {
                  Text("# 标题文本")
                  Spacer()
                  Text("→")
                  Spacer()
                  Text("标题文本")
                    .font(.title)
                }
              }
              .padding()
              .background(Color.purple.opacity(0.1))
              .cornerRadius(10)
            }
            
            Text("组合示例")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.top)
            
            Text("**粗体** 和 *斜体* 的组合，还可以添加 ~~删除线~~ 和 `代码`，以及[链接](https://apple.com)。")
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.green.opacity(0.1))
              .cornerRadius(10)
          }
        }
      }
      
      // MARK: - 交互功能
      ShowcaseSection("交互功能") {
        ShowcaseItem(title: "文本选择") {
          VStack(spacing: 16) {
            Text("文本选择功能")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Text("这是一段可以选择的文本，长按可以复制或分享。")
                .textSelection(.enabled)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
              
              Text("提示：长按上方文本试试")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
        }
        
        ShowcaseItem(title: "点击交互") {
          VStack(spacing: 16) {
            Text("文本点击事件")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Text("点击计数: \(count)")
                .font(.title2)
                .onTapGesture {
                  withAnimation(.spring()) {
                    count += 1
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              
              Text("点击上方文本增加计数")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
        }
        
        ShowcaseItem(title: "状态反馈") {
          VStack(spacing: 16) {
            Text("错误状态展示")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Button {
                withAnimation(.spring()) {
                  showError.toggle()
                }
              } label: {
                Text(showError ? "隐藏错误" : "显示错误")
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(showError ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                  .cornerRadius(10)
              }
              
              if showError {
                VStack(spacing: 8) {
                  Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(.red)
                  
                  Text("错误信息示例")
                    .font(.headline)
                    .foregroundStyle(.white)
                  
                  Text("这是一条错误提示信息")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.gradient)
                .cornerRadius(10)
                .transition(.scale.combined(with: .opacity))
              }
            }
          }
        }
      }
      
      // MARK: - 日期处理
      ShowcaseSection("日期处理") {
        ShowcaseItem(title: "日期选择") {
          VStack(spacing: 16) {
            Text("日期选择器")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            DatePicker(
              "选择日期",
              selection: $selectedDate,
              displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
          }
        }
        
        ShowcaseItem(title: "日期格式化") {
          VStack(spacing: 16) {
            Text("日期格式化样式")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                HStack {
                  Text("日期格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, style: .date)
                    .font(.body)
                }
                
                HStack {
                  Text("时间格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, style: .time)
                    .font(.body)
                }
                
                HStack {
                  Text("相对格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, style: .relative)
                    .font(.body)
                }
                
                HStack {
                  Text("计时格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, style: .timer)
                    .font(.body)
                }
              }
              .padding()
              .background(Color.purple.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
        
        ShowcaseItem(title: "自定义格式") {
          VStack(spacing: 16) {
            Text("自定义日期格式")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                HStack {
                  Text("完整格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, format: .dateTime.day().month().year().hour().minute())
                    .font(.body)
                }
                
                HStack {
                  Text("短格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, format: .dateTime.month(.abbreviated).day())
                    .font(.body)
                }
                
                HStack {
                  Text("自定义格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text(selectedDate, format: Date.FormatStyle()
                    .year(.defaultDigits)
                    .month(.wide)
                    .day(.twoDigits)
                    .locale(Locale(identifier: "zh_CN"))
                  )
                  .font(.body)
                }
              }
              .padding()
              .background(Color.green.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
      }
      
      // MARK: - 文本变换
      ShowcaseSection("文本变换") {
        ShowcaseItem(title: "大小写转换") {
          VStack(spacing: 16) {
            Text("文本大小写")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                HStack {
                  Text("小写转换")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text("HELLO WORLD")
                    .textCase(.lowercase)
                    .font(.body)
                }
                
                HStack {
                  Text("大写转换")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text("hello world")
                    .textCase(.uppercase)
                    .font(.body)
                }
                
                HStack {
                  Text("原始文本")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Spacer()
                  Text("Mixed Case Text")
                    .textCase(nil)
                    .font(.body)
                }
              }
              .padding()
              .background(Color.blue.opacity(0.1))
              .cornerRadius(10)
            }
          }
        }
        
        ShowcaseItem(title: "文本间距") {
          VStack(spacing: 16) {
            Text("间距调整")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("字间距")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("Hello World")
                    .tracking(10)
                    .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("行间距")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是第一行文本\n这是第二行文本\n这是第三行文本")
                    .lineSpacing(10)
                    .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("字距调整")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("AVAWAYA")
                    .kerning(5)
                    .font(.body)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本缩放") {
          VStack(spacing: 16) {
            Text("自适应缩放")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("固定大小")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是固定大小的文本")
                    .font(.system(size: 20))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("自动缩放")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是一段较长的文本，会根据容器宽度自动调整大小")
                    .font(.system(size: 20))
                    .minimumScaleFactor(0.5)
                    .frame(width: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
      }
      
      // MARK: - 特殊效果
      ShowcaseSection("特殊效果") {
        ShowcaseItem(title: "文本阴影") {
          VStack(spacing: 16) {
            Text("阴影效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("基础阴影")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("阴影示例")
                    .font(.title)
                    .shadow(color: .gray, radius: 2, x: 2, y: 2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("彩色阴影")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("炫彩效果")
                    .font(.title)
                    .shadow(color: .blue.opacity(0.5), radius: 4, x: 4, y: 4)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("多重阴影")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("立体文本")
                    .font(.title)
                    .shadow(color: .red.opacity(0.5), radius: 4, x: -4, y: 0)
                    .shadow(color: .blue.opacity(0.5), radius: 4, x: 4, y: 0)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本渐变") {
          VStack(spacing: 16) {
            Text("渐变效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("线性渐变")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("渐变文本")
                    .font(.title)
                    .foregroundStyle(
                      LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                      )
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("角度渐变")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("彩虹文本")
                    .font(.title)
                    .foregroundStyle(
                      AngularGradient(
                        colors: [.red, .yellow, .green, .blue, .purple, .red],
                        center: .center
                      )
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本蒙版") {
          VStack(spacing: 16) {
            Text("蒙版效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("图案填充")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("图案文本")
                    .font(.system(size: 36).bold())
                    .overlay {
                      Image(systemName: "star.fill")
                        .resizable(capInsets: .init(top: 0, leading: 0, bottom: 0, trailing: 0), resizingMode: .tile)
                        .foregroundStyle(.blue)
                        .mask(
                          Text("图案文本")
                            .font(.system(size: 36).bold())
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("渐变蒙版")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("渐隐文本")
                    .font(.system(size: 36).bold())
                    .mask {
                      LinearGradient(
                        colors: [.clear, .black, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                      )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
      }
      
      // MARK: - 动态文本
      ShowcaseSection("动态文本") {
        ShowcaseItem(title: "动态字体") {
          VStack(spacing: 16) {
            Text("动态字体大小")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("标准动态字体")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("根据系统设置自动调整大小")
                    .dynamicTypeSize(.large)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("自定义动态字体")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("使用自定义字体并支持动态大小")
                    .dynamicTypeSize(.large)
                    .font(.custom("Helvetica", size: 20, relativeTo: .headline))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本动画") {
          VStack(spacing: 16) {
            Text("动态文本效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("文本切换动画")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  
                  let texts = ["Hello", "你好", "Bonjour", "Hola"]
                  TimelineView(.animation(minimumInterval: 2)) { timeline in
                    let index = Int(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 4))
                    Text(texts[index])
                      .font(.largeTitle)
                      .frame(maxWidth: .infinity, alignment: .center)
                      .transition(.scale.combined(with: .opacity))
                      .animation(.spring, value: index)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              }
            }
            
            Text("提示：等待文本自动切换")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      
      // MARK: - 文本链接和交互
      ShowcaseSection("文本链接和交互") {
        ShowcaseItem(title: "文本链接") {
          VStack(spacing: 16) {
            Text("链接类型")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("Markdown 链接")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("点击打开[Apple官网](https://www.apple.com)")
                    .tint(.blue)
                    .environment(\.openURL, OpenURLAction { url in
                      print("正在打开链接: \(url)")
                      return .systemAction
                    })
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("自定义链接")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("点击查看更多")
                    .foregroundStyle(.blue)
                    .underline()
                    .onTapGesture {
                      print("点击了链接")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本交互") {
          VStack(spacing: 16) {
            Text("交互功能")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("文本复制")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("长按此文本可以复制或分享")
                    .textSelection(.enabled)
                    .contextMenu {
                      Button {
                        UIPasteboard.general.string = "长按此文本可以复制或分享"
                      } label: {
                        Label("复制", systemImage: "doc.on.doc")
                      }
                      
                      Button {
                        // 分享功能
                      } label: {
                        Label("分享", systemImage: "square.and.arrow.up")
                      }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("手势交互")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("点击或长按此文本")
                    .onTapGesture {
                      print("单击")
                    }
                    .onLongPressGesture {
                      print("长按")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
              }
            }
            
            Text("提示：尝试与上方文本交互")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      
      // MARK: - 高级排版
      ShowcaseSection("高级排版") {
        ShowcaseItem(title: "段落格式") {
          VStack(spacing: 16) {
            Text("段落样式")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("首行缩进")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("    这是一个带有首行缩进的段落。通过在文本开头添加空格来实现缩进效果。这是后面的文字，用来演示多行效果。")
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("文本截断")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是一个很长的文本，演示不同的截断方式。这里添加了更多的内容来确保文本足够长，可以看到截断效果。")
                    .lineLimit(2)
                    .truncationMode(.tail)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "文本位置") {
          VStack(spacing: 16) {
            Text("位置调整")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("基线偏移")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  HStack(spacing: 4) {
                    Text("正常文本")
                    Text("上标")
                      .baselineOffset(10)
                      .font(.footnote)
                      .foregroundStyle(.blue)
                    Text("下标")
                      .baselineOffset(-10)
                      .font(.footnote)
                      .foregroundStyle(.green)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("字距调整")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  VStack(alignment: .leading, spacing: 12) {
                    Text("默认字距")
                      .font(.system(.body, design: .monospaced))
                    Text("紧凑字距")
                      .kerning(-2)
                      .font(.system(.body, design: .monospaced))
                      .foregroundStyle(.blue)
                    Text("宽松字距")
                      .kerning(2)
                      .font(.system(.body, design: .monospaced))
                      .foregroundStyle(.green)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "高级特性") {
          VStack(spacing: 16) {
            Text("特殊效果")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("字符压缩")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是一个较长的文本，启用了字符压缩功能以适应空间")
                    .lineLimit(1)
                    .allowsTightening(true)
                    .frame(width: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("自定义行高")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("这是第一行\n这是第二行\n这是第三行")
                    .lineSpacing(8)
                    .padding(.vertical, 8)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
      }
      
      // MARK: - 性能优化
      ShowcaseSection("性能优化") {
        ShowcaseItem(title: "渲染优化") {
          VStack(spacing: 16) {
            Text("渲染技术")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("离屏渲染")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("使用 drawingGroup() 进行离屏渲染的文本")
                    .drawingGroup()
                    .font(.title3)
                    .foregroundStyle(
                      LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                      )
                    )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("文本缓存")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("使用系统文本缓存机制优化性能")
                    .font(.body)
                    .textSelection(.enabled)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "加载优化") {
          VStack(spacing: 16) {
            Text("延迟加载")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("LazyVStack 示例")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  
                  ScrollView {
                    LazyVStack(spacing: 8) {
                      ForEach(0..<20) { index in
                        HStack {
                          Text("延迟加载项 \(index + 1)")
                            .font(.body)
                          Spacer()
                          Text("#\(index + 1)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                      }
                    }
                  }
                  .frame(height: 200)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              }
            }
            
            Text("提示：滚动查看延迟加载效果")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      
      // MARK: - 本地化支持
      ShowcaseSection("本地化支持") {
        ShowcaseItem(title: "语言本地化") {
          VStack(spacing: 16) {
            Text("多语言支持")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("英语")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("Hello, World!")
                    .environment(\.locale, .init(identifier: "en"))
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("简体中文")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("Hello, World!")
                    .environment(\.locale, .init(identifier: "zh-Hans"))
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("日语")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("Hello, World!")
                    .environment(\.locale, .init(identifier: "ja"))
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "数字格式化") {
          VStack(spacing: 16) {
            Text("数字本地化")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("货币格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  HStack {
                    Text("USD:")
                      .foregroundStyle(.secondary)
                    Text("\(1234.56, format: .currency(code: "USD"))")
                      .font(.title3)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("百分比格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  HStack {
                    Text("比例:")
                      .foregroundStyle(.secondary)
                    Text("\(0.7523, format: .percent)")
                      .font(.title3)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("科学计数")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  HStack {
                    Text("数值:")
                      .foregroundStyle(.secondary)
                    Text("\(1234567, format: .number.notation(.scientific))")
                      .font(.title3)
                  }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
        
        ShowcaseItem(title: "日期格式化") {
          VStack(spacing: 16) {
            Text("日期本地化")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("完整日期")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text(Date(), format: .dateTime.day().month().year())
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("时间格式")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text(Date(), format: .dateTime.hour().minute())
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("相对时间")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text(Date().addingTimeInterval(3600), format: .relative(presentation: .named))
                    .font(.title3)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
              }
            }
          }
        }
      }
      
      // MARK: - 辅助功能
      ShowcaseSection("辅助功能") {
        ShowcaseItem(title: "辅助标签") {
          VStack(spacing: 16) {
            Text("辅助功能支持")
              .font(.headline)
              .frame(maxWidth: .infinity, alignment: .center)
            
            VStack(spacing: 12) {
              Group {
                VStack(alignment: .leading, spacing: 8) {
                  Text("标签和提示")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("带有辅助功能的文本")
                    .font(.title3)
                    .accessibilityLabel("这是辅助标签")
                    .accessibilityHint("这是辅助提示")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 8) {
                  Text("辅助特征")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                  Text("标题文本")
                    .font(.title3)
                    .accessibilityAddTraits(.isHeader)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
              }
            }
            
            Text("提示：使用 VoiceOver 体验辅助功能")
              .font(.caption)
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
    }
    .navigationTitle("Text 示例")
  }
}

// MARK: - 预览
#Preview {
  NavigationView {
    TextDemoView()
  }
}
