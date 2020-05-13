protocol View {
    func view() -> ViewType?
}
extension ViewType: View {
    func view() -> ViewType? {
        self
    }
}
extension LayoutGuideType: View {
    func view() -> ViewType? {
        owningView
    }
}
