import Foundation
import UIKit

public typealias FormatterArgument = (view: UIView, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint])
public protocol Formatter {
    func format(for argument: FormatterArgument) -> String
}

public struct HierarcyFormatter<TopLevel: UIResponder>: Formatter {
    public func format(for argument: FormatterArgument) -> String {
        let className = type(of: argument.view)
        let _ = argument.exclusiveConstraints.compactMap { constraint -> [(child: AnyObject, constraint: NSLayoutConstraint)] in
            switch (constraint.firstItem, constraint.secondItem) {
            case (let first?, nil):
                return [(child: first, constraint: constraint)]
            case (let first?, let second?):
                if first === argument.view {
                    return [(child: second, constraint: constraint)]
                }
                if second === argument.view {
                    return [(child: first, constraint: constraint)]
                }
                return [(child: first, constraint: constraint), (child: second, constraint: constraint)]
            case (nil, nil):
                fatalError("Unexpected pattern for firstItem and secondItem are nil")
            case (nil, _):
                fatalError("Unexpected pattern for only exists secondItem")
            }
        }
        return """
        \(className)
"""
    }
    
    internal struct Argument {
        let view: UIView
        let ambiguousConstraints: [NSLayoutConstraint]
    }
}

private func collectResponder(from responder: UIResponder, to target: UIResponder, responders: inout [UIResponder]) {
    func collect(from responder: UIResponder, responders: inout [UIResponder]) {
        guard let next = responder.next else {
            responders.append(responder)
            return
        }
        if next === target {
            responders.append(target)
            return
        }
        responders.append(responder)
        collect(from: responder, responders: &responders)
    }
    
    collect(from: responder, responders: &responders)
    responders = responders.reversed()
}

private func space(level: Int) -> String {
    var indent = ""
    stride(from: 0, through: level, by: 1).forEach { i in
        indent += " "
    }
    return indent
}
private func debugContent(responder: UIResponder) -> String {
    let address = unsafeBitCast(responder, to: Int.self)
    if let identifier = (responder as? UIView)?.accessibilityIdentifier {
        return "\(identifier):\(address)"
    }
    if let label = responder.accessibilityLabel {
        return "\(label): \(address)"
    }
    return "\(type(of: responder)): \(address)"
}
private func buildTreeContent(tree: [Node]) -> String {
    var content = ""
    tree.enumerated().forEach { (offset, node) in
        if offset == 0 {
            content += "- " + debugContent(responder: node.responder) + "\n"
            return
        }
        node.children.forEach { child in
            content += space(level: offset) + "|-" + debugContent(responder: child.responder) + "\n"
        }
    }
    return content
}

internal func format(context: Context) -> String {
    return buildTreeContent(tree: context.tree)
}

public func _print(constraint: NSLayoutConstraint) {
    return
    assert(constraint.firstItem != nil)
    print("  ", "constraint: ", constraint)
    print("  ", "constant: ", constraint.constant)
    print("  ", "firstItem: ", String(describing: constraint.firstItem))
    print("  ", "firstItem.frame: ", String(describing: (constraint.firstItem as? UIView)?.frame))
    print("  ", "firstAttribute: ", constraint.firstAttribute.rawValue)
    print("  ", "secondItem: ", String(describing: constraint.secondItem))
    print("  ", "secondItem.frame: ", String(describing: (constraint.secondItem as? UIView)?.frame))
    print("  ", "secondAttribute: ", constraint.secondAttribute.rawValue)
}
