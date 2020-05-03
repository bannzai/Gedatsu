import UIKit
import ObjectiveC

extension UIView {
    internal static func swizzle() {
        guard let from = class_getInstanceMethod(UIView.classForCoder(), NSSelectorFromString("engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")) else {
            fatalError("Could not get instance method for UIView.engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")
        }
        guard let to = class_getInstanceMethod(UIView.classForCoder(), #selector(UIView._engine(view:constraint:exclusiveConstraints:))) else {
            fatalError("Could not get instance method for UIView.\(#selector(UIView._engine(view:constraint:exclusiveConstraints:)))")
        }
        method_exchangeImplementations(from, to)
    }
    @objc internal func _engine(view: UIView, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) {
        defer {
            _engine(view: view, constraint: constraint, exclusiveConstraints: exclusiveConstraints)
        }
        guard let isLoggingSuspend = value(forKey: "_isUnsatisfiableConstraintsLoggingSuspended") as? Bool else {
            fatalError("Could not get value for _isUnsatisfiableConstraintsLoggingSuspended")
        }
        if isLoggingSuspend {
            return
        }
        shared?.intercept = { [weak self] in
            if let format = self?.format(view: view, constraint: constraint, exclusiveConstraints: exclusiveConstraints) {
                print(format)
            }
        }
    }
    internal func format(view: UIView, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) -> String {
        return "abbbb"
    }
}
