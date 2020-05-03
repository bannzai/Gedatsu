import Foundation
import UIKit

internal typealias InterceptType = (() -> Void)
internal class Gedatsu {
    internal let lock = NSLock()
    internal var intercept: InterceptType?
    
    internal let reader: Reader
    internal let writer: Writer
    internal init(reader: Reader, writer: Writer) {
        self.reader = reader
        self.writer = writer
    }
    
    internal func open() {
        _ = dup2(FileHandle.standardError.fileDescriptor, writer.fileDescriptor)
        _ = dup2(reader.fileDescriptor, FileHandle.standardError.fileDescriptor)
        
        reader.watch { [weak self] in
            self?.lock.lock()
            defer {
                self?.reader.wait()
                self?.lock.unlock()
            }
            // NOTE: engine:willBreakConstraint:dueToMutuallyExclusiveConstraints: call -> intercept = nil -> _engine:willBreakConstraint:dueToMutuallyExclusiveConstraints:(print)
            if let keepIntercept = self?.intercept {
                self?.intercept = nil
                keepIntercept()
                return
            }
            guard let data = self?.reader.read() else {
                return
            }
            self?.writer.write(data: data)
        }
        reader.wait()
        UIView.swizzle()
    }
}

internal var shared: Gedatsu?

public func open() {
    if shared != nil {
        close()
    }
    shared = Gedatsu(reader: ReaderImpl(), writer: WriterImpl())
    shared?.open()
}

internal func intercept(closure: @escaping InterceptType) {
    shared?.intercept = closure
}

public func close() {
    shared = nil
}
