import Foundation
import UIKit

internal typealias InterceptType = (() -> Void)
internal class Gedatsu {
    internal let input = Pipe()
    internal let output = Pipe()
    
    internal let lock = NSLock()
    internal var intercept: InterceptType?
    
    internal func open() {
        _ = dup2(FileHandle.standardError.fileDescriptor, output.fileHandleForWriting.fileDescriptor)
        _ = dup2(input.fileHandleForWriting.fileDescriptor, FileHandle.standardError.fileDescriptor)
        
        input.fileHandleForReading.readabilityHandler = { [weak self] fileHandle in
            self?.lock.lock()
            defer {
                self?.input.fileHandleForReading.readInBackgroundAndNotify()
                self?.lock.unlock()
            }
            guard let data = self?.input.fileHandleForReading.availableData else {
                return
            }
            // NOTE: engine:willBreakConstraint:dueToMutuallyExclusiveConstraints: call -> intercept = nil -> _engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:(print)
            if let keepIntercept = self?.intercept {
                self?.intercept = nil
                keepIntercept()
                return
            }
            self?.output.fileHandleForWriting.write(data)
        }
        input.fileHandleForReading.readInBackgroundAndNotify()
        UIView.swizzle()
    }
}

internal var shared: Gedatsu?

public func open() {
    if shared != nil {
        close()
    }
    shared = Gedatsu()
    shared?.open()
}

internal func intercept(closure: @escaping InterceptType) {
    shared?.intercept = closure
}

public func close() {
    shared = nil
}
