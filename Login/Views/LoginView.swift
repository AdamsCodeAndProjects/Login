//
//  LoginView.swift
//  Login
//
//  Created by adam janusewski on 6/14/22.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            TextField("Email Address", text: $loginVM.credentials.email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $loginVM.credentials.password)
            if loginVM.showProgressView {
                ProgressView()
            }
            Button("Log In") {
                loginVM.login { success in
                    authentication.updatedValidation(success: success)
                }
            }
            .disabled(loginVM.loginDisabled) // Disable if fields null
            .padding(.bottom, 20)
            
            if authentication.biometricType() != .none {
                Button {
                    authentication.requestBiometricUnlock {
                        (result:Result<Credentials, Authentication.AuthenticationError>) in
                        switch result {
                        case .success(let credentials):
                            loginVM.credentials = credentials
                            loginVM.login { success in
                                authentication.updatedValidation(success: success)
                            }
                        case .failure(let error):
                            loginVM.error = error
                        }
                    }
                } label: {
                    Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            
            Spacer()
            
            Image(systemName: "airplane.departure")
                .resizable()
                .frame(width: 250, height: 200, alignment: .center)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            
            Spacer()
        }
        .autocapitalization(.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .disabled(loginVM.showProgressView)
        .alert(item: $loginVM.error) { error in
            if error == .credentialsNotSaved {
                return Alert(title: Text("Credentials not saved"), message: Text(error.localizedDescription), primaryButton: .default(Text("Ok"), action: {
                    loginVM.storeCredentialsNext = true
                }),
                             secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
    }
}
