import ObjectiveC
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension ViewType {
    internal static func swizzle() {
        guard let from = class_getInstanceMethod(ViewType.classForCoder(), NSSelectorFromString("engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")) else {
            fatalError("Could not get instance method for ViewType.engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:")
        }
        guard let to = class_getInstanceMethod(ViewType.classForCoder(), #selector(ViewType._engine(engine:constraint:exclusiveConstraints:))) else {
            fatalError("Could not get instance method for ViewType.\(#selector(ViewType._engine(engine:constraint:exclusiveConstraints:)))")
        }
        method_exchangeImplementations(from, to)
    }
    @objc internal func _engine(engine: AnyObject, constraint: NSLayoutConstraint, exclusiveConstraints: [NSLayoutConstraint]) {
        gedatsuAssert(Thread.isMainThread)
        gedatsuAssert(NSClassFromString("NSISEngine") == engine.classForCoder, "Unexpected receive argument for NSEngine")
        defer {
            _engine(engine: engine, constraint: constraint, exclusiveConstraints: exclusiveConstraints)
        }
        #if os(iOS)
        guard let isLoggingSuspend = value(forKey: "_isUnsatisfiableConstraintsLoggingSuspended") as? Bool else {
            fatalError("Could not get value for _isUnsatisfiableConstraintsLoggingSuspended")
        }
        if isLoggingSuspend {
            return
        }
        #endif
        let context = Context(view: self, constraint: constraint, exclusiveConstraints: exclusiveConstraints)
        context.buildTree()
        shared?.interceptor.save {
            if var shared = shared {
                Swift.print(format(context: context), to: &shared)
            }
        }
    }
}
