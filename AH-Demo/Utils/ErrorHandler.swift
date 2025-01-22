//
//  ErrorHandler.swift
//  AH-Demo
//
//  Created by Harsha on 21/01/2025.
//

import UIKit

/// `ErrorHandler` is the main generic alert class to show error messages accross the app
class ErrorHandler {
    /// Show error alerts
    ///
    /// This function shows alert  as per requirement
    ///
    /// - Parameters:
    ///   - viewController:The `UIViewController` which should show the alert
    ///   - title: `String` which should be used as title, default set to `Error`.
    ///   - message: `String` which will be used as body of the alert.
    ///   - okButtonTitle: `String` which will be used as button title, defailt set to `OK`
    /// - Returns: Nil
    static func showAlert(viewController: UIViewController, title: String = "Error", message: String, okButtonTitle: String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okButtonTitle, style: .default)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
