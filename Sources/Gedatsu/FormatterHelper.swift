import UIKit

private func space(level: Int) -> String {
    var indent = ""
    stride(from: 0, through: level, by: 1).forEach { i in
        indent += " "
    }
    return indent
}

private func debugContent(node: Node) -> String {
    let address = unsafeBitCast(node.responder, to: Int.self)
    if let identifier = (node.responder as? UIView)?.accessibilityIdentifier {
        return "\(identifier):\(address)"
    }
    if let label = node.responder.accessibilityLabel {
        return "\(label): \(address)"
    }
    switch node.hasAmbigious {
    case true:
        let attributes = node.attributes.map { "\($0.displayName)" }.joined(separator: ", ")
        return "❌ \(type(of: node.responder)): \(String(address, radix: 16, uppercase: false)), ambigious attributes: \(attributes)"
    case false:
        return "\(type(of: node.responder)): \(String(address, radix: 16, uppercase: false))"
    }
}

public func buildTreeContent(tree: [Node]) -> String {
    var content = ""
    tree.enumerated().forEach { (offset, node) in
        if offset == 0 {
            content += "- " + debugContent(node: node) + "\n"
            return
        }
        node.children.forEach { child in
            content += space(level: offset) + "|- " + debugContent(node: child) + "\n"
        }
    }
    return content
}


extension NSLayoutConstraint.Attribute {
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
        case .notAnAttribute:
            return "notAnAttribute"
        @unknown default:
            fatalError()
        }
    }
}
