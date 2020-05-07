import Foundation

func gedatsuAssert(_ condition: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    if condition {
        return
    }
    print("[GEDATSU WARNING]: Unexpected behavior about \(message) in \(file):\(line)")
    #if DEBUG_GEDATSU
    Swift.assert(condition, message)
    #endif
}
