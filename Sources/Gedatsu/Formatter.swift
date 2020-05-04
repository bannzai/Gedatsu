import Foundation
import UIKit

public protocol Formatter {
    func format(context: Context) -> String
}

public struct HierarcyFormatter<TopLevel: UIResponder>: Formatter {
    public init() {
        
    }
    public func format(context: Context) -> String {
        if let match = context.tree.enumerated().filter({ $0.1.responder is TopLevel }).last {
            let nodes = context.tree[match.offset..<context.tree.count]
            return buildTreeContent(tree: Array(nodes))
        }
        return "Could not find \(TopLevel.self) in context: \(context.tree)\n" + buildTreeContent(tree: context.tree)
    }
}

public var defaultFormatter: Formatter = HierarcyFormatter<UIWindow>()

internal func format(context: Context) -> String {
    return defaultFormatter.format(context: context)
}
