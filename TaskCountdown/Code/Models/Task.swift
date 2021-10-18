//
//  Task.swift
//  TaskCountdown
//
//  Created by Rizky Mashudi on 18/10/21.
//

import Foundation

//TASK TYPE MODEL
struct TaskType {
    let symbolName: String
    let typeName: String
}

//TASK MODEL
struct Task {
    var taskName: String
    var taskDescription: String
    var seconds: Int
    var taskType: TaskType
    
    var timeStamp: Double
}

//COUNTDOWN ENUM
enum countdownState {
    case suspended
    case running
    case paused
}
