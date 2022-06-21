//
//  Authentication.swift
//  Login
//
//  Created by adam janusewski on 6/14/22.
//

import SwiftUI
import LocalAuthentication  // To implement Face Recognition and Touch Recognition

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAuthorized = false
    
    enum BiometricType {
        case none
        case touch
        case face
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invaalidCredentials
        case deniedAccess
        case noFaceIdEnrolled
        case NoFingerprintEnrolled
        case biometricError
        case credentialsNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invaalidCredentials:
                return NSLocalizedString("Incorrect credentials.  Please try again", comment: "")
            case .deniedAccess:
                return NSLocalizedString("You have been denied.  Please go to the settings and turn on Face Recognition", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("you have not registered any Face Ids yet", comment: "")
            case .NoFingerprintEnrolled:
                return NSLocalizedString("You have not registered any fingerprints yet", comment: "")
            case .biometricError:
                return NSLocalizedString("Your face or fingerprint were not recognized", comment: "")
            case .credentialsNotSaved:
                return NSLocalizedString("Your credentials were not saved.  Do you want to save them after the next successful login", comment: "")
            }
        }
    }
    
    func updatedValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch authContext.biometryType {
        case .none:
            return .none
        case .touchID:
            return .touch
        case .faceID:
            return .face
        @unknown default:
            return .none
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<Credentials, AuthenticationError>) -> Void) {
//        let credentials: Credentials? = Credentials(email: "anything", password: "password")
//        let credentials: Credentials? = nil
        let credentials = KeychainStorage.getCredentials()
        guard let credentials = credentials else {
            completion(.failure(.credentialsNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deniedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else {
                    completion(.failure(.NoFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometricError))
            }
            return
        }
        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials.") { success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometricError))
                        } else {
                            completion(.success(credentials))
                        }
                    }
                    
                }
            }
        }
    }
}
