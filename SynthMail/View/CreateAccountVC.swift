//
//  CreateAccountVC.swift
//  Smack
//
//  Created by robot on 4/30/21.
//  Copyright © 2021 robot. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupView();
    }
    
    @IBAction func createAccntPressed(_ sender: Any) {
        
        spinner.isHidden = false;
        spinner.startAnimating();
        
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil);
    }
    
    func setupView() {
        spinner.isHidden = true;
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing));
               view.addGestureRecognizer(tap);
        usernameTxt.delegate = self;
        emailTxt.delegate = self;
        passTxt.delegate = self;
        
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder]);
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder]);
        passTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder]);
        
    }
    
    
    //hiding the keyboard on return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTxt:
            textField.resignFirstResponder();
            emailTxt.becomeFirstResponder();
        case emailTxt:
            textField.resignFirstResponder();
            passTxt.becomeFirstResponder();
        case passTxt:
            textField.resignFirstResponder();
        default:
            break;
        }
     return true
    }
    
}
