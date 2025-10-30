import SwiftUI

public struct ValidatedTextField: View {
    @Binding var text: String
    let title: String
    let rules: Rules
    @ObservedObject var formValidator: FormValidator
    
    public init(_ title:String, text: Binding<String>, formValidator: FormValidator, rules: String) {
        self.title = title
        self._text = text
        self.rules = Rules(stringLiteral: rules)
        self.formValidator = formValidator
    }
    
    public init(_ title:String, text: Binding<String>, formValidator: FormValidator, rules: [Rule]) {
        self.title = title
        self._text = text
        self.rules = Rules(rules)
        self.formValidator = formValidator
    }

    public var body: some View {
        TextField(title, text: $text)
            .rules(formValidator: formValidator, $text, rules.rules)
    }
}
