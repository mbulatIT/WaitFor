//
//  EventManager.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/20/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation

protocol EventManagerObserver {
    func eventDidUpdate()
}
class EventManager {

    static let shared = EventManager()
    var observers = [EventManagerObserver]()
    
    private init() {}

    func getEvent() -> Event {
        return Event(title: "Распределение", startDate: date("2019-09-01T10:44:00+0000"), endDate: date("2021-08-31T10:44:00+0000"))
    }
    
    private func date(_ fromString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from:fromString)!
    }
}
