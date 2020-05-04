import Foundation

internal protocol Writer {
    func write(content: Data)
    var writingFileDescriptor: Int32 { get }
}

internal class WriterImpl: Writer {
    let pipe = Pipe()
    var writingFileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    func write(content: Data) {
        var data = content
        let length = data.count
        _ = withUnsafePointer(to: &data) { (pointer) in
            Darwin.write(writingFileDescriptor, pointer, length)
        }
    }
}
