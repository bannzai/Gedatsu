import Foundation
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public class Node {
    public weak var parent: Node?
    public var responder: ResponderType
    public var children: [Node] = []
    public var attributes: Set<NSLayoutConstraint.Attribute> = []
    
    init(responder: ResponderType) {
        self.responder = responder
    }
    init?(anyObject: AnyObject?, attribute: NSLayoutConstraint.Attribute) {
        guard let view = anyObject as? View, let responder = view.view() else {
            return nil
        }
        self.responder = responder
        self.attributes = [attribute]
    }
    
    var hasAmbiguous: Bool {
        !attributes.isEmpty
    }
    
    fileprivate func addChild(_ node: Node) {
        let hasChild = children.contains { $0.responder === node.responder }
        if hasChild {
            return
        }
        children.append(node)
    }
    fileprivate func inherit(from node: Node) {
        node.attributes.forEach {
            attributes.insert($0)
        }
    }
}

public class Context {
    public var tree: [Node] = []
    internal var latestNode: Node?
    
    public let view: ViewType
    public let constraint: NSLayoutConstraint
    public let exclusiveConstraints: [NSLayoutConstraint]
    public init(view: ViewType, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) {
        self.view = view
        self.constraint = constraint
        self.exclusiveConstraints = exclusiveConstraints
    }
    
    private func ancestors(from node: Node, to latestNode: Node?) -> [Node] {
        var current: Node? = node
        var ancestors: [Node] = []
        while let next = current?.responder.next {
            if next === latestNode?.responder {
                return ancestors
            }
            let parent = Node(responder: next)
            ancestors.append(parent)
            
            current?.parent = parent
            current.map(parent.addChild)
            current = parent
        }
        return ancestors.reversed()
    }
    
    internal func buildTree() {
        let ambiguousConstraintNodes = exclusiveConstraints
            .flatMap { [Node(anyObject: $0.firstItem, attribute: $0.firstAttribute), Node(anyObject: $0.secondItem, attribute: $0.secondAttribute)] }
            .compactMap { $0 }
        
        var mergedNodes: [Node] = []
        mergeNode: for node in ambiguousConstraintNodes {
            switch mergedNodes.last(where: { $0.responder === node.responder }) {
            case nil:
                mergedNodes.append(node)
            case let mergedNode?:
                mergedNode.inherit(from: node)
            }
        }
        
        var nodes: [Node] = []
        configureAncestors: for node in mergedNodes {
            if let sameNode = nodes.first(where: { $0.responder === node.responder }) {
                sameNode.inherit(from: node)
                continue
            }
            if let ancestor = nodes.first(where: { $0.responder === node.responder.next }) {
                ancestor.addChild(node)
                continue
            }
            nodes = ancestors(from: node, to: self.latestNode) + [node]
            latestNode = node
        }
        
        tree = nodes
    }
}
