//
//  HabitDetailsViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 13.03.23.
//

import UIKit
import FSCalendar

class HabitDetailsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    private var calendar: FSCalendar!
    
    var selectedHabit: Habit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details" // Set the navigation bar title to "Details"
        
        // Remove the text of the back button in the navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        setupCalendar()
    }
    
    private func isHabitCompleted(on date: Date) -> Bool {
        guard let habit = selectedHabit else { return false }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: date)
        
        let isCompleted = habit.completionStatus[dateString] ?? false
        return isCompleted
    }
    
    private func isHabitScheduled(on date: Date) -> Bool {
        guard let habit = selectedHabit else { return false }
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let day = days[weekday - 1]
        
        let isScheduled = habit.frequency[day] ?? false
        return isScheduled
    }
    
    private func setupCalendar() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.appearance.headerTitleColor = UIColor(named: K.AppColors.white)
        calendar.appearance.weekdayTextColor = UIColor(named: K.AppColors.white)
        calendar.appearance.todayColor = UIColor(named: K.AppColors.cyan)
        calendar.appearance.titleTodayColor = .white
        calendar.appearance.selectionColor = .systemGreen
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.borderRadius = 0
        calendar.allowsMultipleSelection = true
        view.addSubview(calendar)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if isHabitCompleted(on: date) {
            return .systemGreen
        } else if isHabitScheduled(on: date) && date <= Date() {
            return .systemRed
        } else if date <= Date() {
            return .lightGray
        } else {
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if isHabitCompleted(on: date) || (isHabitScheduled(on: date) && date <= Date()) {
            return .white
        } else {
            return nil
        }
    }
    
}
