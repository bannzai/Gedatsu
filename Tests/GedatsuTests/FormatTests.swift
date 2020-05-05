import XCTest
@testable import Gedatsu

class FormatTests: XCTestCase {
    final class CustomView: UIView { }
    final class CustomView2: UIView { }
    
    func testBuildHeader() {
        XCTContext.runActivity(named: "it cause error only firstItem constraint") { _ in
            let view = CustomView()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 10),
                view.widthAnchor.constraint(equalToConstant: 100),
            ])
            
            let context = Context.init(view: view, constraint: view.constraints[0], exclusiveConstraints: view.constraints)
            let result = buildHeader(context: context)
            
            XCTAssertTrue(result.contains("NSLayoutConstraint"))
            XCTAssertTrue(result.contains("=="))
            XCTAssertTrue(result.contains("width"))
            XCTAssertTrue(result.contains("CustomView"))
            XCTAssertTrue(result.contains(addres(of: view.constraints[0])))
            XCTAssertTrue(result.contains(addres(of: view.constraints[1])))
        }
        XCTContext.runActivity(named: "it cause error with firstItem and secondItem relational constraint") { _ in
            let container = CustomView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let subview = CustomView2()
            subview.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(subview)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: subview.topAnchor, constant: 10),
            ])
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            ])

            let context = Context.init(view: container, constraint: container.constraints[0], exclusiveConstraints: container.constraints)
            let result = buildHeader(context: context)
            
            XCTAssertTrue(result.contains("NSLayoutConstraint"))
            XCTAssertTrue(result.contains("=="))
            XCTAssertTrue(result.contains("top"))
            XCTAssertTrue(result.contains("CustomView"))
            XCTAssertTrue(result.contains("CustomView2"))
            XCTAssertTrue(result.contains(addres(of: container.constraints[0])))
            XCTAssertTrue(result.contains(addres(of: container.constraints[1])))
        }
    }
    func testBuildContent() {
        XCTContext.runActivity(named: "it cause error only firstItem constraint") { _ in
            let view = CustomView()
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 10),
                view.widthAnchor.constraint(equalToConstant: 100),
            ])
            
            let context = Context.init(view: view, constraint: view.constraints[0], exclusiveConstraints: view.constraints)
            context.buildTree()
            let result = buildTreeContent(context: context)

            XCTAssertTrue(result.contains("width"))
            XCTAssertTrue(result.contains("CustomView"))
            XCTAssertTrue(result.contains(addres(of: view)))
        }
        XCTContext.runActivity(named: "it cause error with firstItem and secondItem relational constraint") { _ in
            let container = CustomView()
            container.translatesAutoresizingMaskIntoConstraints = false
            let subview = CustomView2()
            subview.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(subview)
            
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: subview.topAnchor, constant: 10),
            ])
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: subview.topAnchor, constant: 20),
            ])
            
            let context = Context.init(view: container, constraint: container.constraints[0], exclusiveConstraints: container.constraints)
            context.buildTree()
            let result = buildTreeContent(context: context)
            
            XCTAssertTrue(result.contains("top"))
            XCTAssertTrue(result.contains("CustomView"))
            XCTAssertTrue(result.contains(addres(of: container)))
            XCTAssertTrue(result.contains(addres(of: subview)))
        }
    }
}
