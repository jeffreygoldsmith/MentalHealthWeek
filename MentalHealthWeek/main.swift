//
//  main.swift
//  MentalHealthWeek
//
//  Created by Russell Gordon on 1/12/17.
//  Copyright © 2017 Russell Gordon. All rights reserved.
//

import Foundation

struct Supervisor {
    var activity : Activity
    var name : String
    
    init(activity: Activity, name: String)
    {
        self.activity = activity
        self.name = activity.name
    }
}

struct Activity {
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

struct Student {
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

struct Advisor {
    var students : [Student]
    
    init(students: [Student])
    {
        self.students = students
    }
}

/// Read text file line by line
class LineReader {
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
guard let reader = LineReader(path: "/Users/student/Desktop/github/MentalHealthWeek/survey_response_sample.txt") else {
    exit(0); // cannot open file
}

// Iterate over each line in the file and print to the terminal
for line in reader {
    var input = line.trimmingCharacters(in: .whitespacesAndNewlines)
    var parsedInput = input.characters.split{$0 == "\t"}.map(String.init)
    
    if (parsedInput.count > 0)
    {
        print(parsedInput)
    }
}

