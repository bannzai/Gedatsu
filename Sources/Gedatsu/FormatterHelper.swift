import UIKit

func space(level: Int) -> String {
    var indent = ""
    stride(from: 0, through: level, by: 1).forEach { i in
        indent += " "
    }
    return indent
}
func debugContent(node: Node) -> String {
    if let identifier = (node.responder as? UIView)?.accessibilityIdentifier {
        return "\(identifier):\(addres(of: node.responder))"
    }
    if let label = node.responder.accessibilityLabel {
        return "\(label): \(addres(of: node.responder))"
    }
    switch node.hasAmbiguous {
    case true:
        let attributes = node.attributes.map { "\($0.displayName)" }.joined(separator: ", ")
        return "❌ \(type(of: node.responder)): \(addres(of: node.responder)), ambiguous attributes: \(attributes)"
    case false:
        return "\(type(of: node.responder)): \(addres(of: node.responder))"
    }
}
func itemType(of item: AnyObject) -> String {
    if let guide = item as? UILayoutGuide, let view = guide.view() {
        return "\(type(of: guide)).\(type(of: view))"
    }
    return "\(type(of: item))"
}
func addres(of object: AnyObject) -> String {
    String(unsafeBitCast(object, to: Int.self), radix: 16, uppercase: false)
}
