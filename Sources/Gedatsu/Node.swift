import Foundation
import UIKit

class Node {
    weak var parent: Node?
    var responder: UIResponder
    var children: [Node] = []
    var ambigiouses: [NSLayoutConstraint] = []
    
    init(responder: UIResponder) {
        self.responder = responder
    }
    init?(anyObject: AnyObject?, constraint: NSLayoutConstraint) {
        guard let layout = anyObject as? Layoutable, let responder = layout.view() else {
            return nil
        }
        self.responder = responder
        self.ambigiouses = [constraint]
    }
    
    func addChild(_ node: Node) {
        let hasChild = children.contains { $0.responder === node.responder }
        assert(!hasChild)
        if hasChild {
            return
        }
        children.append(node)
    }
}

class Context {
    var graph: [Node] = []
    var latestNode: Node?
    
    func ancestors(from node: Node, to latestNode: Node?) -> [Node] {
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
            .flatMap { [Node.init(anyObject: $0.firstItem, constraint: $0), Node.init(anyObject: $0.secondItem, constraint: $0)] }
            .compactMap { $0 }
        
        var mergedNodes: [Node] = []
        mergeNode: for node in ambigiousConstraintNodes {
            switch mergedNodes.last(where: { $0.responder === node.responder }) {
            case nil:
                mergedNodes.append(node)
            case let mergedNode?:
                mergedNode.ambigiouses.append(contentsOf: node.ambigiouses)
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
        
        graph = ancestors
    }
}

