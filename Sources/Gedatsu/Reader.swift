import Foundation

internal protocol Reader: PipeType {
    func read(closure: @escaping (String) -> Void)
}

internal class ReaderImpl: Reader {
    let pipe: Pipe = Pipe()
    var fileDescriptor: Int32 { pipe.fileHandleForWriting.fileDescriptor }
    
    func wait() {
        pipe.fileHandleForReading.readInBackgroundAndNotify()
    }
    func read(closure: @escaping (String) -> Void) {
        wait()
        NotificationCenter.default.addObserver(
            forName: FileHandle.readCompletionNotification,
            object: pipe.fileHandleForReading,
            queue: nil
        ) { [weak self] (notification) in
            self?.wait()
            if let data = notification.userInfo?[NSFileHandleNotificationDataItem] as? Data, let content = String(data: data, encoding: .utf8) {
                closure(content)
                return
            } else {
                fatalError("Unexpected data for userInfo: \(String(describing: notification.userInfo))")
            }
        }
    }
}
