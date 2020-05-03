import Foundation

internal protocol Reader: PipeType {
    func wait()
    func watch(closure: @escaping () -> Void)
    func read() -> Data
}

internal struct ReaderImpl: Reader {
    let pipe: Pipe = Pipe()
    var fileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    
    func wait() {
        pipe.fileHandleForReading.readInBackgroundAndNotify()
    }
    func watch(closure: @escaping () -> Void) {
        pipe.fileHandleForReading.readabilityHandler = { _ in
            closure()
        }
        wait()
    }
    
    func read() -> Data {
       pipe.fileHandleForReading.availableData
    }
}
