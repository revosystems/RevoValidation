import Foundation

public class RuleUrl : Rule {

    override var errorMessage: String { "Needs to be an url" }

    override public func isValid(_ text:String) -> Bool {
        guard !text.contains("..") else { return false }
        guard !text.contains(" ") else { return false }
        guard text.first != "." && text.last != "." else { return false }

        let head     = "(((http|https)://)?([(w|W)]{3}+\\.)?)?"
        let tail     = "\\.+[A-Za-z]{2,}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail

        let urlPred = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let isUrl = urlPred.evaluate(with: text)

        return isUrl
    }
}
