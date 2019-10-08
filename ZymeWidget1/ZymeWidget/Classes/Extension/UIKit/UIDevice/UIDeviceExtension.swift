//
//  UIDeviceExtension.swift
//  zyme
//
//  Created by zyme on 2018/1/11.
//  Copyright © 2018年 zyme. All rights reserved.
//

import UIKit

func *(l: CGSize,r: CGFloat)-> CGSize {
    return CGSize(width: r*l.width, height: r*l.height)
}

func /( l : CGSize, r: CGSize) -> CGSize {
    return CGSize(width:l.width/r.width,height:     l.height/r.height)
}

func /( l : CGSize, r:CGFloat) -> CGSize {
    return CGSize(width:l.width/r, height: l.height/r)
}

func*(l: CGSize,r: CGSize)-> CGSize{
    return CGSize(width: l.width*r.width, height:   l.height*r.height)
}

func -( l : CGSize, r: CGSize) -> CGSize {
    return CGSize(width:l.width-r.width,height: l.height - r.height)
}

func -( l : CGPoint, r: CGPoint) -> CGPoint {
    return  CGPoint(x: l.x - r.x, y: l.y - r.y)
}

extension CGSize {
    var point: CGPoint {
        return CGPoint(x: self.width, y: self.height) }
}

extension CGSize: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
    
    public init(unicodeScalarLiteral value: String) {
        let size = NSCoder.cgSize(for: value)
        self.init(width: size.width, height: size.height)
    }
}


public extension UIDevice {
    
    enum iPhones: CGSize, ExpressibleByNilLiteral {
        case iPhone3GS =    "{640, 960}" //320 * 480 @2x
        case iPhone5 =      "{640, 1136}" //320 * 568 @2x
        case iPhone6 =      "{750, 1334}" //375 * 667 @2x
        case iPhone6Plus =  "{1242, 2208}" //414 * 736 @3x
        case iPhoneX_S =    "{1125, 2436}" //375 * 812 @3x
        case iPhoneXSMax =  "{1242, 2688}" //414 * 896 @2x
        case iPhoneXR =     "{828, 1792}" //414 * 896 @3x
        case unKnown
        public init(nilLiteral: Void) {
            self = .unKnown
        }
        var scale: CGFloat {
            return UIScreen.mainScale
        }
        
        var inch: CGFloat {
            switch self {
            case .iPhone3GS: return 3.5
            case .iPhone5 : return 4
            case .iPhone6 : return 4.7
            case .iPhone6Plus: return 5.5
            case .iPhoneX_S: return 5.8
            case .iPhoneXSMax: return 6.1
            case .iPhoneXR : return 6.5
            default:
                return -1
            }
        }
        
        var size: CGSize{
            return self.rawValue / 2
        }
        
        var isScreenElongation: Bool {
            switch self {
            case .iPhoneX_S,.iPhoneXSMax, .iPhoneXR: return true
            default:
                return false
            }
        }
    }
    
    struct ScreenSize {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    static var iPhoneType: iPhones {
        let scale =  UIScreen.mainScale
        let deviceSize = CGSize(width: ScreenSize.SCREEN_MIN_LENGTH, height: ScreenSize.SCREEN_MAX_LENGTH) * scale
        
        guard let type = iPhones.init(rawValue: deviceSize) else {
            return .unKnown
        }
        return type
    }
    
    static var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isScreenElongation: Bool {
        return iPhoneType.isScreenElongation
    }
    
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        //https://www.theiphonewiki.com/wiki/Models
        switch identifier {
        case "iPod1,1":                                return "iPod Touch 1"
        case "iPod2,1":                                return "iPod Touch 2"
        case "iPod3,1":                                return "iPod Touch 3"
        case "iPod4,1":                                return "iPod Touch 4"
        case "iPod5,1":                                return "iPod Touch (5 Gen)"
        case "iPod7,1":                                return "iPod Touch 6"
        
        // iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":    return "iPhone 4"
        case "iPhone4,1":                              return "iPhone 4s"
        case "iPhone5,1":                              return "iPhone 5"
        case "iPhone5,2":                              return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":                              return "iPhone 5c (GSM)"
        case "iPhone5,4":                              return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":                              return "iPhone 5s (GSM)"
        case "iPhone6,2":                              return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":                              return "iPhone 6"
        case "iPhone7,1":                              return "iPhone 6 Plus"
        case "iPhone8,1":                              return "iPhone 6s"
        case "iPhone8,2":                              return "iPhone 6s Plus"
        case "iPhone8,4":                              return "iPhone SE"
        case "iPhone9,1":                              return "国行、日版、港行iPhone 7"
        case "iPhone9,2":                              return "港行、国行iPhone 7 Plus"
        case "iPhone9,3":                              return "美版、台版iPhone 7"
        case "iPhone9,4":                              return "美版、台版iPhone 7 Plus"
        case "iPhone10,1","iPhone10,4":                return "iPhone 8"
        case "iPhone10,2","iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3","iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                             return "iPhone XS"
        case "iPhone11,4":                             return "iPhone XS Max"
        case "iPhone11,6":                             return "iPhone XS Max"
        case "iPhone11,8":                             return "iPhone XR"

        // iPad
        case "iPad1,1":                                           return "iPad"
        case "iPad1,2":                                           return "iPad 3G"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":          return "iPad 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":                     return "iPad Mini"
        case "iPad3,1", "iPad3,2", "iPad3,3":                     return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":                     return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":                     return "iPad Air"
        case "iPad4,4", "iPad4,5", "iPad4,6":                     return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":                     return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                                return "iPad Mini 4"
        case "iPad5,3", "iPad5,4":                                return "iPad Air 2"
        case "iPad6,3", "iPad6,4":                                return "iPad Pro 9.7"
        case "iPad6,7", "iPad6,8":                                return "iPad Pro 12.9"
        case "iPad6,11":                                          return "iPad 2017"
        case "iPad6,12":                                          return "iPad 2017"
        case "iPad7,1":                                           return "iPad Pro 12.9-inch 2nd"
        case "iPad7,2":                                           return "iPad Pro 12.9-inch 2nd"
        case "iPad7,3":                                           return "iPad Pro 10.5-inch"
        case "iPad7,4":                                           return "iPad Pro 10.5-inch"
        case "iPad7,5":                                           return "iPad 2018"
        case "iPad7,6":                                           return "iPad 2018"
        case "iPad8,1":                                           return "iPad Pro 11-inch"
        case "iPad8,2":                                           return "iPad Pro 11-inch"
        case "iPad8,3":                                           return "iPad Pro 11-inch"
        case "iPad8,4":                                           return "iPad Pro 11-inch"
        case "iPad8,5":                                           return "iPad Pro 12.9-inch 3rd"
        case "iPad8,6":                                           return "iPad Pro 12.9-inch 3rd"
        case "iPad8,7":                                           return "iPad Pro 12.9-inch 3rd"
        case "iPad8,8":                                           return "iPad Pro 12.9-inch 3rd"
            
        
        // Apple Watch
        case "Watch1,1" : return "Apple Watch"
        case "Watch1,2" : return "Apple Watch"
        case "Watch2,6" : return "Apple Watch Series 1"
        case "Watch2,7" : return "Apple Watch Series 1"
        case "Watch2,3" : return "Apple Watch Series 2"
        case "Watch2,4" : return "Apple Watch Series 2"
        case "Watch3,1" : return "Apple Watch Series 3"
        case "Watch3,2" : return "Apple Watch Series 3"
        case "Watch3,3" : return "Apple Watch Series 3"
        case "Watch3,4" : return "Apple Watch Series 3"
        case "Watch4,1" : return "Apple Watch Series 4"
        case "Watch4,2" : return "Apple Watch Series 4"
        case "Watch4,3" : return "Apple Watch Series 4"
        case "Watch4,4" : return "Apple Watch Series 4"
            
            
        case "AppleTV2,1":                                        return "Apple TV 2"
        case "AppleTV3,1","AppleTV3,2":                           return "Apple TV 3"
        case "AppleTV5,3":                                        return "Apple TV 4"
        case "AppleTV6,2":                                        return "Apple TV 4K"
            
        case "i386", "x86_64":                                    return "Simulator"
        default:  return identifier
        }
    }
}

extension ZymeNamespaceWrapper where T: UIDevice {
    
    ///cpu频率 int: CPU Frequency
    public static var cpuFrequency: Int {
        var result: Int = 0
        getSysInfo(HW_CPU_FREQ, result: &result)
        return result
    }
    
    //总线频率 int Bus Frequency
    public static var busFrequency: Int {
        var result: Int = 0
        getSysInfo(HW_BUS_FREQ, result: &result)
        return result
    }
    /////current device RAM size; uint64_t: physical ram size
    public static var ramSize: UInt64{
        var result: UInt64 = 0
        getSysInfo(HW_MEMSIZE, result: &result)
        return result
    }
    
    ///Return the current device CPU number; int: number of cpus
    public static var cpuNumber: Int {
        var result: Int = 0
        getSysInfo(HW_NCPU, result: &result)
        return result
    }
    
    ///获取手机内存总量, 返回的是字节数; int: total memory
    public static var totalMemoryBytes: Int {
        var result: Int = 0
        getSysInfo(HW_PHYSMEM, result: &result)
        return result
    }
    ///获取手机可用内存, 返回的是字节数
    public static var freeMemoryBytes: UInt {
        return readFreeMemoryBytes()
    }
    /// 获取iOS系统的版本号
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    /// 获取手机硬盘空闲空间, 返回的是字节数
    public static var freeDiskSpaceBytes: UInt64 {
        func diskSpace()->UInt64{
            var buf: statfs = statfs()
            var freespace: UInt64 = 0
            if statfs("/private/var", &buf) >= 0{
                freespace = UInt64(buf.f_bsize) * buf.f_bfree
            }
            return freespace
        }
        
        return diskSpace()
    }
    
    ///获取手机硬盘总空间, 返回的是字节数
    public static var totalDiskSpaceBytes: UInt64 {
        func diskSpace()->UInt64{
            var buf: statfs = statfs()
            var totalspace: UInt64 = 0
            if statfs("/private/var", &buf) >= 0{
                totalspace = UInt64(buf.f_bsize) * buf.f_blocks
            }
            return totalspace
        }
        return diskSpace()
    }
    
    public static func readMacAddress()->String{
        
        let index = Int32(if_nametoindex("en0"))
        guard index != 0 else {
            DLog("Error: if_nametoindex error\n");
            return "00:00:00:00:00:00"
        }
        
        var mib: [Int32] = [Int32].init(repeating: 0, count: 6)
        var len: Int = 0
        let bsdData = "en0".data(using: .utf8)
        
        mib[0] = CTL_NET
        mib[1] = AF_ROUTE
        mib[2] = 0
        mib[3] = AF_LINK
        mib[4] = NET_RT_IFLIST
        mib[5] = index
        
        guard sysctl(&mib, UInt32(mib.count), nil, &len, nil, 0) >= 0 else {
            print("Error: could not determine length of info data structure ")
            return "00:00:00:00:00:00"
        }
        
        var buffer = [CChar].init(repeating: 0, count: len)
        guard sysctl(&mib, 6, &buffer, &len, nil, 0) >= 0 else {
            DLog("Error: could not read info data structure")
            return "00:00:00:00:00:00"
        }
        
        let infoData = NSData(bytes: buffer, length: len)
        var interfaceMsgStruct = if_msghdr()
        infoData.getBytes(&interfaceMsgStruct, length: MemoryLayout<if_msghdr>.size)
        let socketStructStart = MemoryLayout<if_msghdr>.size + 1
        let socketStructData = infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart)) as NSData
        let rangeOfToken = socketStructData.range(of: bsdData!, options: NSData.SearchOptions(rawValue: 0), in: NSMakeRange(0, socketStructData.length))
        let macAddressData = socketStructData.subdata(with: NSMakeRange(rangeOfToken.location + 3, 6)) as NSData
        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
        macAddressData.getBytes(&macAddressDataBytes, length: 6)
        
        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joined(separator: ":")
    }
    
    //MARK: - 获取IP
    static public func GetIPAddresses() -> String? {
        var addresses = [String]()
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            // For each interface ...
            while (ptr != nil) {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String(validatingUTF8:hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addresses.first
    }
    
    private static func getSysInfo<T>(_ typeSpecifier: Int32, result: inout T){
        var size: size_t = MemoryLayout<Int>.size
        var mib: [Int32] = [CTL_HW, typeSpecifier]
        sysctl(&mib, 2, &result, &size, nil, 0)
    }
    
    private static func readFreeMemoryBytes()->UInt {
        var page_size: vm_size_t = 0
        let mach_port: mach_port_t = mach_host_self()
        var count: mach_msg_type_number_t =  mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size / MemoryLayout<integer_t>.size)
        var info: integer_t = 0
        host_page_size(mach_port, &page_size)
        
        if host_statistics(mach_port, HOST_VM_INFO, &info, &count) != KERN_SUCCESS {
            return 0
        }
        func pointer(p: host_info_t)-> vm_statistics_data_t{
            return p.withMemoryRebound(to: vm_statistics_data_t.self, capacity: 1, {$0}).pointee
        }
        let vm_stat = pointer(p: &info)
        
        let mem_free = UInt(vm_stat.free_count) * UInt(page_size);
        return mem_free
    }
}
