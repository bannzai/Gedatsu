import Foundation

func space(level: Int) -> String {
    var indent = ""
    stride(from: 0, through: level, by: 1).forEach { i in
        indent += " "
    }
    return indent
}
func responderIdentifier(node: Node) -> String {
    if let identifier = (node.responder as? ViewType)?._accessibilityIdentifier, !identifier.isEmpty {
        return "\(identifier)"
    }
    #if os(iOS)
    // FIXME: How to access NSAccessibility.accessibilityLabel then macOS
    if let label = node.responder.accessibilityLabel, !label.isEmpty {
        return "\(label)"
    }
    #endif
    return "\(type(of: node.responder))"
}
func debugContent(node: Node) -> String {
    switch node.hasAmbiguous {
    case true:
        let attributes = node.attributes.map { "\($0.displayName)" }.joined(separator: ", ")
        return "❌ \(responderIdentifier(node: node)): \(addres(of: node.responder)), ambiguous attributes: \(attributes)"
    case false:
        return "\(responderIdentifier(node: node)): \(addres(of: node.responder))"
    }
}
func itemType(of item: AnyObject) -> String {
    if let guide = item as? LayoutGuideType, let view = guide.view() {
        return "\(type(of: guide)).\(type(of: view))"
    }
    return "\(type(of: item))"
}
func addres(of object: AnyObject) -> String {
    String(unsafeBitCast(object, to: Int.self), radix: 16, uppercase: false)
}
