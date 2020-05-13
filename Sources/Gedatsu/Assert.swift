import Foundation

func gedatsuAssert(_ condition: Bool, _ message: String = "", ignoreWarnLog: Bool = false, file: StaticString = #file, line: UInt = #line) {
    if condition {
        return
    }
    if !ignoreWarnLog {
        print("[GEDATSU WARNING]: Unexpected behavior about \(message) in \(file):\(line)")
    }
    #if DEBUG_GEDATSU
    if ignoreWarnLog {
        print("[GEDATSU WARNING]: Unexpected behavior about \(message) in \(file):\(line)")
    }
//    Swift.assert(condition, message)
    #endif
}
