#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

internal extension NSLayoutConstraint {
    var displayIdentifier: String {
        guard let identifier = identifier else {
            return ""
        }
        return "[\(identifier)]"
    }
}

internal protocol HasDisplayName {
    var isValid: Bool { get }
    var displayName: String { get }
}

extension NSLayoutConstraint.Attribute: HasDisplayName {
    var isValid: Bool {
        switch self {
        case .left, .right, .top, .bottom, .leading, .trailing, .width, .height, .centerX, .centerY, .lastBaseline, .firstBaseline, .notAnAttribute:
            return true
            #if os(iOS)
        case .leftMargin, .rightMargin, .topMargin, .bottomMargin, .leadingMargin, .trailingMargin, .centerXWithinMargins, .centerYWithinMargins:
            return true
            #endif
        @unknown default:
            return false
        }
    }
    var displayName: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .leading:
            return "leading"
        case .trailing:
            return "trailing"
        case .width:
            return "width"
        case .height:
            return "height"
        case .centerX:
            return "centerX"
        case .centerY:
            return "centerY"
        case .lastBaseline:
            return "lastBaseline"
        case .firstBaseline:
            return "firstBaseline"
            #if os(iOS)
        case .leftMargin:
            return "leftMargin"
        case .rightMargin:
            return "rightMargin"
        case .topMargin:
            return "topMargin"
        case .bottomMargin:
            return "bottomMargin"
        case .leadingMargin:
            return "leadingMargin"
        case .trailingMargin:
            return "trailingMargin"
        case .centerXWithinMargins:
            return "centerXWithinMargins"
        case .centerYWithinMargins:
            return "centerYWithinMargins"
            #endif
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            return "⚠️️️️⚠️️️️⚠️️️️ Unknown Attribute case for rawValue == \(rawValue) ⚠️️️️⚠️️️️⚠️️️️ "
        }
    }
}
extension NSLayoutConstraint.Relation: HasDisplayName {
    var isValid: Bool {
        switch self {
        case .equal:
            return true
        case .greaterThanOrEqual:
            return true
        case .lessThanOrEqual:
            return true
        @unknown default:
            return false
        }
    }
    var displayName: String {
        switch self {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        @unknown default:
            return "⚠️️️️⚠️️️️⚠️️️️ Unknown Relation case for rawValue == \(rawValue) ⚠️️️️⚠️️️️⚠️️️️ "
        }
    }
}
