import Foundation

public protocol Formatter {
    func format(context: Context) -> String
}

public struct HierarchyFormatter<TopLevel: ResponderType>: Formatter {
    public init() {
        
    }
    public func format(context: Context) -> String {
        if let match = context.tree.enumerated().filter({ $0.1.responder is TopLevel }).last {
            let nodes = context.tree[match.offset..<context.tree.count]
            context.tree = Array(nodes)
            return """
            ⚠️ Gedatsu catch AutoLayout error and details below
            ===========================================================
            \(buildHeader(context: context))
            
            \(buildTreeContent(context: context))
            ===========================================================
            
            """
        }
        return """
        ⚠️ Gedatsu catch AutoLayout error and details below
        But could not find \(TopLevel.self) in context: \(context.tree)
        Please confirm for generics about HierarchyFormatter<T>
        ===========================================================
        \(buildHeader(context: context))
        
        \(buildTreeContent(context: context))
        ===========================================================
        
        """
    }
}

public var defaultFormatter: Formatter = HierarchyFormatter<WindowType>()

internal func format(context: Context) -> String {
    return defaultFormatter.format(context: context)
}
