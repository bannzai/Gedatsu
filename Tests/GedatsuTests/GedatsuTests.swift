#if os(iOS)
import UIKit
internal extension ViewType {
    func callLayout() {
        setNeedsLayout()
        layoutIfNeeded()
    }
}
#elseif os(macOS)
import AppKit
internal extension ViewType {
    func callLayout() {
        needsLayout = true
        layoutSubtreeIfNeeded()
    }
}
#endif
import XCTest
@testable import Gedatsu


final class GedatsuTests: XCTestCase {
    let input = Pipe()
    let output = Pipe()
    func testHookStdErrFlow() {
        let reader = ReaderMock()
        let writer = WriterMock()
        let interceptor = InterceptorMock()
        let gedatsu = Worker(reader: reader, writer: writer, interceptor: interceptor)
        shared = gedatsu
        defer { shared = nil }

        prepare: do {
            let data = "abc".data(using: .utf8)!
            
            reader.readClosure = { data }
            reader.underlyingReadingFileDescriptor = input.fileHandleForReading.fileDescriptor
            reader.underlyingWritingFileDescriptor = input.fileHandleForWriting.fileDescriptor
            
            writer.underlyingWritingFileDescriptor = output.fileHandleForWriting.fileDescriptor
            
            interceptor.canInterceptClosure = { true }
        }
        
        ViewType.swizzle()
        gedatsu.open()
        
        before: do {
            XCTAssertFalse(reader.readCalled)
            XCTAssertFalse(writer.writeContentCalled)
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertFalse(interceptor.canInterceptCalled)
            XCTAssertFalse(interceptor.interceptCalled)
        }

        let view = ViewType(frame: .init(origin: .zero, size: .init(width: 375, height: 667)))
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalToConstant: 10),
        ])
        
        let expectation = XCTestExpectation(description: "Keep async queue")
        interceptor.interceptClosure = {
            expectation.fulfill()
        }
        
        view.callLayout()

        XCTWaiter().wait(for: [expectation], timeout: 10)
        
        after: do {
            XCTAssertTrue(reader.readCalled)
            XCTAssertFalse(writer.writeContentCalled)
            XCTAssertTrue(interceptor.saveClosureCalled)
            XCTAssertTrue(interceptor.canInterceptCalled)
            XCTAssertTrue(interceptor.interceptCalled)
        }
    }
    
    func testNoHookStdErrFlow() {
        let reader = ReaderMock()
        let writer = WriterMock()
        let interceptor = InterceptorMock()
        let gedatsu = Worker(reader: reader, writer: writer, interceptor: interceptor)
        shared = gedatsu
        defer { shared = nil }

        let data = "abc".data(using: .utf8)!
        prepare: do {
            reader.readClosure = { data }
            reader.underlyingReadingFileDescriptor = input.fileHandleForReading.fileDescriptor
            reader.underlyingWritingFileDescriptor = input.fileHandleForWriting.fileDescriptor
            
            writer.underlyingWritingFileDescriptor = output.fileHandleForWriting.fileDescriptor
            
            interceptor.canInterceptClosure = { false }
        }
        
        ViewType.swizzle()
        gedatsu.open()
        
        before: do {
            XCTAssertFalse(reader.readCalled)
            XCTAssertFalse(writer.writeContentCalled)
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertFalse(interceptor.canInterceptCalled)
            XCTAssertFalse(interceptor.interceptCalled)
        }
        
        let view = ViewType(frame: .init(origin: .zero, size: .init(width: 375, height: 667)))
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalToConstant: 10),
        ])
        
        let expectation = XCTestExpectation(description: "Keep async queue")
        writer.writeContentClosure = {
            XCTAssertEqual($0, data)
            expectation.fulfill()
        }

        view.callLayout()

        XCTWaiter().wait(for: [expectation], timeout: 10)
        
        after: do {
            XCTAssertTrue(reader.readCalled)
            XCTAssertTrue(writer.writeContentCalled)
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertTrue(interceptor.canInterceptCalled)
            XCTAssertFalse(interceptor.interceptCalled)
        }
    }
}
