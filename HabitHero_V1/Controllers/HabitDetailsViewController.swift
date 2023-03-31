//
//  HabitDetailsViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 13.03.23.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

protocol HabitDetailsDelegate: AnyObject {
    func habitDetailsViewController(_ controller: HabitDetailsViewController, didUpdateHabit habit: Habit)
}

class HabitDetailsViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    private var calendar: FSCalendar!
    
    var selectedHabit: Habit?
    
    weak var delegate: HabitDetailsDelegate?
    
    var completionHandler: ((Habit) -> Void)?
    
    private var selectedDates: [Date] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        
        setupCalendar()
    }
    
    private func isHabitCompleted(on date: Date) -> Bool {
        guard let habit = selectedHabit else { return false } // Remove .habit here
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let isCompleted = habit.completionStatus[dateString] ?? false
        return isCompleted
    }

    
    private func isHabitScheduled(on date: Date) -> Bool {
        guard let habit = selectedHabit else { return false } // Remove .habit here
        
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
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            if let habit = selectedHabit {
                var updatedCompletionStatus = habit.completionStatus
                updatedCompletionStatus[dateString] = !isHabitCompleted(on: date)
                
                selectedHabit = Habit(id: habit.id,
                                      title: habit.title,
                                      createdAt: habit.createdAt,
                                      updatedAt: habit.updatedAt,
                                      frequency: habit.frequency,
                                      completionStatus: updatedCompletionStatus)
                
                // Update the habit in Firebase
                updateHabitInFirebase(habit: selectedHabit!)
                
                delegate?.habitDetailsViewController(self, didUpdateHabit: selectedHabit!)
                
                if isHabitCompleted(on: date) {
                    if let index = selectedDates.firstIndex(of: date) {
                        selectedDates.remove(at: index)
                    }
                } else {
                    selectedDates.append(date)
                }
                
                calendar.reloadData()
            }
        }
    }

    
    func updateHabitInFirebase(habit: Habit) {
        let db = Firestore.firestore()
        let habitRef = db.collection("habits").document(habit.id)
        
        habitRef.updateData([
            "title": habit.title,
            "frequency": habit.frequency,
            "createdAt": habit.createdAt,
            "updatedAt": habit.updatedAt,
            "completionStatus": habit.completionStatus
        ])
        
        completionHandler?(habit)
        
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
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .current {
            if selectedDates.contains(date) {
                calendar.select(date)
            } else {
                calendar.deselect(date)
            }
        }
    }
    
}
