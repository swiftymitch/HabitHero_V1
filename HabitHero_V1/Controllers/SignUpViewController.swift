//
//  SignUpViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 03.03.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.isModalInPresentation = true
        
        // Button Setup
        
        signUpButton.layer.cornerRadius = 5
        signUpButton.layer.masksToBounds = true
        
        // Dataentry Fields Setup
        firstNameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        firstNameTextField.attributedPlaceholder = NSAttributedString(
            string: "First Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        lastNameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        lastNameTextField.attributedPlaceholder = NSAttributedString(
            string: "Last Name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        emailTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        passwordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        confirmPasswordTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(
            string: "Confirm Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
         
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginController = self.storyboard!.instantiateViewController(withIdentifier: K.LoginViewControllerID) as! LoginViewController
        
        self.present(loginController, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e) // maybe add a pop up here!
                } else {
                    let habitsOverviewController = self.storyboard!.instantiateViewController(withIdentifier: K.HabitsOverviewViewControllerID) as! HabitsOverviewViewController
                    
                    self.present(habitsOverviewController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
}
