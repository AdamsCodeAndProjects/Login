//
//  ContentView.swift
//  Login
//
//  Created by adam janusewski on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Authorized...  Welcome Aboard!")
                    .font(.custom("Arial", size: 22))
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                    
                Image(systemName: "bolt.car.fill")
                    .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Login App")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log Out") {
                        authentication.updatedValidation(success: false)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
