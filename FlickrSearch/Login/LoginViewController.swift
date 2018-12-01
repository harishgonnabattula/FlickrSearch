//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Ninja on 12/1/18.
//  Copyright © 2018 Ninja. All rights reserved.
//


import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var dimissGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.delegate = self
        passwordField.delegate = self
        dimissGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.tapToDismissKeyboard(gesture:)))
        self.view.addGestureRecognizer(dimissGesture)
    }
    
    @IBAction func performLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.isUserInteractionEnabled = false
        
        if validateTextFields() {
            //do Login stuff
            
        }
    }
    
    fileprivate func validateTextFields() -> Bool {
        if userNameField.text?.count == 0 || passwordField.text?.count == 0 {
            print("One/More TextFields is empty!")
            return false
        }
        return true
    }
}

// TextField delegates
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    @objc func tapToDismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        var adjustedFrame = self.view.frame
        adjustedFrame.origin.y -= 30
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.frame = adjustedFrame
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        var adjustedFrame = self.view.frame
        adjustedFrame.origin.y += 30
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.view.frame = adjustedFrame
        }, completion: nil)
    }
}
