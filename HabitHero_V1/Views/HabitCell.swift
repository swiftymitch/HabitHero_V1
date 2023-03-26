//
//  HabitCell.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 07.03.23.
//

import UIKit

class HabitCell: UITableViewCell {

    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    @IBOutlet weak var habitTitle: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var toggleCompletionButton: UIButton!
    
    @IBOutlet weak var resetTodayButton: UIButton!
    
    private var dateLabels: [UILabel] = []
    
    var toggleCompletionHandler: (() -> Void)?
    
    var resetTodayHandler: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabels = [mondayLabel, tuesdayLabel, wednesdayLabel, thursdayLabel, fridayLabel, saturdayLabel, sundayLabel]
        
        mondayLabel.layer.cornerRadius = mondayLabel.frame.width / 2
        mondayLabel.layer.masksToBounds = true
        
        tuesdayLabel.layer.cornerRadius = tuesdayLabel.frame.width / 2
        tuesdayLabel.layer.masksToBounds = true
        
        wednesdayLabel.layer.cornerRadius = wednesdayLabel.frame.width / 2
        wednesdayLabel.layer.masksToBounds = true
        
        thursdayLabel.layer.cornerRadius = thursdayLabel.frame.width / 2
        thursdayLabel.layer.masksToBounds = true
        
        fridayLabel.layer.cornerRadius = fridayLabel.frame.width / 2
        fridayLabel.layer.masksToBounds = true
        
        saturdayLabel.layer.cornerRadius = saturdayLabel.frame.width / 2
        saturdayLabel.layer.masksToBounds = true
        
        sundayLabel.layer.cornerRadius = sundayLabel.frame.width / 2
        sundayLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDateLabels(completionStatus: [String: Bool], getWeekDates: () -> [Date]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        let weekDates = getWeekDates()
        
        for i in 0..<dateLabels.count {
            let date = weekDates[i]
            let dateString = dateFormatter.string(from: date)
            let isCompleted = completionStatus[dateString] ?? false
            
            dateLabels[i].text = dateString
            dateLabels[i].backgroundColor = isCompleted ? .green : .red
        }
    }


    
    @IBAction func toggleCompletionButtonTapped(_ sender: UIButton) {
        toggleCompletionHandler?()
    }
    
    @IBAction func resetTodayButtonTapped(_ sender: UIButton) {
        resetTodayHandler?()
    }
    
    

    
    
}
