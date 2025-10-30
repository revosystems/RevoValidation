import SwiftUI

@available(iOS 17.0, *)
public struct RulesViewModifier : ViewModifier {
    @ObservedObject var validator: FormValidator
    @Binding var text: String
    let rules: Rules
    
    @State private var fieldID: UUID = UUID()
    @State var invalidRules: Rules? = nil

    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            if let invalid = invalidRules, !invalid.errorMessage.isEmpty {
                Text(invalid.errorMessage)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .onAppear {
            validator.setErrors(for: fieldID, rules: nil)
        }
        .onChange(of: text) { _, newValue in
            let invalidRules = rules.validate(newValue)
            validator.setErrors(for: fieldID, rules: invalidRules.count > 0 ? invalidRules : nil )
            self.invalidRules = invalidRules
        }
        .overlay(alignment:.topTrailing) {
            if (invalidRules?.count ?? 0) > 0 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.orange)
                    .offset(y:2)
            }
        }
        .onDisappear {
            validator.clearField(fieldID)
        }
    }
}

//MARK: - TextField extension

public extension TextField {
    func rules(formValidator: FormValidator, _ text: Binding<String>, _ rules: [Rule]) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(
                validator: formValidator,
                text: text,
                rules: Rules(rules))
            )
        } else {
            return self
        }
    }

    func rules(formValidator: FormValidator, _ text: Binding<String>, _ rules: String) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(
                validator: formValidator,
                text: text,
                rules: Rules(stringLiteral: rules)
            ))
        } else {
            return self
        }
    }
}
