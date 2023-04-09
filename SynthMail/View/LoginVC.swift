/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    
    @IBOutlet weak var emailTxt: UITextField!;
    @IBOutlet weak var passwordTxt: UITextField!;
    @IBOutlet weak var spinner: UIActivityIndicatorView!;
    @IBOutlet weak var errorLabel: UILabel!;
    
    private var shouldPerformSegue = Bool();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpView();
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        var emailAddress = String();
        var password = String();
        
        if let email = emailTxt.text {
            if email.isEmpty {
                emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor:
                                                                                                    UIColor.red]);
            } else {
                emailAddress = email;
            }
        } else {
            
            emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor:
                                                                                                UIColor.red]);
        }
        
        if let pwd = passwordTxt.text {
            if pwd.isEmpty {
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor:
                                                                                                            UIColor.red]);
            } else {
                password = pwd;
            }
        } else {
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor:
                                                                                                        UIColor.red]);
        }
        log.info(emailAddress.isEmpty);
        log.info(password.isEmpty);
        
        if emailAddress.isEmpty || password.isEmpty {
            log.error("ERROR!!! FALSE CREDENTIALS PROVIDED!!!");
            errorLabel.isHidden = false;
            errorLabel.text = "Unable to connect to the mail server with credentials provided.";
            shouldPerformSegue = false;
        } else {
            mailLogin = emailAddress;
            mailPassword = password;
            let mailServerDomain = emailAddress.components(separatedBy: "@")[1];
            log.info(mailServerDomain);
            if mailServerHostname.contains(mailServerDomain) {
                log.info("The mailer hostname already exists!!!");
            } else {
                mailServerHostname.append(mailServerDomain);
            }
            log.info(mailServerHostname);
            spinner.isHidden = false;
            spinner.startAnimating();
            shouldPerformSegue = true;
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return shouldPerformSegue;
    }
    
    
    func displayErrorMessage(error: String) {
        let error = UIAlertController(title: "Error fetching messages from the mail server.", message: error, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Ok", style: .default);
        error.addAction(confirm);
        self.present(error, animated: true) //showing the URL entrance message
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
        default:
            break;
        }
        return true
    }
    
}
