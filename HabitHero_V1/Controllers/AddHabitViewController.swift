//
//  AddHabitViewController.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 22.03.23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class NoHighlightButton: UIButton {
    var isButtonSelected: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        backgroundColor = isButtonSelected ? .cyan : .white
        setTitleColor(isButtonSelected ? .white : .black, for: .normal)
    }
}


class AddHabitViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Habit"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let habitNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Habit Name"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(named: K.AppColors.white)
        textField.backgroundColor = UIColor(named: K.AppColors.grey)
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.cyan, for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dayButtons: [NoHighlightButton] = {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days.map { day in
            let button = NoHighlightButton(type: .system)
            button.setTitle(day, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.backgroundColor = .white
            button.layer.cornerRadius = 4
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()

    private var frequency: [String: Bool] = [
        "Mon": false,
        "Tue": false,
        "Wed": false,
        "Thu": false,
        "Fri": false,
        "Sat": false,
        "Sun": false
    ]
    
    private var completionStatus: [String: Bool] = [:]
    
    
    private let daysStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: K.AppColors.black)
        
        view.addSubview(titleLabel)
        view.addSubview(habitNameTextField)
        view.addSubview(addButton)
        
        // Add targets or actions for buttons if needed, for example:
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.backgroundColor = UIColor(named: K.AppColors.grey)
        
        view.addSubview(daysStackView) // Move this line before setting the constraints
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.title = "Add Habit"
        
        setupConstraints()

        for button in dayButtons {
            daysStackView.addArrangedSubview(button)
        }
        
        
        
        daysStackView.translatesAutoresizingMaskIntoConstraints = false // Add this line
        
        NSLayoutConstraint.activate([
            daysStackView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 32),
            daysStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            habitNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            habitNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            habitNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            daysStackView.topAnchor.constraint(equalTo: habitNameTextField.bottomAnchor, constant: 32),
            daysStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            daysStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.topAnchor.constraint(equalTo: daysStackView.bottomAnchor, constant: 16),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: habitNameTextField.widthAnchor)
        ])
    }
    
    // Function for saving Habit


    func saveHabit(habit: Habit) {
        // Get the current user
        guard let user = Auth.auth().currentUser else { return }

        // Get a reference to the user's habits collection
        let db = Firestore.firestore()
        let habitsRef = db.collection("users").document(user.uid).collection("habits")

        // Save the habit as a new document
        habitsRef.addDocument(data: [
            "id": habit.id,
            "title": habit.title,
            "createdAt": Timestamp(date: habit.createdAt),
            "updatedAt": Timestamp(date: habit.updatedAt),
            "frequency": habit.frequency,
            "completionStatus": habit.completionStatus
            // Add other properties, if needed
        ]) { error in
            if let error = error {
                print("Error adding habit: \(error.localizedDescription)")
            } else {
                print("Habit successfully added")
            }
        }
    }
    
    private func saveNewHabit() {
        // Get the habit name from the text field
        guard let habitName = habitNameTextField.text, !habitName.isEmpty else {
            // Show an error message or alert if the habit name is empty
            return
        }

        // Generate a unique ID for the habit
        let habitID = UUID().uuidString
        let currentDate = Date()

        // Create a habit instance
        let habit = Habit(
            id: habitID,
            title: habitName,
            createdAt: currentDate,
            updatedAt: currentDate,
            frequency: frequency,
            completionStatus: completionStatus// Set the frequency or any other properties as needed
        )

        // Call the saveHabit(habit:) function to save the habit to Firebase
        saveHabit(habit: habit)

        // Pop the AddHabitViewController and go back to the habits overview screen
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addButtonTapped() {
        saveNewHabit()
    }
    
    
    @objc private func dayButtonTapped(_ sender: NoHighlightButton) {
        sender.isButtonSelected.toggle()

        if let title = sender.title(for: .normal) {
            frequency[title] = sender.isButtonSelected
        }
    }


}
