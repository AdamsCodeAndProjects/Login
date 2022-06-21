//
//  LoginApp.swift
//  Login
//
//  Created by adam janusewski on 6/14/22.
//

import SwiftUI

@main
struct LoginApp: App {
    @StateObject var authentication = Authentication()
    var body: some Scene {
        WindowGroup {
            if authentication.isValidated {
                ContentView()
                    .environmentObject(authentication)
            } else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
    }
}
