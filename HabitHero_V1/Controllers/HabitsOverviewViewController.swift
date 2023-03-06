//
//  HabitsOverviewViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 06.03.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class HabitsOverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
          try Auth.auth().signOut()
            
            let loginController = self.storyboard!.instantiateViewController(withIdentifier: K.LoginViewControllerID) as! LoginViewController
            
            self.present(loginController, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
    }
    
    /*
    @IBAction func backtoLoginScreenButtonPressed(_ sender: UIButton) {
        let loginController = self.storyboard!.instantiateViewController(withIdentifier: K.LoginViewControllerID) as! LoginViewController
        
        self.present(loginController, animated: true, completion: nil)
    }
    */
    
    @IBAction func backToRegisterScreenButton(_ sender: UIButton) {
        let signUpController = self.storyboard!.instantiateViewController(withIdentifier: K.SignUpViewControllerID) as! SignUpViewController
        
        self.present(signUpController, animated: true, completion: nil)
    }
}
