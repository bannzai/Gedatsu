import Foundation

public func buildTreeContent(context: Context) -> String {
    var content = ""
    context.tree.enumerated().forEach { (offset, node) in
        if offset == 0 {
            content += "- " + debugContent(node: node) + "\n"
        }
        node.children.forEach { child in
            content += space(level: offset) + "|- " + debugContent(node: child) + "\n"
        }
    }
    return content
}
public func buildHeader(context: Context) -> String {
    return context.exclusiveConstraints.compactMap { constraint in
        let address = addres(of: constraint)
        switch (constraint.firstItem, constraint.secondItem) {
        case (.none, .none):
            return "NSLayoutConstraint: \(address) Unknown case. \(constraint.displayIdentifier)"
        case (.some(let lhs), .some(let rhs)):
            let (lAttribute, rAttribute) = (constraint.firstAttribute.displayName, constraint.secondAttribute.displayName)
            let relation = constraint.relation
            return "NSLayoutConstraint: \(address) \(itemType(of: lhs)).\(lAttribute) \(relation.displayName) \(itemType(of: rhs)).\(rAttribute) \(constraint.displayIdentifier)"
        case (.some(let item), .none):
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.firstAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
        case (.none, .some(let item)):
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.secondAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
        }
    }.joined(separator: "\n")
}
