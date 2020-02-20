//
//  Event.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/20/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation

struct Event {
    let title: String
    let startDate: Date
    let endDate: Date

    func durationInSeconds() -> Int {
        return Calendar.current.dateComponents([.second], from: startDate, to: endDate).second ?? 0
    }
}
