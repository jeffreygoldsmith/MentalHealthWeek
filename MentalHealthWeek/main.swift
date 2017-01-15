//
//  main.swift
//  MentalHealthWeek
//
//  Created by Russell Gordon on 1/12/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation

struct Activity
{
    var weekdays : [[String]]
    var name : String
    var shortName : String
    var personCap : Int
    var supervisorName : String
    
    init(weekdays: [[String]], shortName: String, name: String, personCap: Int, supervisorName : String)
    {
        self.weekdays = weekdays
        self.name = name
        self.shortName = shortName
        self.personCap = personCap
        self.supervisorName = supervisorName
    }
}

extension Activity: Equatable
{
    static func == (lhs: Activity, rhs: Activity) -> Bool
    {
        return
            lhs.name == rhs.name &&
            lhs.shortName == rhs.shortName &&
            lhs.personCap == rhs.personCap &&
            lhs.supervisorName == rhs.supervisorName
    }
}

struct Student
{
    var activities: [String]
    var email: String
    var advisor: String
    
    init(activities: [String], email: String, advisor: String)
    {
        self.activities = activities
        self.email = email
        self.advisor = advisor
    }
}


/// Read text file line by line
class LineReader
{
    let path: String
    
    fileprivate let file: UnsafeMutablePointer<FILE>!
    
    init?(path: String) {
        self.path = path
        
        file = fopen(path, "r")
        
        guard file != nil else { return nil }
        
    }
    
    var nextLine: String? {
        var line:UnsafeMutablePointer<CChar>? = nil
        var linecap:Int = 0
        defer { free(line) }
        return getline(&line, &linecap, file) > 0 ? String(cString: line!) : nil
    }
    
    deinit {
        fclose(file)
    }
}

extension LineReader: Sequence {
    func  makeIterator() -> AnyIterator<String> {
        return AnyIterator<String> {
            return self.nextLine
        }
    }
}

// Read the text file (place in your home folder)
// Path will probably be /Users/student/survey_response_sample.txt
// Obtain the data file on Haiku, Day 37
guard let reader = LineReader(path: "/Users/student/Desktop/github/MentalHealthWeek/survey_response_all_data_new_headers.csv") else {
    exit(0); // cannot open file
}


let gradeChoiceLookup : [Int : Int] = [9 : 0, 10 : 27, 11 : 55, 12 : 83]
let gradeChoiceNum = [27, 28, 28, 29] // 27, 28, 28, 29
let activityChoiceOffset = 12
var columnDescriptors : [String] = []
var descriptorLookup : [String] = []
var emptyArray : [[String]] = [[],[],[],[],[]]
var students : [Student] = []
var activities : [Activity] = [
    Activity(weekdays: emptyArray, shortName: "MathExam", name: "Math Exam", personCap: 500, supervisorName: "Mr. Fitz"),
    Activity(weekdays: emptyArray, shortName: "Sleep", name: "Sleep In", personCap: 500, supervisorName: "Mr. Fitz"),
    Activity(weekdays: emptyArray, shortName: "Breakfast", name: "Casual Breakfast", personCap: 160, supervisorName: "Ms. Totten"),
    Activity(weekdays: emptyArray, shortName: "Gym", name: "Physical Activity", personCap: 50, supervisorName: "Mr. T/ Mr. S"),
    Activity(weekdays: emptyArray, shortName: "Relaxation", name: "Relaxation", personCap: 160, supervisorName: "Fr. Donkin"),
    Activity(weekdays: emptyArray, shortName: "Academics", name: "Academic Management", personCap: 30, supervisorName: "Fr. D and NVH(Monday) KU (Wed-Fri) TH"),
    Activity(weekdays: emptyArray, shortName: "Yoga", name: "Yoga", personCap: 20, supervisorName: "Ms. McPhedran"),
    Activity(weekdays: emptyArray, shortName: "Animals", name: "Animal Therapy", personCap: 16, supervisorName: "Ms. Kaye/Fitz"),
    Activity(weekdays: emptyArray, shortName: "Massage", name: "Massage", personCap: 12, supervisorName: "Ms."),
]
var weekdayLookup : [String : Int] = ["Monday" : 0, "Tuesday" : 1, "Wednesday" : 2, "Thursday" : 3, "Friday" : 4]


func getActivityName (whole: String) -> String  {
    var switchNow = 0
    var charSetup = [Character]()
    var output = ""
    for char in whole.characters {
        if switchNow == 2 {
            charSetup.append(char)
            
        }
        
        if char == "_" {
            switchNow += 1
        }
    }
    output = String(charSetup)
    return output
}

func getActivityDay (whole: String) -> String  {
    var charSetup = [Character]()
    var output = ""
    for char in whole.characters {
        if char == "_" {
            output = String(charSetup)
            return output
        }
        charSetup.append(char)
    }
    return output
}


for (number, line) in reader.enumerated()
{
    if number == 0
    {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        for (column, descriptor) in columnDescriptors.enumerated()
        {
            descriptorLookup.append(descriptor) // Build descriptor lookup table
        }
    } else {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        var studentEmail = columnDescriptors[5]
        var studentGrade = columnDescriptors[9]
        var studentAdvisor = columnDescriptors[10]
        var studentActivities : [String] = []
        
        
        if let studentGradeInt = Int(studentGrade)
        {
            let index = studentGradeInt - 9
            let gradeChoiceOffset = gradeChoiceNum[index] // An offset to get to the correct selection of survey choices
            var offset = gradeChoiceLookup[studentGradeInt]! as Int
            
            var previousDayCharacter : Character = "M"
            var activityRankings : [String] = []
            var dayNames : [String] = []
        
            for i in 0...gradeChoiceOffset - 1 // Iterate of all of the survey choices
            {
                let currentChoiceIndex = activityChoiceOffset + offset + i
                //var currentChoice = columnDescriptors[currentChoiceIndex]
                
                let currentDay = descriptorLookup[currentChoiceIndex]
                
                let currentDayCharacter = currentDay[currentDay.startIndex]
                
                if (currentDayCharacter != previousDayCharacter || i == gradeChoiceOffset - 1)
                {
                    if (i == gradeChoiceOffset - 1)
                    {
                        if let activityRank = String(columnDescriptors[currentChoiceIndex])
                        {
                            activityRankings.append(activityRank)
                            dayNames.append(currentDay)
                        }
                    }
                    
                    for ranking in 1...8
                    {
                        if let currentRankingIndex = activityRankings.index(of: String(ranking))
                        {
                            let currentFullActivityName = dayNames[currentRankingIndex]
                            let currentActivityName = getActivityName(whole: currentFullActivityName)
                            let currentActivityWeekday = getActivityDay(whole: currentFullActivityName)
                            if let weekdayIndex = weekdayLookup[currentActivityWeekday]
                            {
                                if var currentActivity = activities.filter({$0.shortName == currentActivityName }).first
                                {
                                    if (currentActivity.weekdays[weekdayIndex].count < currentActivity.personCap)
                                    {
                                        if let activityIndex = activities.index(of: currentActivity)
                                        {
                                            activities[activityIndex].weekdays[weekdayIndex].append(studentEmail)
                                            studentActivities.append(currentActivity.name)
                                            
                                            break
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    dayNames = []
                    activityRankings = []
                }
                
                if let activityRank = String(columnDescriptors[currentChoiceIndex])
                {
                    activityRankings.append(activityRank)
                    dayNames.append(currentDay)
                }
                
                previousDayCharacter = currentDayCharacter
            }
            
            students.append(Student(activities: studentActivities, email: studentEmail, advisor: studentAdvisor))
        }
    }
}
print(activities)
print(students)

