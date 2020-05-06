import Foundation

internal protocol Writer {
    func write(content: Data)
    var writingFileDescriptor: Int32 { get }
}

internal class WriterImpl: Writer {
    let pipe = Pipe()
    var writingFileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    func write(content: Data) {
        pipe.fileHandleForWriting.write(content)
    }
}
