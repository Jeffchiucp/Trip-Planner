//
//  ViewController.swift
//  Trip-Planner
//
//  Created by Elmer Astudillo on 10/16/17.
//  Copyright © 2017 Elmer Astudillo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameTF.delegate = self
        self.passwordTF.delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        let user = User(username: usernameTF.text!, password: passwordTF.text!)
        NetworkService.fetch(route: Route.users(), user: user,  httpMethod: HTTPMethods.get) { (data, int) in
            print("The result is \(data) \(String(int))")
            if int == 200
            {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let tripsVC = storyboard.instantiateViewController(withIdentifier: "TripsViewController") as! TripsViewController
                tripsVC.user = user
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(tripsVC, animated: true)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.present(AlertViewController.showAlert(), animated: true, completion: nil)
                }
            }
        }
    }
}

extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the Textfield
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

