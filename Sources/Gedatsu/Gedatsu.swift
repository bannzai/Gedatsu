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
        _ = dup2(FileHandle.standardError.fileDescriptor, writer.writingFileDescriptor)
        _ = dup2(reader.writingFileDescriptor, STDERR_FILENO)
        source = DispatchSource.makeReadSource(fileDescriptor: reader.readingFileDescriptor, queue: .init(label: "com.bannzai.gedatsu"))
        source.setEventHandler {
            self.lock.lock()
            defer { self.lock.unlock() }
            let data = self.reader.read()
            switch self.interceptQueue.isEmpty {
            case true:
                self.writer.write(content: data)
            case false:
                DispatchQueue.main.async {
                    let closure = self.interceptQueue.removeFirst()
                    closure()
                    print("self.interceptQueue.count: \(self.interceptQueue.count)")
                }
            }
        }
        source.resume()
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
