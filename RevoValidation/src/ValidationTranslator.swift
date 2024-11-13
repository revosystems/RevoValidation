import Foundation
import RevoFoundation

public class ValidationTranslator : Resolvable {
    
    public required init(){
        
    }
    
    public convenience init(callback:@escaping(_ key:String)->String){
        self.init()
        self.callback = callback
    }
    
    public var callback:((_ key:String)->String)? = nil
    
    public func translate(key:String) -> String {
        if let callback = callback {
            return callback(key)
        }
        return NSLocalizedString(key, comment: key)
    }
}
