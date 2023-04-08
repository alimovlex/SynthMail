//
//  LoginVC.swift
//  Smack
//
//  Created by robot on 4/30/21.
//  Copyright © 2021 robot. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    // Outlets
    
    @IBOutlet weak var emailTxt: UITextField!;
    @IBOutlet weak var passwordTxt: UITextField!;
    @IBOutlet weak var spinner: UIActivityIndicatorView!;
    
    let smackPurplePlaceholder = #colorLiteral(red: 0.2588235294, green: 0.3294117647, blue: 0.7254901961, alpha: 0.5);
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpView();
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden = false;
        spinner.startAnimating();
        
        guard let email = emailTxt.text, emailTxt.text != ""
            else {
                return;
        }
        
        guard let password = passwordTxt.text, passwordTxt.text != ""
            else {
                return;
        }
        
    }
    
    func setUpView() {
        spinner.isHidden = true;
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing));
        view.addGestureRecognizer(tap);
        emailTxt.delegate = self;
        passwordTxt.delegate = self;
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder]);
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder]);
    }
    
    //hiding the keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTxt:
            textField.resignFirstResponder();
            passwordTxt.becomeFirstResponder();
        case passwordTxt:
            textField.resignFirstResponder();
            loginPressed(self);
        default:
            break;
        }
     return true
    }
    
}
