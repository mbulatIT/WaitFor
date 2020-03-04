//
//  Event.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/20/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: UUID
    let title: String
    let startDate: Date
    let endDate: Date
    
    init(title: String, startDate: Date, endDate: Date) {
        self.id = UUID()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
    }
}
