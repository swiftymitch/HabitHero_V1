//
//  AddHabitViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 14.03.23.
//

import UIKit

class AddHabitViewController: UIViewController {

    @IBOutlet weak var addHabitScreenLabel: UILabel!
    
    var addHabitScreenLabelText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHabitScreenLabel.text = addHabitScreenLabelText
        view.backgroundColor = .brown
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
