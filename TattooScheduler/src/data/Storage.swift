//
//  Storage.swift
//  TattooScheduler
//
//  Created by Artem on 10.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

protocol Storage {
    func getEvents(for: Date)->[CalendarEvent]
    func loadEvents()
    func store(event ev: CalendarEvent)
    func update(event ev: CalendarEvent)
    func remove(event ev: CalendarEvent)
}
