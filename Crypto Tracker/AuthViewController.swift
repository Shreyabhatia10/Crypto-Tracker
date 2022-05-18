//
//  AuthViewController.swift
//  Crypto Tracker
//
//  Created by Shreya Bhatia on 17/05/22.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        presentAuth()
    }
    
    func presentAuth() {
        LAContext().evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Your Crypto is protected by Biometrics") { success, error in
            if success {
                DispatchQueue.main.async { [unowned self] in
                    let cryptoTableVC = CryptoTableViewController()
                    let navController = UINavigationController(rootViewController: cryptoTableVC)
                    self.present(navController, animated: true, completion: nil)
                }
            } else {
                if let errorObj = error as? LAError {
                    print("Error took place. \(errorObj.localizedDescription)")
                    if errorObj.code == .userCancel {
                        self.presentAuth()
                    }
                }
                self.presentAuth()
            }
        }
    }

}
