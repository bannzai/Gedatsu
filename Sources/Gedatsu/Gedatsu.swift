import Foundation
import UIKit

private var source: DispatchSourceRead!
internal class Gedatsu {
    internal typealias InterceptType = (() -> Void)

    private let lock = NSLock()
    internal var interceptQueue: [InterceptType] = []

    internal let reader: Reader
    internal let writer: Writer
    internal init(reader: Reader, writer: Writer) {
        self.reader = reader
        self.writer = writer
    }
    
    internal func open() {
        let input = Pipe()
        let output = Pipe()
        _ = dup2(FileHandle.standardError.fileDescriptor, output.fileHandleForWriting.fileDescriptor)
        _ = dup2(input.fileHandleForWriting.fileDescriptor, STDERR_FILENO)
        source = DispatchSource.makeReadSource(fileDescriptor: input.fileHandleForReading.fileDescriptor, queue: nil)
        source.setEventHandler {
            var data = input.fileHandleForReading.availableData
            let length = data.count
            switch self.interceptQueue.isEmpty {
            case true:
                _ = withUnsafePointer(to: &data) { (pointer) in
                    write(output.fileHandleForWriting.fileDescriptor, pointer, length)
                }
            case false:
                let closure = self.interceptQueue.removeFirst()
                closure()
            }
        }
        source.activate()
//        reader.read { [weak self] content in
//            self?.lock.lock()
//            defer { self?.lock.unlock() }
//            guard let self = self else {
//                return
//            }
//            print("self.interceptQueue.count: \(self.interceptQueue.count)")
//            switch (self.interceptQueue.isEmpty, Thread.isMainThread) {
//            case (true, _), (_, false):
//                self.writer.write(content: content)
//            case (false, true):
//                let closure = self.interceptQueue.removeFirst()
//                closure()
//            }
//        }
    }
}

internal var shared: Gedatsu?

public func open() {
    if shared != nil {
        return
    }
    shared = Gedatsu(
        reader: ReaderImpl(),
        writer: WriterImpl()
    )
    UIView.swizzle()
    shared?.open()
}
