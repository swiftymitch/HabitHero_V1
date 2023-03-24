//
//  habit.swift
//  HabitHero_V1
//
//  Created by Michael Gruber on 06.03.23.
//

import Foundation

struct Habit {
    
    // here go all the properties associated with a habit
    
    // General Data
    let id: String
    let title: String
    let createdAt: Date
    let updatedAt: Date
    let frequency: [String: Bool]
    
    /*
    let color: String
    let frequency: String // maybe an enum? need to choose from 3 options -> maybe this is a computed variable?
    let habitDays: [String] // should be an array
    let reminderTime: String // specific datatype?
    let reminderMessage: String
    */
    
    // Progress-specific data
    /*
    let datesofDaysDone: [String]
    let daysDoneCount: Int
    let consistencyInPercent: Int
    let currentStreak: Int
    let longestStreak: Int
    */
}
