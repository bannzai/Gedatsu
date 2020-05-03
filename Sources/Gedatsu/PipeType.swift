import Foundation

internal protocol PipeType {
    var pipe: Pipe { get }
    var fileDescriptor: Int32 { get }
}
