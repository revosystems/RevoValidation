# Example usage with swiftui

import SwiftUI
import RevoValidation

```
struct ValidationForm : View {

    @StateObject private var formValidator = FormValidator()
    @State private var email: String = ""
    @State private var url: String = ""
    @State private var name:String = ""
    
    var body: some View {
        Form {
            ValidatedTextField("Name", text: $name,  formValidator: formValidator,
                               rules: "required|length:3")
            
            TextField("Email", text: $email)
                .rules(formValidator: formValidator, $email, "required|email")
         
            TextField("URL", text: $url)
                .rules(formValidator: formValidator, $url, "url")
                            
            HStack{
                Spacer()
                Button("Done") { 
                    debugPrint("Done")
                }.disabled(!formValidator.isValid)
                Spacer()
            }
            
            Text(formValidator.errorMessage)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    ValidationForm()
}
```


