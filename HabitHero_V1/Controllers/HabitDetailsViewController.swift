//
//  HabitDetailsViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 13.03.23.
//

import UIKit

class HabitDetailsViewController: UIViewController {

    @IBOutlet weak var habitTitle: UILabel!
    
    var habitName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        habitTitle.text = habitName
        
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
