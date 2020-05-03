import UIKit
import ObjectiveC

extension UIView {
    internal static func swizzle() {
        guard let from = class_getInstanceMethod(UIView.classForCoder(), NSSelectorFromString("engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")) else {
            fatalError("Could not get instance method for UIView.engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")
        }
        guard let to = class_getInstanceMethod(UIView.classForCoder(), #selector(UIView._engine(engine:constraint:exclusiveConstraints:))) else {
            fatalError("Could not get instance method for UIView.\(#selector(UIView._engine(engine:constraint:exclusiveConstraints:)))")
        }
        method_exchangeImplementations(from, to)
    }
    @objc internal func _engine(engine: AnyObject, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) {
        assert(Thread.isMainThread)
        assert(NSClassFromString("NSISEngine") == engine.classForCoder, "Unexpected receive argument for NSEngine")
        defer {
            _engine(engine: engine, constraint: constraint, exclusiveConstraints: exclusiveConstraints)
        }
        guard let isLoggingSuspend = value(forKey: "_isUnsatisfiableConstraintsLoggingSuspended") as? Bool else {
            fatalError("Could not get value for _isUnsatisfiableConstraintsLoggingSuspended")
        }
        if isLoggingSuspend {
            return
        }
        shared?.interceptQueue.append {
            print(format(constraint: constraint, exclusiveConstraints: exclusiveConstraints))
        }
    }
}
