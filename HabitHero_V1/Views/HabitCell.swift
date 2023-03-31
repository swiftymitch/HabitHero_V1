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

    override func prepareForReuse() {
        super.prepareForReuse()
        for label in dateLabels {
            label.backgroundColor = .red
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureDateLabels(completionStatus: [String: Bool], weekDates: [Date]) {
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "dd"
        
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd"

        for i in 0..<dateLabels.count {
            let date = weekDates[i]
            let dayString = dayDateFormatter.string(from: date)
            let dateString = fullDateFormatter.string(from: date)
            let isCompleted = completionStatus[dateString] ?? false

            dateLabels[i].text = dayString
            dateLabels[i].backgroundColor = isCompleted ? .green : .red
        }
    }

    
    
    func updateDateLabelBackgroundColor(date: String, color: UIColor) {
        if let dateLabel = dateLabels.first(where: { $0.text == date }) {
            dateLabel.backgroundColor = color
        }
    }
    
    

    
    @IBAction func toggleCompletionButtonTapped(_ sender: UIButton) {
        toggleCompletionHandler?()
    }
    
    @IBAction func resetTodayButtonTapped(_ sender: UIButton) {
        resetTodayHandler?()
    }
    
    

    
    
}
