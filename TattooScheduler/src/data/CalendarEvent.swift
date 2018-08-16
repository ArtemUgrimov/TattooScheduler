//
//  CalendarEvent.swift
//  TattooScheduler
//
//  Created by Artem on 10.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

class CalendarEvent: Codable {
    public var id:Int = 0
    public var date:Date?
    
    struct Properties: Codable {
        var eventType: String = String()
        var description: String = String()
        var additional: [String:String] = [:]
    }
    
    public var properties: Properties = Properties()
    
    init() {
        properties.additional = [:]
    }
}
