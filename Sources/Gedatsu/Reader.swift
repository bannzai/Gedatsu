import Foundation

internal protocol Reader {
    var readingFileDescriptor: Int32 { get }
    var writingFileDescriptor: Int32 { get }
    func read() -> Data
}

internal class ReaderImpl: Reader {
    let pipe: Pipe = Pipe()
    var writingFileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    var readingFileDescriptor: Int32 { pipe.fileHandleForReading.fileDescriptor }

    func read() -> Data {
        pipe.fileHandleForReading.availableData
    }
}
