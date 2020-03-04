//
//  EventManager.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/20/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation
import FileProvider

protocol EventManagerObserver {
    func eventDidUpdate()
}
class EventManager {
    
    static let shared = EventManager()

    private let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private let eventQueue = DispatchQueue(label: "com.mbulat.waitFor.eventsQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem, target: nil)
    let jsonFilePath: URL
    let fileManager = FileManager.default

    
    let activeEventKey = "ActiveEvent"

    var observers = [EventManagerObserver]()
    
    private init() {
        jsonFilePath = documentsDirectoryPath.appendingPathComponent("Events.json")
        if fileManager.fileExists(atPath: jsonFilePath.path) {
            print("Events file already exists")
        } else {
            fileManager.createFile(atPath: jsonFilePath.path, contents: nil, attributes: nil)
        }
    }

    func getActiveEvent(completion: @escaping (Event?)->()) {
        if let activeEventIdString = UserDefaults.standard.value(forKey: activeEventKey) as? String,
            let activeEventId = UUID(uuidString: activeEventIdString) {
            getEvents { (events) in
                if let event = events.first(where: {$0.id == activeEventId}) {
                    completion(event)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func setActiveEvent(_ event: Event) {
        UserDefaults.standard.set(event.id.uuidString, forKey: activeEventKey)
    }
    
    func getEvents(completionHandler: @escaping ([Event])->()) {
        eventQueue.async {
            do {
                let jsonData = try Data(contentsOf: self.jsonFilePath)//Data(contentsOf: self.jsonFilePath)
                let events = try JSONDecoder().decode([Event].self, from: jsonData)
                completionHandler(events)//[Event(title: "Распределение", startDate: date("2019-09-01T10:44:00+0000"), endDate: date("2021-08-31T10:44:00+0000"))]
            } catch(let error) {
                print("Error reading data from json. \(error.localizedDescription)")
                completionHandler([])
            }
        }
    }
    
    func removeEvent(_ event: Event, completionHandler: @escaping ([Event])->()) {
        getEvents { (events) in
            var newEvents = events
            newEvents.removeAll(where: {$0.id == event.id})
            completionHandler(newEvents)
            self.save(events: newEvents)
        }
    }
    
    func addEvent(_ event: Event, completionHandler: @escaping ([Event])->()) {
        getEvents { (events) in
            var newEvents = events
            newEvents.append(event)
            completionHandler(newEvents)
            self.save(events: newEvents)
        }
    }
    
    private func save(events: [Event]) {
        eventQueue.async(group: nil, qos: .userInitiated, flags: .barrier) {
            do {
                let jsonData = try JSONEncoder().encode(events)
                try jsonData.write(to: self.jsonFilePath)
//                let file = try FileHandle(forWritingTo: self.jsonFilePath)
//                file.write(jsonData)
//                try file.close()
                print("JSON data was written to teh file successfully!")
            } catch let error {
                print("Couldn't write to file: \(error.localizedDescription)")
            }
        }
    }

    private func date(_ fromString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:fromString)!
    }
}
