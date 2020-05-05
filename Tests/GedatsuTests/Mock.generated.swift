// Generated using Sourcery 0.18.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// swiftlint:disable line_length
// swiftlint:disable variable_name

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@testable import Gedatsu













class FormatterMock: Gedatsu.Formatter {

    //MARK: - format

    var formatContextCallsCount = 0
    var formatContextCalled: Bool {
        return formatContextCallsCount > 0
    }
    var formatContextReceivedContext: Context?
    var formatContextReturnValue: String!
    var formatContextClosure: ((Context) -> String)?

    func format(context: Context) -> String {
        formatContextCallsCount += 1
        formatContextReceivedContext = context
        return formatContextClosure.map({ $0(context) }) ?? formatContextReturnValue
    }

}
class InterceptorMock: Interceptor {

    //MARK: - save

    var saveClosureCallsCount = 0
    var saveClosureCalled: Bool {
        return saveClosureCallsCount > 0
    }
    var saveClosureReceivedClosure: (() -> Void)?
    var saveClosureClosure: ((@escaping () -> Void) -> Void)?

    func save(closure: @escaping () -> Void) {
        saveClosureCallsCount += 1
        saveClosureReceivedClosure = closure
        saveClosureClosure?(closure)
    }

    //MARK: - canIntercept

    var canInterceptCallsCount = 0
    var canInterceptCalled: Bool {
        return canInterceptCallsCount > 0
    }
    var canInterceptReturnValue: Bool!
    var canInterceptClosure: (() -> Bool)?

    func canIntercept() -> Bool {
        canInterceptCallsCount += 1
        return canInterceptClosure.map({ $0() }) ?? canInterceptReturnValue
    }

    //MARK: - intercept

    var interceptCallsCount = 0
    var interceptCalled: Bool {
        return interceptCallsCount > 0
    }
    var interceptClosure: (() -> Void)?

    func intercept() {
        interceptCallsCount += 1
        interceptClosure?()
    }

}
class ReaderMock: Reader {
    var readingFileDescriptor: Int32 {
        get { return underlyingReadingFileDescriptor }
        set(value) { underlyingReadingFileDescriptor = value }
    }
    var underlyingReadingFileDescriptor: Int32!
    var writingFileDescriptor: Int32 {
        get { return underlyingWritingFileDescriptor }
        set(value) { underlyingWritingFileDescriptor = value }
    }
    var underlyingWritingFileDescriptor: Int32!

    //MARK: - read

    var readCallsCount = 0
    var readCalled: Bool {
        return readCallsCount > 0
    }
    var readReturnValue: Data!
    var readClosure: (() -> Data)?

    func read() -> Data {
        readCallsCount += 1
        return readClosure.map({ $0() }) ?? readReturnValue
    }

}
class ViewMock: View {

    //MARK: - view

    var viewCallsCount = 0
    var viewCalled: Bool {
        return viewCallsCount > 0
    }
    var viewReturnValue: UIView?
    var viewClosure: (() -> UIView?)?

    func view() -> UIView? {
        viewCallsCount += 1
        return viewClosure.map({ $0() }) ?? viewReturnValue
    }

}
class WriterMock: Writer {
    var writingFileDescriptor: Int32 {
        get { return underlyingWritingFileDescriptor }
        set(value) { underlyingWritingFileDescriptor = value }
    }
    var underlyingWritingFileDescriptor: Int32!

    //MARK: - write

    var writeContentCallsCount = 0
    var writeContentCalled: Bool {
        return writeContentCallsCount > 0
    }
    var writeContentReceivedContent: Data?
    var writeContentClosure: ((Data) -> Void)?

    func write(content: Data) {
        writeContentCallsCount += 1
        writeContentReceivedContent = content
        writeContentClosure?(content)
    }

}
