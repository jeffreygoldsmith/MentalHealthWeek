//
//  main.swift
//  MentalHealthWeek
//
//  Created by Russell Gordon on 1/12/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation

struct Supervisor
{
    var activity : Activity
    var name : String
    
    init(activity: Activity, name: String)
    {
        self.activity = activity
        self.name = activity.name
    }
}

struct Activity
{
    var studentNames : [String]
    var name : String
    var personCap : Int
    var supervisorName : String
    
    init(studentNames: [String], name: String, personCap: Int, supervisorName : String)
    {
        self.studentNames = studentNames
        self.name = name
        self.personCap = personCap
        self.supervisorName = supervisorName
    }
}

struct Student
{
    var email: String
    var timestamp: String
    var activities: [String]
    
    init(email: String, timestamp: String, activities: [String])
    {
        self.email = email
        self.timestamp = timestamp
        self.activities = activities
    }
}

struct Advisor
{
    var students : [Student]
    
    init(students: [Student])
    {
        self.students = students
    }
}

var activities : [Activity] = [
    Activity(studentNames: [""], name: "Sleep In", personCap: 500, supervisorName: "Mr. Fitz"),
    Activity(studentNames: [""], name: "Casual Breakfast", personCap: 160, supervisorName: "Ms. Totten"),
    Activity(studentNames: [""], name: "Physical Activity", personCap: 50, supervisorName: "Mr. T/ Mr. S"),
    Activity(studentNames: [""], name: "Relaxation", personCap: 160, supervisorName: "Fr. Donkin"),
    Activity(studentNames: [""], name: "Academic Management", personCap: 30, supervisorName: "Fr. D and NVH(Monday) KU (Wed-Fri) TH"),
    Activity(studentNames: [""], name: "Yoga", personCap: 20, supervisorName: "Ms. McPhedran"),
    Activity(studentNames: [""], name: "Animal Therapy", personCap: 16, supervisorName: "Ms. Kaye/Fitz"),
    Activity(studentNames: [""], name: "Massage", personCap: 12, supervisorName: "Ms."),
]

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

let gradeChoiceNum = [27, 28, 28, 29]
let activityChoiceOffset = 12
var columnDescriptors : [String] = []
var descriptorLookup : [String] = []

for (number, line) in reader.enumerated()
{
    if number == 0
    {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        for (column, descriptor) in columnDescriptors.enumerated()
        {
            descriptorLookup.append(descriptor) // Build descriptor lookup table
        }
    }
    
    if number == 14
    {
        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
        
        var studentEmail = columnDescriptors[5]
        var studentGrade = columnDescriptors[9]
        
        print(studentEmail)
        
        if let studentGradeInt = Int(studentGrade)
        {
            if (studentGradeInt == 12)
            {
                let index = studentGradeInt - 9
                let gradeChoiceOffset = gradeChoiceNum[index] // An offset to get to the correct selection of survey choices
                var offset = 0
                
                
                for k in 0...index - 1 // Get the total offset of survey choices so we have the right set
                {
                    offset += gradeChoiceNum[k]
                }
                
                var previousDayCharacter : Character = "M"
                var activityRankings : [Int] = []
                
                for i in 0...gradeChoiceOffset - 1
                {
                    let currentChoiceIndex = activityChoiceOffset + offset + i
                    //var currentChoice = columnDescriptors[currentChoiceIndex]
                    
                    let currentDay = descriptorLookup[currentChoiceIndex]
                    let currentDayCharacter = currentDay[currentDay.startIndex]
                    
                    if (currentDayCharacter != previousDayCharacter || i == gradeChoiceOffset - 1)
                    {
                        if (i == gradeChoiceOffset - 1)
                        {
                            if let activityRank = Int(columnDescriptors[currentChoiceIndex])
                            {
                                activityRankings.append(activityRank)
                            }
                        }

                        print(activityRankings)
                        activityRankings = []
                    }
                    
                    if let activityRank = Int(columnDescriptors[currentChoiceIndex])
                    {
                        activityRankings.append(activityRank)
                    }
                    
                    previousDayCharacter = currentDayCharacter
                }
            }
        }
    } else {
//        columnDescriptors = line.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).components(separatedBy: ",")
//        
//        var studentTimestamp = columnDescriptors[3]
//        var studentEmail = columnDescriptors[5]
//        var studentGrade = columnDescriptors[9]
//        var studentAdvisor = columnDescriptors[10]
        
//        if let studentGradeInt = Int(studentGrade)
//        {
//            if (studentGradeInt == 12)
//            {
//                let index = studentGradeInt - 9
//                let gradeChoiceOffset = gradeChoiceNum[index] // An offset to get to the correct selection of survey choices
//                var offset = 0
//                
//                
//                for k in 0...index - 1 // Get the total offset of survey choices so we have the right set
//                {
//                    offset += gradeChoiceNum[k]
//                }
//                
//                for i in 0...gradeChoiceOffset
//                {
//                    print(columnDescriptors[activityChoiceOffset + offset + i])
//                }
//            }
//        }
//        for (column, descriptor) in columnDescriptors.enumerated()
//        {
//            //print("column \(column) : descriptor \(descriptor)")
//        }
    }
}

// Iterate over each line in the file and print to the terminal
//for line in reader {
//    var input = line.trimmingCharacters(in: .whitespacesAndNewlines)
//    var parsedInput = input.characters.split{$0 == "\t"}.map(String.init)
//    
//    if (parsedInput.count > 8 && parsedInput.count < 100)
//    {
//        var studentTimestamp = parsedInput[3]
//        var studentEmail = parsedInput[5]
//        var studentGrade = parsedInput[6]
//        var studentAdvisor = parsedInput[7]
//
//        print(studentTimestamp)
//        print(studentEmail)
//        print(studentGrade)
//        print(studentAdvisor)
//        print("")
//        
//    }
//}

