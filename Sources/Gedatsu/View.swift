import UIKit

protocol View {
    func view() -> UIView?
}
extension UIView: View {
    func view() -> UIView? {
        self
    }
}
extension UILayoutGuide: View {
    func view() -> UIView? {
        owningView
    }
}


