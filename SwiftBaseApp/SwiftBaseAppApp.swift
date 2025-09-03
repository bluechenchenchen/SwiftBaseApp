import SwiftUI
// import Inject // 确保引入Inject模块
//import UIKit

@main
struct iPhoneBaseAppApp: App {
  // @ObserveInjection var forceUpdate // 强制刷新视图状态
  
//  init() {
//#if DEBUG
//    print("---> InjectionIII 初始化")
//    
//    // 真机设备设置开发机IP
//#if !targetEnvironment(simulator)
//    if let localIP = getLocalIPAddress() {
//      UserDefaults.standard.set(localIP, forKey: "INJECTION_ADDRESS")
//    }
//#endif
//    
//    // 加载注入
//#if os(macOS)
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/macOSInjection.bundle")?.load()
//#elseif os(iOS)
//    Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
//#endif
//#endif
//  }
  
  var body: some Scene {
    
    WindowGroup {
      HomeContentView()
//        .enableInjection() // App根视图标记
    }
  }
  
//#if DEBUG
//  // 获取本机IP地址
//  func getLocalIPAddress() -> String? {
//    var address: String?
//    var ifaddr: UnsafeMutablePointer<ifaddrs>?
//    
//    guard getifaddrs(&ifaddr) == 0 else { return nil }
//    guard let firstAddr = ifaddr else { return nil }
//    
//    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//      let interface = ifptr.pointee
//      let addrFamily = interface.ifa_addr.pointee.sa_family
//      if addrFamily == UInt8(AF_INET) {
//        let name = String(cString: interface.ifa_name)
//        if name == "en0" {
//          var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//          getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                      &hostname, socklen_t(hostname.count),
//                      nil, socklen_t(0), NI_NUMERICHOST)
//          address = String(cString: hostname)
//        }
//      }
//    }
//    freeifaddrs(ifaddr)
//    return address
//  }
//#endif
}
