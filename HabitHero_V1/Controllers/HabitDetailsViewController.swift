//
//  HabitDetailsViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 13.03.23.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    
    @IBOutlet weak var habitNameLabel: UILabel!
    
    var habitLabel = "Label Name"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        habitNameLabel.text = habitLabel
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
