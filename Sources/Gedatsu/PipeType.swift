import Foundation

internal protocol PipeType: AnyObject {
    var pipe: Pipe { get }
    var fileDescriptor: Int32 { get }
}
