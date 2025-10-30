import SwiftUI

@available(iOS 17.0, *)
public struct RulesViewModifier : ViewModifier {
    @Binding var validator:FormValidator
    @Binding var text:String
    let rules:Rules

    // Stable identifier for this field instance.
    @State private var fieldID: UUID = UUID()

    @State var invalidRules:Rules? = nil

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
            // Initialize entry for this field so aggregate validity can be computed.
            validator.setErrors(for: fieldID, rules: nil)
        }
        .onChange(of: text) { _, newValue in
            invalidRules = rules.validate(newValue)

            // If there are no invalid rules, store nil to represent "no errors".
            if let invalid = invalidRules, invalid.count > 0 {
                validator.setErrors(for: fieldID, rules: invalid)
            } else {
                validator.setErrors(for: fieldID, rules: nil)
            }
        }
        .overlay(alignment:.topTrailing) {
            if (invalidRules?.count ?? 0) > 0 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.red)
                    .offset(y:2)
            }
        }
        .onDisappear {
            // Optionally clear when the field goes away.
            validator.clearField(fieldID)
        }
    }
}

public extension TextField {
    func rules(_ text:Binding<String>, _ rules:[Rule], formValidator:Binding<FormValidator>) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(
                validator:formValidator,
                text:text,
                rules: Rules(rules))
            )
        } else {
            return self
        }
    }

    func rules(_ text:Binding<String>, _ rules:String, formValidator:Binding<FormValidator>) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(
                validator:formValidator,
                text:text,
                rules: Rules(stringLiteral: rules)
            ))
        } else {
            return self
        }
    }
}

