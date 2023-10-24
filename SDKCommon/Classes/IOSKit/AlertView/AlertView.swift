//
//  AlertView.swift
//  abseil
//
//  Created by Felipe Augusto Silva on 13/10/23.
//

import Foundation
import UIKit

import UIKit

public class CustomActionSheet {
    public static func presentActionSheet(from viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        for action in actions {
            actionSheet.addAction(action)
        }

        viewController.present(actionSheet, animated: true, completion: nil)
    }
}


