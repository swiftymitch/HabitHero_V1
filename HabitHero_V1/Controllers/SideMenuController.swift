//
//  SideMenuController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 08.03.23.
//

import Foundation
import UIKit

protocol MenuControllerDelegate {
    func didSelectMenuItem(named: SideMenuItems)
}

enum SideMenuItems: String, CaseIterable {
    case home = "Home"
    case profile = "Profile"
    case settings = "Settings"
    case analytics = "Analytics"
    case logout = "Logout"
}

class MenuListController: UITableViewController {
    
    public var delegate: MenuControllerDelegate?
    
    private let menuItems: [SideMenuItems]
    
    init(with menuItems: [SideMenuItems]) {
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UINib(nibName: K.sideMenuNibName, bundle: nil), forCellReuseIdentifier: K.sideMenuCellIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor(named: K.AppColors.cyan)
        view.backgroundColor = UIColor(named: K.AppColors.cyan)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menucell = tableView.dequeueReusableCell(withIdentifier: K.sideMenuCellIdentifier, for: indexPath)
        menucell.textLabel?.text = menuItems[indexPath.row].rawValue
        menucell.textLabel?.textColor = UIColor(named: K.AppColors.white)
        menucell.textLabel?.backgroundColor = UIColor(named: K.AppColors.cyan)
        menucell.backgroundColor = UIColor(named: K.AppColors.cyan)
        menucell.contentView.backgroundColor = UIColor(named: K.AppColors.cyan)
        return menucell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Relay to delegate about menu item selection
        let selectedItem = menuItems[indexPath.row]
        delegate?.didSelectMenuItem(named: selectedItem)
    }
}
