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

class HabitsOverviewViewController: UIViewController, MenuControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let settingsVC = SettingsViewController()
    private let profileVC = ProfileViewController()
    private let overallAnalyticsVC = OverallAnalyticsViewController()
    
    private var menu: SideMenuNavigationController?
    
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
        let menuItems = MenuListController(with: SideMenuItems.allCases)
        menuItems.delegate = self
        
        menu = SideMenuNavigationController(rootViewController: menuItems)
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
        addChildControllers()
       
    }
    
    /*
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
    */
    
    private func addChildControllers() {
        addChild(settingsVC)
        addChild(profileVC)
        addChild(overallAnalyticsVC)
        
        view.addSubview(settingsVC.view)
        view.addSubview(profileVC.view)
        view.addSubview(overallAnalyticsVC.view)
        
        settingsVC.view.frame = view.bounds
        profileVC.view.frame = view.bounds
        overallAnalyticsVC.view.frame = view.bounds
        
        settingsVC.didMove(toParent: self)
        profileVC.didMove(toParent: self)
        overallAnalyticsVC.didMove(toParent: self)
        
        settingsVC.view.isHidden = true
        profileVC.view.isHidden = true
        overallAnalyticsVC.view.isHidden = true
    }
    
    @IBAction func sideBarButtonPressed(_ sender: UIBarButtonItem) {
        
        present(menu!, animated: true, completion: nil)
    }
    
    func didSelectMenuItem(named: SideMenuItems) {
        menu?.dismiss(animated: true, completion: nil)
        
        title = named.rawValue
        
        switch named {
        
        case .home:
            settingsVC.view.isHidden = true
            profileVC.view.isHidden = true
            overallAnalyticsVC.view.isHidden = true
            print("Home Menuitem was choosen")
            
        case .analytics:
            settingsVC.view.isHidden = true
            profileVC.view.isHidden = true
            overallAnalyticsVC.view.isHidden = false
            print("Analytics Menuitem was choosen")
            
        case .profile:
            settingsVC.view.isHidden = true
            overallAnalyticsVC.view.isHidden = true
            profileVC.view.isHidden = false
            print("Profile Menuitem was choosen")
            
        case.settings:
            profileVC.view.isHidden = true
            overallAnalyticsVC.view.isHidden = true
            settingsVC.view.isHidden = false
            print("Settings Menuitem was choosen")
        case .logout:
            do {
                try Auth.auth().signOut()
                
                print("User logged out")
                
                let loginController = self.storyboard!.instantiateViewController(withIdentifier: K.LoginViewControllerID) as! LoginViewController
                
                self.present(loginController, animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
}

//MARK:  - Tableview Datasource

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

//MARK:  - Tableview Delegate

extension HabitsOverviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let HabitDetailsVC = storyboard?.instantiateViewController(withIdentifier: K.HabitDetailsViewControllerID) as? HabitDetailsViewController {
            self.navigationController?.pushViewController(HabitDetailsVC, animated: true)
            
            HabitDetailsVC.habitLabel = habits[indexPath.row].name
        
        }
    }
}



