//
//  AlertService.swift
//  MemeEditor
//
//  Created by Mrunalini Gaddam on 8/11/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class AlertService{
    
//    static func showAlert(style: UIAlertController.Style, title: Srting?, message: String?,actions:)
    
    static func showAlert(style: UIAlertController.Style, title: String?, message: String?,
                          actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .cancel, handler: nil)],completion: (() -> Swift.Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions{
            alert.addAction(action)}
    }
}
