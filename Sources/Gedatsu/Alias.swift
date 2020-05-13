import Foundation

#if os(iOS)
import UIKit
public typealias WindowType = UIWindow
public typealias ViewType = ViewType
public typealias ResponderType = UIResponder
#elseif os(macOS)
import AppKit
public typealias WindowType = NSWindow
public typealias ViewType = NSView
public typealias ResponderType = NSResponder
#endif
