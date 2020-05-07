import Foundation

func gedatsuAssert(_ condition: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
    print("[GEDATSU WARNING]: Unexpected behavior about \(message) with condition \(condition) in \(file):\(line)")
    #if DEBUG_GEDATSU
    Swift.assert(condition, message)
    #endif
}
