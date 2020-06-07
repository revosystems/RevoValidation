import Foundation

class RuleLenght : Rule {
 
    var length = 6
    override var errorMessage: String{
        "Needs to be at least \(length)"
    }
    
    init(_ length:Int = 6){
        self.length = length
    }
    
    override func isValid(_ text:String) -> Bool {
        text.count >= length
    }
}
