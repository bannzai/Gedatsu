import Foundation
import UIKit

class Node {
    weak var parent: Node?
    var responder: UIResponder
    var children: [Node] = []
    var attributes: [NSLayoutConstraint.Attribute] = []
    
    init(responder: UIResponder) {
        self.responder = responder
    }
    init?(anyObject: AnyObject?, attribute: NSLayoutConstraint.Attribute) {
        guard let view = anyObject as? View, let responder = view.view() else {
            return nil
        }
        self.responder = responder
        self.attributes = [attribute]
    }
    
    fileprivate func addChild(_ node: Node) {
        let hasChild = children.contains { $0.responder === node.responder }
        assert(!hasChild)
        if hasChild {
            return
        }
        children.append(node)
    }
    fileprivate func inherit(from node: Node) {
        attributes.append(contentsOf: node.attributes)
    }
}

class Context {
    var tree: [Node] = []
    var latestNode: Node?
    
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
    func buildTree(constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) {
        let ambigiousConstraintNodes = exclusiveConstraints
            .flatMap { [Node.init(anyObject: $0.firstItem, attribute: $0.firstAttribute), Node.init(anyObject: $0.secondItem, attribute: $0.secondAttribute)] }
            .compactMap { $0 }
        
        var mergedNodes: [Node] = []
        mergeNode: for node in ambigiousConstraintNodes {
            switch mergedNodes.last(where: { $0.responder === node.responder }) {
            case nil:
                mergedNodes.append(node)
            case let mergedNode?:
                mergedNode.inherit(from: node)
            }
        }
        
        var ancestors: [Node] = []
        configureAncestors: for node in mergedNodes {
            if let ancestor = ancestors.first(where: { $0.responder === node.responder.next }) {
                ancestor.addChild(node)
                continue
            }
            ancestors = self.ancestors(from: node, to: nil)
            latestNode = node
        }
        
        tree = ancestors
    }
}
