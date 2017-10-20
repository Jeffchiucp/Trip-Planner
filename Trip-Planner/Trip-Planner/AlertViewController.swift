//
//  AlertViewController.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/19/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import Foundation
import UIKit

struct AlertViewController
{
    static func showAlert() -> UIAlertController
    {
        let alertController = UIAlertController(title: "Error", message: "Wrong email or password", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return alertController
    }
}
