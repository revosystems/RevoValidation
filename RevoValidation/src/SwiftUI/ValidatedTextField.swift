import SwiftUI

@available(iOS 15.0, *)
public struct ValidatedTextField: View {
    @Binding var text: String
    let title: String
    @State var rules: Rules
    @ObservedObject var formValidator: FormValidator
    let rulesProvider: (() -> Rules)?
    let update: Binding<Int>?
    
    
    public init(_ title:String, text: Binding<String>, formValidator: FormValidator, rules: String) {
        self.title = title
        self._text = text
        self.rules = Rules(stringLiteral: rules)
        self.formValidator = formValidator
        self.rulesProvider = nil
        self.update = nil
    }
    
    public init(_ title:String, text: Binding<String>, formValidator: FormValidator, rules: [Rule]) {
        self.title = title
        self._text = text
        self.rules = Rules(rules)
        self.formValidator = formValidator
        self.rulesProvider = nil
        self.update = nil
    }
    
    public init(_ title:String, text: Binding<String>, formValidator: FormValidator, rulesProvider: @escaping () -> Rules, update: Binding<Int>) {
        self.title = title
        self._text = text
        self.rules = rulesProvider()
        self.formValidator = formValidator
        self.rulesProvider = rulesProvider
        self.update = update
    }

    public var body: some View {
        TextField(title, text: $text)
            .rules(formValidator: formValidator, $text, rules.rules, fieldId: title, rulesProvider: rulesProvider, update: update)
    }
}
