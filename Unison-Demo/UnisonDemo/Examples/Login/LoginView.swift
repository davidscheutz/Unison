import SwiftUI
import Unison

struct LoginView: View, UnisonView {
    
    let state: LoginViewState
    let handler: (LoginEvent) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .padding(.vertical, 50)
            
            input(placeholder: "user@email.com", input: state.username) {
                handler(.usernameChanged($0))
            }
            
            input(placeholder: "password", input: state.password) {
                handler(.passwordChanged($0))
            }
            
            Spacer()
            
            button()
        }
        .animation(.default, value: state.error)
        .animation(.default, value: state.username.error)
        .animation(.default, value: state.password.error)
        .overlay(alignment: .top) { error() }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

extension LoginView {
    
    private func input(
        placeholder: String,
        input: LoginViewState.Input,
        onChange: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading) {
            TextField(
                placeholder,
                text: .init(
                    get: { input.value },
                    set: onChange
                )
            )
            
            if let error = input.error {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
            }
        }
    }
    
    @ViewBuilder
    private func button() -> some View {
        if state.isLoading {
            ActivityIndicator()
        } else {
            Button(action: { handler(.login) }) {
                HStack {
                    Text("Login")
                }
                .frame(minWidth: 120)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private func error() -> some View {
        if let error = state.error {
            Text(error)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
                .background(Color.red.opacity(0.5))
                .cornerRadius(8)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        render(.initial)
        render(.initial.copy(
            username: .init(value: "user@gmail.com", error: nil),
            password: .init(value: "1234", error: nil),
            isLoading: true
        ))
        render(.initial.copy(
            username: .init(value: "xxx", error: "Invalid email"),
            password: .init(value: "", error: "empty passowrd")
        ))
        render(.initial.copy(error: "No internet connection"))
    }
    
    static func render(_ state: LoginViewState) -> some View {
        LoginView(state: state) { _ in }
    }
}
#endif
