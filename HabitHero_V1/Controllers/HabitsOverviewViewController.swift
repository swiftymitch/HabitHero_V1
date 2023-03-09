//
//  HabitsOverviewViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 06.03.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import SideMenu

class HabitsOverviewViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    
    var menu: SideMenuNavigationController?
    
    var habits: [Habit] = [
        Habit(name: "Workout", description: "Get Stronger"),
        Habit(name: "Drink 4L Water", description: "To be more hydrated"),
        Habit(name: "Read 4 Pages", description: "To become smarter")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // configuring the tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        // registering the reusable cell (habit items)
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // Configuration of sidemenu
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        
       
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
            
            print("User logged out")
            
            let loginController = self.storyboard!.instantiateViewController(withIdentifier: K.LoginViewControllerID) as! LoginViewController
            
            self.present(loginController, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    
    @IBAction func sideBarButtonPressed(_ sender: UIBarButtonItem) {
        
        present(menu!, animated: true, completion: nil)
    }
    
}

// Sidemenu
class MenuListController: UITableViewController {
    
    
    var items = ["First", "Second", "Third"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(named: K.AppColors.cyan)
        tableView.register(UINib(nibName: K.sideMenuNibName, bundle: nil), forCellReuseIdentifier: K.sideMenuCellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menucell = tableView.dequeueReusableCell(withIdentifier: K.sideMenuCellIdentifier, for: indexPath)
        menucell.textLabel?.text = items[indexPath.row]
        menucell.textLabel?.textColor = UIColor(named: K.AppColors.white)
        menucell.textLabel?.backgroundColor = UIColor(named: K.AppColors.cyan)
        return menucell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // do something
    }
}

extension HabitsOverviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // code
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! HabitCell
        
        cell.habitTitle.text = habits[indexPath.row].name
        //cell.habitDescriptionTextField.text = habits[indexPath.row].description
        return cell
    }
    
    
}

extension HabitsOverviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("go to details page of habit")
    }
}
