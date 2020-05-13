import Foundation

#if os(iOS)
import UIKit
public typealias WindowType = UIWindow
public typealias ViewType = UIView
public typealias ResponderType = UIResponder
public typealias LayoutGuideType = UILayoutGuide
internal extension ViewType {
    var _accessibilityIdentifier: String? {
        accessibilityIdentifier
    }
}
#elseif os(macOS)
import AppKit
public typealias WindowType = NSWindow
public typealias ViewType = NSView
public typealias ResponderType = NSResponder
public typealias LayoutGuideType = NSLayoutGuide
internal extension ResponderType {
    var next: ResponderType? {
        nextResponder
    }
}
internal extension ViewType {
    var _accessibilityIdentifier: String? {
        accessibilityIdentifier()
    }
}
#endif
