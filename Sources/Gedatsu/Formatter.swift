import Foundation
import UIKit

public typealias FormatterArgument = (view: UIView, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint])
public protocol Formatter {
    func format(for argument: FormatterArgument) -> String
}

public struct HierarcyFormatter<TopLevel: UIResponder>: Formatter {
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


enum Line {
    static let horizontal = "❌"
    static let vertical = "|"
}

internal func format(constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) -> String {
    print("constraint: ----")
    _print(constraint: constraint)
    print("exclusiveConstraints: -----")
    exclusiveConstraints.enumerated().forEach { (offset, constraint) in
        var _frame: CGRect?
        switch constraint.firstItem {
        case let view as UIView:
            _frame = view.frame
        case let guide as UILayoutGuide:
            _frame = guide.owningView?.frame
        case _:
            assertionFailure("Unexpected firstItem type \(String(describing: constraint.firstItem))")
        }
        guard let frame = _frame else {
            return
        }
        
        let maxX = Int(frame.maxX / 10)
        let maxY = Int(frame.maxY / 10)
        let horizontalLine: [String] = Array(repeating: " ", count: maxX)
        var matrix: [[String]] = Array(repeating: horizontalLine, count: maxY)
        stride(from: 0, to: maxY, by: 1).forEach { offset in
            matrix[offset][0] = Line.vertical
            matrix[offset][maxX - 1] = Line.vertical
        }
        stride(from: 0, to: maxX, by: 1).forEach { offset in
            matrix[0][offset] = Line.horizontal
            matrix[maxY - 1][offset] = Line.horizontal
        }
        var string = ""
        for horizontalLine in matrix {
            for element in horizontalLine {
                string = "\(string)\(element)"
            }
            string = "\(string)\n"
        }

        print(string)
//        print("\(offset): --- ")
//        _print(constraint: constraint)
    }
    print("")
    return "abc"
}
public func _print(constraint: NSLayoutConstraint) {
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
