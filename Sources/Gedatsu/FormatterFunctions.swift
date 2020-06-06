import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

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
            let (lAttribute, rAttribute) = (constraint.firstAttribute, constraint.secondAttribute)
            let relation = constraint.relation
            return buildHeaderContent(
                displayables: [lAttribute, rAttribute, relation],
                defaultContent: "NSLayoutConstraint: \(address) \(itemType(of: lhs)).\(lAttribute.displayName) \(relation.displayName) \(itemType(of: rhs)).\(rAttribute.displayName) \(constraint.displayIdentifier)"
            )
        case (.some(let item), .none):
            return buildHeaderContent(displayables: [constraint.firstAttribute, constraint.relation], defaultContent: "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.firstAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)")
        case (.none, .some(let item)):
            return buildHeaderContent(displayables: [constraint.secondAttribute, constraint.relation], defaultContent: "NSLayoutConstraint: \(address) \(itemType(of: item)).\(constraint.secondAttribute.displayName) \(constraint.relation.displayName) \(constraint.constant) \(constraint.displayIdentifier)")
        }
    }.joined(separator: "\n")
}

private func buildHeaderContent(displayables: [HasDisplayName], defaultContent content: String) -> String {
    let errorMessage = """
Gedatsu catch unknown attribute or relation pattern. See issues for a solution to this problem. If that doesn't work, please create a new issue."
https://github.com/bannzai/gedatsu/issues
"""
    switch displayables.allSatisfy(\.isValid) {
    case true:
        return content
    case false:
        return """
        \(errorMessage)
        \(content)
        """
    }
}
