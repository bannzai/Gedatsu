protocol View {
    func view() -> ViewType?
}
extension ViewType: View {
    func view() -> ViewType? {
        self
    }
}
extension UILayoutGuide: View {
    func view() -> ViewType? {
        owningView
    }
}
