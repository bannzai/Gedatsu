import Foundation

internal protocol Writer: PipeType {
    func write(content: String)
}

internal class WriterImpl: Writer {
    let pipe = Pipe()
    var fileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    func write(content: String) {
        content.data(using: .utf8).map(pipe.fileHandleForWriting.write(_:))
    }
}
