//
//  AuthController.swift
//  ITinder
//
//  Created by Nikita on 26.04.2022.
//

import UIKit
import Alamofire

struct RegisterData: Decodable{
    let accessToken: String
    let accessTokenExpiredAt: String
    let refreshToken: String
    let refreshTokenExpiredAt: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken
        case accessTokenExpiredAt
        case refreshToken
        case refreshTokenExpiredAt
      }
}


class AuthController: UIViewController {
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var ConfirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func OnRegisterButtonClick(_ sender: UIButton) {
        if let email = EmailField.text, let password = PasswordField.text{
            registerUser(email: email, password: password)
        }
    }
    
    @IBAction func OnLoginClick(_ sender: UIButton) {
        
    }
    
    func registerUser(email: String, password: String){
        let parameters: [String: String] = [
            "email": email,
            "password": password,
        ]
        
        debugPrint(parameters)

        AF.request("http://193.233.85.238/itindr/api/mobile/v1/auth/register", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodable(of: RegisterData.self){
            response in
            guard let data = response.value else { return }
            debugPrint("Response: \(data.accessToken)")
            print(data)
        }
    }
}
