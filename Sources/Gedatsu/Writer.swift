import Foundation

internal protocol Writer: PipeType {
    func write(data: Data)
}

internal struct WriterImpl: Writer {
    let pipe = Pipe()
    var fileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    func write(data: Data) {
        pipe.fileHandleForWriting.write(data)
    }
}
