import UIKit
import XCTest
@testable import Gedatsu

final class GedatsuTests: XCTestCase {
    func testHookStdErrFlow() {
        let reader = ReaderMock()
        let writer = WriterMock()
        let interceptor = InterceptorMock()
        let gedatsu = Worker(reader: reader, writer: writer, interceptor: interceptor)
        
        prepare: do {
            let data = "abc".data(using: .utf8)!
            
            let input = Pipe()
            reader.readClosure = { data }
            reader.underlyingReadingFileDescriptor = input.fileHandleForReading.fileDescriptor
            reader.underlyingWritingFileDescriptor = input.fileHandleForWriting.fileDescriptor
            
            let output = Pipe()
            writer.writeContentClosure = {
                XCTAssertEqual($0, data)
            }
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
            XCTAssertFalse(interceptor.saveClosureCalled)
            XCTAssertTrue(interceptor.canInterceptCalled)
            XCTAssertTrue(interceptor.interceptCalled)
        }
    }
}
