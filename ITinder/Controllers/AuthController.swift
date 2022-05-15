//
//  AuthController.swift
//  ITinder
//
//  Created by Nikita on 26.04.2022.
//

import UIKit
import Alamofire

class AuthController: UIViewController {
    @IBOutlet weak var EmailField: UITextField!{
        didSet{
            ErrorField.text = ""
        }
    }
    @IBOutlet weak var PasswordField: UITextField!{
        didSet{
            ErrorField.text = ""
        }
    }
    @IBOutlet weak var ConfirmPasswordField: UITextField!{
        didSet{
            ErrorField.text = ""
        }
    }
    @IBOutlet weak var Loading: UIView!
    @IBOutlet weak var ErrorField: UILabel!
    
    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let email = UserDefaults.standard.string(forKey: "email"){
            EmailField.text = email
        }
        if let password = UserDefaults.standard.string(forKey: "password"){
            PasswordField.text = password
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func OnRegisterButtonClick(_ sender: UIButton) {
//        let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "aboutYou") as UIViewController
//                nextViewController.modalPresentationStyle = .fullScreen
//                self.present(nextViewController, animated: false, completion: nil)
        self.view.addSubview(self.Loading)
        if let email = EmailField.text, let password = PasswordField.text{
            if email.isEmail(){
                userAction.registerUser(email: email, password: password){
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "aboutYou") as UIViewController
                            nextViewController.modalPresentationStyle = .fullScreen
                            self.present(nextViewController, animated: false, completion: nil)

                }
            }else{
                ErrorField.text = "Email не соответсвует стандартам"
            }

        }
    }
    
    @IBAction func OnLoginClick(_ sender: UIButton) {
        self.view.addSubview(self.Loading)
        //self.Loading.frame.size.height = (self.view.bounds.height)
        
        if let email = EmailField.text, let password = PasswordField.text{
            
            if email.isEmail(){
                userAction.loginUser(email: email, password: password, errorCallBack: {
                    self.ErrorField.text = "Неправильный пароль или логин"
                }){
                    let nextViewController = self.storyBoard.instantiateViewController(withIdentifier: "MainBar") as UIViewController
                        nextViewController.modalPresentationStyle = .fullScreen
                        self.present(nextViewController, animated: false, completion: nil)
                }
            }else{
                ErrorField.text = "Email не соответсвует стандартам"
            }
        }
    }

}


let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)

extension String {
    func isEmail() -> Bool {
        return __emailPredicate.evaluate(with: self)
    }
}

extension UITextField {
    func isEmail() -> Bool {
        return self.text?.isEmail() ?? false
    }
}
