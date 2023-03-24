//
//  HabitsOverviewViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 06.03.23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import SideMenu

class HabitsOverviewViewController: UIViewController, MenuControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let settingsVC = SettingsViewController()
    private let profileVC = ProfileViewController()
    private let overallAnalyticsVC = OverallAnalyticsViewController()
    
    private var menu: SideMenuNavigationController?
    
    private var habits: [Habit] = []
    
    
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
        
        fetchHabits()
       
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
    
    // Add Habit Button and Navigation to AddHabitViewController
    @IBAction func addHabitButtonPressed(_ sender: UIBarButtonItem) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addHabitViewController = storyboard.instantiateViewController(withIdentifier: K.AddHabitViewControllerID) as! AddHabitViewController
            navigationController?.pushViewController(addHabitViewController, animated: true)
    }
    
    // Add Child Controllers for Sidemenu
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
    
    private func fetchHabits() {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let habitsRef = Firestore.firestore().collection("users").document(currentUserID).collection("habits")

        habitsRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching habits: \(error!)")
                return
            }

            var fetchedHabits: [Habit] = []

            for document in documents {
                let habitDict = document.data()
                if let title = habitDict["title"] as? String,
                   let createdAt = habitDict["createdAt"] as? Timestamp,
                   let updatedAt = habitDict["updatedAt"] as? Timestamp,
                   let frequency = habitDict["frequency"] as? [String: Bool] {

                    let habit = Habit(
                        id: document.documentID,
                        title: title,
                        createdAt: createdAt.dateValue(),
                        updatedAt: updatedAt.dateValue(),
                        frequency: frequency
                    )
                    fetchedHabits.append(habit)
                }
            }

            self.habits = fetchedHabits
            self.tableView.reloadData()
        }
    }
    
    private func formattedFrequencyText(frequency: [String: Bool]) -> String {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let selectedDays = days.filter { frequency[$0] == true }

        if selectedDays.count == 7 {
            return "Everyday"
        } else if selectedDays == ["Mon", "Tue", "Wed", "Thu", "Fri"] {
            return "On Weekdays"
        } else if selectedDays == ["Sat", "Sun"] {
            return "On Weekends"
        } else {
            return selectedDays.joined(separator: ", ")
        }
    }
    
    private func updateDateLabels() {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        let today = Date()
        let calendar = Calendar.current
        
        for i in 0..<days.count {
            let date = calendar.date(byAdding: .day, value: i, to: today)!
            let day = dateFormatter.string(from: date)
            let isCompleted = habitCompletion[day] ?? false
            
            dateLabels[i].text = day
            dateLabels[i].backgroundColor = isCompleted ? .green : .red
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
        let habit = habits[indexPath.row]
        
        cell.habitTitle.text = habits[indexPath.row].title
        cell.frequencyLabel.text = formattedFrequencyText(frequency: habit.frequency) // Set the frequency text here
    
        //cell.habitDescriptionTextField.text = habits[indexPath.row].description
        return cell
    }
}

//MARK:  - Tableview Delegate

extension HabitsOverviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let HabitDetailsVC = storyboard?.instantiateViewController(withIdentifier: K.HabitDetailsViewControllerID) as? HabitDetailsViewController {
            self.navigationController?.pushViewController(HabitDetailsVC, animated: true)
            
            HabitDetailsVC.habitLabel = habits[indexPath.row].title
        
        }
    }
}



