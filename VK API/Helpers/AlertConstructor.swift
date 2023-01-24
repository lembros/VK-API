//
//  AlertConstructor.swift
//  VK API
//
//  Created by Егор Губанов on 29.09.2022.
//

import UIKit

class AlertConstructor {
    static func alert(withMessage message: String, andTitle title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(okAction)
        
        return alert
    }
}
