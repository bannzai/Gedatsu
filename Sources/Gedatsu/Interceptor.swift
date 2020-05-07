import Foundation

internal typealias InterceptType = (() -> Void)

internal protocol Interceptor {
    func save(closure: @escaping () -> Void)
    func canIntercept() -> Bool
    func intercept()
}

internal class InterceptorImpl: Interceptor {
    var queue: [InterceptType] = []
    func save(closure: @escaping () -> Void) {
        queue.append(closure)
    }
    func canIntercept() -> Bool {
        !queue.isEmpty
    }
    func intercept() {
        if queue.isEmpty {
            gedatsuAssert(false, "unexpected queue is empty", ignoreWarnLog: true)
            return
        }
        let closure = queue.removeFirst()
        closure()
    }
}
