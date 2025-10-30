import SwiftUI
import RevoValidation
import Combine

public class FormValidator : ObservableObject {
    // Store per-field validation results keyed by a field UUID.
    // A value of nil or Rules with count == 0 means the field is currently valid.
    @Published public var fieldErrors: [UUID: Rules?] = [:]

    // Aggregate validity across all registered fields.
    // If there are no entries yet, you can decide your default; here we consider it false
    // so buttons remain disabled until at least one validation runs.
    public var isValid: Bool {
        guard !fieldErrors.isEmpty else { return false }
        return fieldErrors.values.allSatisfy { rulesOpt in
            guard let rules = rulesOpt else { return true }
            return rules.count == 0
        }
    }

    public init() {}

    // Internal helpers for the modifier to update errors.
    func setErrors(for fieldID: UUID, rules: Rules?) {
        fieldErrors[fieldID] = rules
        objectWillChange.send()
    }

    func clearField(_ fieldID: UUID) {
        fieldErrors.removeValue(forKey: fieldID)
        objectWillChange.send()
    }

    // Convenience to fetch a field's first error message if needed elsewhere.
    public func errorMessage(for fieldID: UUID) -> String? {
        guard let rules = fieldErrors[fieldID] ?? nil else { return nil }
        let msg = rules.errorMessage
        return msg.isEmpty ? nil : msg
    }
}

