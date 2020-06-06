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
    var shouldShowErrorMessage = false
    let validate: ([HasDisplayName]) -> Bool = { !$0.allSatisfy(\.isValid) }
    let content = context.exclusiveConstraints.compactMap { constraint in
        let address = addres(of: constraint)
        switch (constraint.firstItem, constraint.secondItem) {
        case (.none, .none):
            return "NSLayoutConstraint: \(address) Unknown case. \(constraint.displayIdentifier)"
        case (.some(let lhs), .some(let rhs)):
            let (lAttribute, rAttribute) = (constraint.firstAttribute, constraint.secondAttribute)
            let relation = constraint.relation
            shouldShowErrorMessage = shouldShowErrorMessage || validate([lAttribute, rAttribute, relation])
            return "NSLayoutConstraint: \(address) \(itemType(of: lhs)).\(lAttribute.displayName) \(relation.displayName) \(itemType(of: rhs)).\(rAttribute.displayName) \(constraint.displayIdentifier)"
        case (.some(let item), .none):
            shouldShowErrorMessage = shouldShowErrorMessage || validate([constraint.firstAttribute, constraint.relation])
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.firstAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
        case (.none, .some(let item)):
            shouldShowErrorMessage = shouldShowErrorMessage || validate([constraint.secondAttribute, constraint.relation])
            return "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.secondAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)"
        }
    }.joined(separator: "\n")
    if shouldShowErrorMessage {
        return """
        Gedatsu catch unknown attribute or relation pattern. See issues for a solution to this problem. If that doesn't solve, please create a new issue."
        https://github.com/bannzai/gedatsu/issues
        \(content)
        """
    }
    return content
}
