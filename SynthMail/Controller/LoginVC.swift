/*
 * Copyright (C) 2023 Recompile.me.
 * All rights reserved.
 */

import UIKit
import MailCore

class LoginVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    
    @IBOutlet weak var emailTxt: UITextField!;
    @IBOutlet weak var passwordTxt: UITextField!;
    @IBOutlet weak var spinner: UIActivityIndicatorView!;
    @IBOutlet weak var errorLabel: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setUpView();
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        var emailAddress = String();
        var password = String();
        MAIL_PARAMETERS.imapSession = MCOIMAPSession();
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
        } else {
            setupImapSession(emailAddress: emailAddress, password: password);
            spinner.isHidden = false;
            spinner.startAnimating();
            log.info(emailAddress);
            log.info(password);
            connect();
        }
    }
    
    func setupImapSession(emailAddress: String, password: String) {
        
        MAIL_PARAMETERS.mailLogin = emailAddress;
        MAIL_PARAMETERS.mailPassword = password;
        let mailServerDomain = emailAddress.components(separatedBy: "@")[1];
        log.info(mailServerDomain);
        if MAIL_PARAMETERS.mailServerHostname.contains(mailServerDomain) {
            log.info("The mailer hostname already exists!!!");
        } else {
            MAIL_PARAMETERS.mailServerHostname.append(mailServerDomain);
        }
        log.info(MAIL_PARAMETERS.mailServerHostname);
        
        MAIL_PARAMETERS.imapSession?.hostname = MAIL_PARAMETERS.mailServerHostname;
        MAIL_PARAMETERS.imapSession?.port = UInt32(MAIL_PARAMETERS.imapPort); //UInt32(imapPort);
        MAIL_PARAMETERS.imapSession?.username = MAIL_PARAMETERS.mailLogin;
        MAIL_PARAMETERS.imapSession?.password = MAIL_PARAMETERS.mailPassword;
        MAIL_PARAMETERS.imapSession?.connectionType = .TLS;
    }
    
    func connect() {
        
        if let accountCheck = MAIL_PARAMETERS.imapSession?.checkAccountOperation() {
            accountCheck.start { err in
                if let error = err {
                    log.error(error.localizedDescription);
                    self.displayErrorMessage(error: error.localizedDescription);
                    self.spinner.isHidden = true;
                    self.spinner.stopAnimating();
                } else {
                    log.info("Successful IMAP connection!");
                    self.spinner.isHidden = true;
                    self.spinner.stopAnimating();
                    self.performSegue(withIdentifier: "MessagesAndFoldersVC", sender: nil);
                }
            }
        }
        
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
        
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: MAIL_PARAMETERS.smackPurplePlaceholder]);
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: MAIL_PARAMETERS.smackPurplePlaceholder]);
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
