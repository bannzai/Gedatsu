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

public func buildTreeContent(context: Context) -> String {
    var content = ""
    context.tree.enumerated().forEach { (offset, node) in
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

private func itemType(of item: AnyObject) -> String {
    if let guide = item as? UILayoutGuide, let view = guide.view() {
        return "\(type(of: guide)).\(type(of: view))"
    }
    return "\(type(of: item))"
}
public func buildHeader(context: Context) -> String {
    return context.exclusiveConstraints.compactMap { constraint in
        let address = String(unsafeBitCast(constraint, to: Int.self), radix: 16, uppercase: false)
        switch (constraint.firstItem, constraint.secondItem) {
        case (.none, .none):
            return "NSLayoutConstraint: \(address) Unknown case"
        case (.some(let lhs), .some(let rhs)):
            let (lAttribute, rAttribute) = (constraint.firstAttribute.displayName, constraint.secondAttribute.displayName)
            let relation = constraint.relation
            return "NSLayoutConstraint: \(address) \(itemType(of: lhs)).\(lAttribute) \(relation.displayName) \(itemType(of: rhs)).\(rAttribute) "
        case (.some(let item), .none):
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.firstAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant)"
        case (.none, .some(let item)):
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.secondAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant)"
        }
    }.joined(separator: "\n")
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
extension NSLayoutConstraint.Relation {
    var displayName: String {
        switch self {
        case .equal:
            return "=="
        case .greaterThanOrEqual:
            return ">="
        case .lessThanOrEqual:
            return "<="
        @unknown default:
            fatalError()
        }
    }
}
