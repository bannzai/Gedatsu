import Foundation
import UIKit

internal class Gedatsu {
    internal typealias InterceptType = (() -> Void)
    internal typealias Pipe = (reader: Reader, writer: Writer)

    private let lock = NSLock()
    internal var interceptQueue: [InterceptType] = []

    internal let standardOutput: Pipe
    internal let standardError: Pipe
    internal init(standardOutput: Pipe, standardError: Pipe) {
        self.standardOutput = standardOutput
        self.standardError = standardError
    }
    
    internal func open() {
        _ = dup2(FileHandle.standardOutput.fileDescriptor, standardOutput.writer.fileDescriptor)
        _ = dup2(FileHandle.standardError.fileDescriptor, standardError.writer.fileDescriptor)
        _ = dup2(standardOutput.reader.fileDescriptor, FileHandle.standardOutput.fileDescriptor)
        _ = dup2(standardError.reader.fileDescriptor, FileHandle.standardError.fileDescriptor)

        standardError.reader.read { [weak self] content in
            self?.lock.lock()
            defer { self?.lock.unlock() }
            guard let self = self else {
                return
            }
            switch (self.interceptQueue.isEmpty, Thread.isMainThread) {
            case (true, _), (_, false):
                self.standardError.writer.write(content: content)
            case (false, true):
                let closure = self.interceptQueue.removeFirst()
                closure()
            }
        }
        
        standardOutput.reader.read { [weak self] (content) in
            self?.standardOutput.writer.write(content: content)
        }
    }
}

internal var shared: Gedatsu?

public func open() {
    if shared != nil {
        return
    }
    shared = Gedatsu(
        standardOutput: (reader: ReaderImpl(), writer: WriterImpl()),
        standardError: (reader: ReaderImpl(), writer: WriterImpl())
    )
    UIView.swizzle()
    shared?.open()
}
