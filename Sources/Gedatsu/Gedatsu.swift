import Foundation

internal class Worker {
    private let lock = NSLock()
    internal let reader: Reader
    internal let writer: Writer
    internal let interceptor: Interceptor
    internal init(reader: Reader, writer: Writer, interceptor: Interceptor) {
        self.reader = reader
        self.writer = writer
        self.interceptor = interceptor
    }
    
    private var source: DispatchSourceRead!
    internal func open() {
        _ = dup2(STDERR_FILENO, writer.writingFileDescriptor)
        _ = dup2(reader.writingFileDescriptor, STDERR_FILENO)
        source = DispatchSource.makeReadSource(fileDescriptor: reader.readingFileDescriptor, queue: .init(label: "com.bannzai.gedatsu"))
        source.setEventHandler {
            self.lock.lock()
            defer { self.lock.unlock() }
            // NOTE: it is necessary to call and dispose read `data` when if not use `data`
            let data = self.reader.read()
            switch self.interceptor.canIntercept() {
            case true:
                DispatchQueue.main.async {
                    self.interceptor.intercept()
                }
            case false:
                self.writer.write(content: data)
            }
        }
        source.resume()
    }
}

extension Worker: TextOutputStream {
    func write(_ string: String) {
        let data = string.data(using: .utf8)
        gedatsuAssert(data != nil)
        data.map(writer.write(content:))
    }
}

internal var shared: Worker?

public func open() {
    if shared != nil {
        return
    }
    shared = Worker(
        reader: ReaderImpl(),
        writer: WriterImpl(),
        interceptor: InterceptorImpl()
    )
    ViewType.swizzle()
    shared?.open()
}
