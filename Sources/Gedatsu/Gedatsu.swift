import Foundation
import UIKit

internal typealias InterceptType = (() -> Void)
internal class Gedatsu {
    private let lock = NSLock()
    internal var interceptQueue: [InterceptType] = []
    
    internal let reader: Reader
    internal let writer: Writer
    internal init(reader: Reader, writer: Writer) {
        self.reader = reader
        self.writer = writer
    }
    
    internal func open() {
        _ = dup2(FileHandle.standardError.fileDescriptor, writer.fileDescriptor)
        _ = dup2(reader.fileDescriptor, FileHandle.standardError.fileDescriptor)
        
        reader.read { [weak self] content in
            self?.lock.lock()
            defer { self?.lock.unlock() }
            guard let self = self else {
                return
            }
            switch (self.interceptQueue.isEmpty, Thread.isMainThread) {
            case (true, _), (_, false):
                self.writer.write(content: content)
            case (false, true):
                let closure = self.interceptQueue.removeFirst()
                closure()
            }
        }
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

public func close() {
    shared = nil
}
