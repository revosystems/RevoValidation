import SwiftUI

@available(iOS 17.0, *)
public struct RulesViewModifier : ViewModifier {
    @Binding var text:String
    let rules:Rules
    
    @State var invalidRules:Rules? = nil
        
    public func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
            if let invalid = invalidRules, !invalid.firstErrorMessage.isEmpty {
                Text(invalid.firstErrorMessage)
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .onChange(of: text) { _, newValue in
            invalidRules = rules.validate(newValue)
        }
        .overlay(alignment:.topTrailing) {
            if (invalidRules?.count ?? 0) > 0 {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Color.red)
                    .offset(y:2)
            }
        }        
    }
}

public extension TextField {
    func rules(_ text:Binding<String>, _ rules:[Rule]) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(text:text, rules: Rules(rules)))
        } else {
            return self
        }
    }
    
    func rules(_ text:Binding<String>, _ rules:String) -> some View {
        if #available(iOS 17.0, *) {
            return modifier(RulesViewModifier(text:text, rules: Rules(stringLiteral: rules)))
        } else {
            return self
        }
    }
}


