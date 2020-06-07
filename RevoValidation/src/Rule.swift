import Foundation

class Rule {
    
    var errors:[String] = []
    var errorMessage:String { "" }
    
    func isValid(_ text:String) -> Bool {
        return true
    }
}
