//
//  ViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 03.03.23.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Button Setup
        
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
        
        // Modifying the text entry fields
        
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
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e) //present pop up!
                } else {
                    print("User successfully logged in")
                    
                    let navigationViewController = self?.storyboard!.instantiateViewController(withIdentifier: K.NavigationViewControllerID) as! UINavigationController
                    
                    
                    self?.present(navigationViewController, animated: true, completion: nil)
                    
                    /*
                    // can be used if no navigation controller is used
                    let habitsOverviewController = self?.storyboard!.instantiateViewController(withIdentifier: K.HabitsOverviewViewControllerID) as! HabitsOverviewViewController
                     
                    self?.present(habitsOverviewController, animated: true, completion: nil)
                    */
                }
                
            }
        }
        
        
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let signUpController = self.storyboard!.instantiateViewController(withIdentifier: K.SignUpViewControllerID) as! SignUpViewController
        
        self.present(signUpController, animated: true, completion: nil)
        
        
    }
    
}

