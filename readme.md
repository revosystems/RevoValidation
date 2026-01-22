# Example usage with swiftui

import SwiftUI
import RevoValidation

```
struct ValidationForm : View {

    @StateObject private var formValidator = FormValidator()
    @State private var email: String = ""
    @State private var url: String = ""
    @State private var ip: String = ""
    @State private var name:String = ""
    
    var body: some View {
        Form {
            ValidatedTextField("Name", text: $name,  formValidator: formValidator,
                               rules: "required|length:3")
            
            TextField("Email", text: $email)
                .rules(formValidator: formValidator, $email, "required|email")
         
            TextField("URL", text: $url)
                .rules(formValidator: formValidator, $url, "url")
            
            TextField("IP Address", text: $ip)
                .rules(formValidator: formValidator, $ip, "ip")
                            
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

## Available Rules

- `required` - Field is required
- `email` - Validates email format
- `url` - Validates URL format
- `ip` - Validates IPv4 address format
- `numeric` - Must be numeric
- `length:X` - Minimum length of X characters
- `age:X` - Minimum age of X years
- `containsNumber` - Must contain at least one number
- `containsSpecialChars` - Must contain special characters
- `regexp:PATTERN` - Custom regular expression validation
- `nif:COUNTRY` - Validates NIF/Tax ID for specific country (ES, PT, DO)
- `unique:VALUES` - Value must not be in the provided list

