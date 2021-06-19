import SwiftUI

enum InputTypes {
    case user
    case password
    case repeatPassword
}

enum NavigationFlow {
    case login
    case signup
}

// MARK: - Main view
public struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State var userName = String()
    @State var password = String()
    @State var repeatPassword = String()
    @State var currentView: NavigationFlow = .login
    var primaryColor: Color
    var secondaryColor: Color
    var backgroundImage: String

    private var errorText: String {
        "Error on \(currentView == .login ? "Login" : "Sign up")"
    }

    public var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    // Logo
                    Logo(backgroundImage: backgroundImage)

                    // Presentation
                    PresentScreen(currentScreent: currentView)

                    // Inputs
                    InputField(userFromParent: $userName, inputType: .user)
                    InputField(userFromParent: $password, inputType: .password)
                    if currentView == .signup {
                        InputField(userFromParent: $repeatPassword, inputType: .repeatPassword)
                    }

                    // Submit
                    SubmitButton(currentScreen: currentView, secondaryColor: secondaryColor, action: submitAction)

                    // Navigation
                    Spacer(minLength: 0)
                    ActionNavigation(secondaryColor: secondaryColor,
                                     currentScreen: currentView,
                                     changeNavigation: changeNavigation)

                }
                Spacer(minLength: 0)
            }
            .background(primaryColor.ignoresSafeArea(.all, edges: .all))
            if viewModel.loading {
                LoadingView()
            }
        }.onChange(of: viewModel.registerSucess, perform: { value in
            guard value == true else { return }
            currentView = .login
        })
    }

    public init(primaryColor: Color, secondaryColor: Color, backgroundImage: String,
                baseUrl: String, delegate: LoginProtocol?) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.backgroundImage = backgroundImage
        self.viewModel = LoginViewModel(baseUrl: baseUrl, delegate: delegate)
    }

    private func submitAction() {
        if currentView == .login {
            viewModel.userLoginIntent(username: userName, password: password)
        } else {
            viewModel.userRegisterIntent(username: userName, password: password, repeatPassword: repeatPassword)
        }
    }

    private func changeNavigation() {
        currentView = currentView == .login ? .signup : .login
    }
}


// MARK: - Loading View
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
    }
}


// MARK: - Logo
struct Logo: View {
    var backgroundImage: String

    var body: some View {
        HStack {
            Spacer()
            Image(backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250)
            Spacer()
        }.padding()
    }
}

// MARK: - Screen Presentation
struct PresentScreen: View {
    let currentScreent: NavigationFlow

    var headerTitleText: String {
        currentScreent == .login ? "Login" : "Sign up"
    }
    var subHeaderText: String {
        currentScreent == .login ? "Please log in to continue" : "Please sign up to continue"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text(headerTitleText)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(subHeaderText).foregroundColor(Color.white.opacity(0.5))
        }).padding(20)
    }
}

// MARK: - Inputs
struct InputField: View {
    @Binding var userFromParent: String

    let inputType: InputTypes

    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon()).font(.title2).foregroundColor(.white).frame(width: 30)
                if inputType == .user {
                    TextField(textlabel(), text: $userFromParent)
                } else {
                    SecureField(textlabel(), text: $userFromParent)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(userFromParent.isEmpty ? 0 : 0.12))
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
    }

    func icon() -> String {
        switch inputType {
        case .user:
            return "envelope"
        case .password:
            return "lock"
        case .repeatPassword:
            return "lock"
        }
    }

    func textlabel() -> String {
        switch inputType {
        case .user:
            return "EMAIL"
        case .password:
            return "PASSWORD"
        case .repeatPassword:
            return "REPEAT PASSWORD"
        }
    }
}

// MARK: - Submit Button
struct SubmitButton: View {
    var secondaryColor: Color
    let currentScreen: NavigationFlow
    let submitAction: () -> Void


    var submitLabel: String {
        currentScreen == .login ? "LOGIN" : "SIGN UP"
    }

    var body: some View {

        Spacer()
        VStack {
            HStack {
                Spacer()
                Text(submitLabel)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 150)
                    .background(secondaryColor)
                    .clipShape(Capsule())
                    .onTapGesture(count: 1) {
                        submitAction()
                    }
                Spacer()
            }
            if currentScreen == .login {
                Button("Forgot password?") {
                    print("Forgot password indeed")
                }
                .padding(.top, 5)
                .foregroundColor(secondaryColor)
            }

        }
    }

    init(currentScreen: NavigationFlow, secondaryColor: Color, action: @escaping () -> Void) {
        self.currentScreen = currentScreen
        self.secondaryColor = secondaryColor
        submitAction = action
    }
}

// MARK: - Change Navigation
struct ActionNavigation: View {
    var secondaryColor: Color
    let currentScreen: NavigationFlow
    let changeNavigation: () -> Void

    var descriptionLabel: String {
        currentScreen == .login ? "Don't have an account?" : "Do you have already an account?"
    }
    var actionButtonLabel: String {
        currentScreen == .login ? "Sign up" : "Log in"
    }

    var body: some View {
        HStack {
            Spacer()
            Text(descriptionLabel)
            Button(actionButtonLabel) {
                changeNavigation()
            }.foregroundColor(secondaryColor)
            Spacer()
        }
    }
}
