//
//  DisplayAlertMessage.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 09/05/2021.
//  Copyright © 2021 Ficruty. All rights reserved.
//

import UIKit

func displayAlertMessage(_ message: String, in viewController: UIViewController) {
    let alertController = UIAlertController(title: "sorry".localized(), message: message, preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK".localized(), style: .default)
    alertController.addAction(OKAction)
    viewController.present(alertController, animated: true, completion: nil)
}
