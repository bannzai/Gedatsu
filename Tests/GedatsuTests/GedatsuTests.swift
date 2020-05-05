import UIKit
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
        
        UIView.swizzle()
        gedatsu.open()
        
        before: do {
            XCTAssertFalse(reader.readCalled)
            XCTAssertFalse(writer.writeContentCalled)
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertFalse(interceptor.canInterceptCalled)
            XCTAssertFalse(interceptor.interceptCalled)
        }

        let view = UIView(frame: .init(origin: .zero, size: .init(width: 375, height: 667)))
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 100),
            view.widthAnchor.constraint(equalToConstant: 10),
        ])
        
        let expectation = XCTestExpectation(description: "Keep async queue")
        interceptor.interceptClosure = {
            expectation.fulfill()
        }
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
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
        
        UIView.swizzle()
        gedatsu.open()
        
        before: do {
            XCTAssertFalse(reader.readCalled)
            XCTAssertFalse(writer.writeContentCalled)
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertFalse(interceptor.canInterceptCalled)
            XCTAssertFalse(interceptor.interceptCalled)
        }
        
        let view = UIView(frame: .init(origin: .zero, size: .init(width: 375, height: 667)))
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

        view.setNeedsLayout()
        view.layoutIfNeeded()
        
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
