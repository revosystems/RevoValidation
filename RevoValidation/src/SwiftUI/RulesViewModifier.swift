import SwiftUI

@available(iOS 15.0, *)
public struct RulesViewModifier : ViewModifier {
    @ObservedObject var validator: FormValidator
    @Binding var text: String
    @State var rules: Rules
    @State var fieldID: String
    @State var invalidRules: Rules? = nil
    @Binding var update: Int
    let rulesProvider: (() -> Rules)?
    

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            if let invalid = invalidRules, !invalid.errorMessage.isEmpty {
                Text(invalid.errorMessage)
                    .foregroundStyle(.black.opacity(0.5))
                    .font(.caption)
            }
        }
        .onAppear {
            revalidate(with: text)
        }
        .onChange(of: text) { newValue in
            revalidate(with: newValue)
        }
        .onChange(of: update) { _ in
            revalidate(with: text)
        }
        .overlay(alignment:.topTrailing) {
            if (invalidRules?.count ?? 0) > 0 {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(Color.red)
                    .offset(y:2)
            }
        }
    }
    
    private func revalidate(with currentText: String) {
        if let rulesProvider {
            rules = rulesProvider()
        }
        
        let invalidRules = rules.validate(currentText)
        validator.setErrors(for: fieldID, rules: invalidRules.count > 0 ? invalidRules : nil)
        self.invalidRules = invalidRules
    }
}

//MARK: - TextField extension

@available(iOS 15.0, *)
public extension TextField {
    func rules(formValidator: FormValidator, _ text: Binding<String>, _ rules: [Rule], fieldId:String, rulesProvider: (() -> Rules)? = nil, update: Binding<Int>? = nil) -> some View {
        return modifier(RulesViewModifier(
            validator: formValidator,
            text: text,
            rules: Rules(rules),
            fieldID: fieldId,
            update: update ?? Binding.constant(0),
            rulesProvider: rulesProvider)
        )
    }

    func rules(formValidator: FormValidator, _ text: Binding<String>, _ rules: String, fieldId:String, rulesProvider: (() -> Rules)? = nil, update: Binding<Int>? = nil) -> some View {
        return modifier(RulesViewModifier(
            validator: formValidator,
            text: text,
            rules: Rules(stringLiteral: rules),
            fieldID: fieldId,
            update: update ?? Binding.constant(0),
            rulesProvider: rulesProvider)
        )
    }
}
