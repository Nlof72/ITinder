//
//  AuthController.swift
//  ITinder
//
//  Created by Nikita on 26.04.2022.
//

import UIKit
import Alamofire

class AuthController: UIViewController {
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func OnRegisterButtonClick(_ sender: UIButton) {
//        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "aboutYou") as UIViewController
//                nextViewController.modalPresentationStyle = .fullScreen
//                self.present(nextViewController, animated: false, completion: nil)

        if let email = EmailField.text, let password = PasswordField.text{
            userAction.registerUser(email: email, password: password){
                let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "aboutYou") as UIViewController
                        nextViewController.modalPresentationStyle = .fullScreen
                        self.present(nextViewController, animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func OnLoginClick(_ sender: UIButton) {
        if let email = EmailField.text, let password = PasswordField.text{
            userAction.loginUser(email: email, password: password)
        }
    }
}
