//
//  SQLiteStorage.swift
//  TattooScheduler
//
//  Created by Artem on 10.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit
import SQLite3

class SQLiteStorage: Storage {

    var db: OpaquePointer?
    let dateFormatter = DateFormatter()
    let fileURL: URL
    
    var events:[CalendarEvent] = []
    
    internal let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
    internal let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    init() {
        
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
        
        fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("test.sqlite")
        
        let fileManager = FileManager()
        if !fileManager.fileExists(atPath: fileURL.absoluteString) {
            fileManager.createFile(atPath: fileURL.absoluteString, contents: Data(), attributes: [:])
        }
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "create table if not exists events (id integer primary key autoincrement, date datetime, data text)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
        
        self.loadEvents()
    }
    
    deinit {

    }
    
    func loadEvents() {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "select id, data from events", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int64(statement, 0)
            print("id = \(id); ", terminator: "")
            
            if let cString = sqlite3_column_text(statement, 1) {
                let name = String(cString: cString)
                
                let eventData = name.data(using: .utf8)!
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let event = try! decoder.decode(CalendarEvent.self, from: eventData)
                event.id = Int(id)
                self.events.append(event)
                
                print("name = \(name)")
            } else {
                print("name not found")
            }
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    func store(event ev: CalendarEvent) {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "insert into events (date, data) values (?, ?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, dateFormatter.string(from: ev.date!), -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(ev)
        let json = String(data: data, encoding: .utf8)!
        
        if sqlite3_bind_text(statement, 2, json, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting foo: \(errmsg)")
        } else {
            print("INSERT OK!")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        ev.id = getLastId()//Int(sqlite3_last_insert_rowid(statement))
        events.append(ev)
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    func update(event ev: CalendarEvent) {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "update events set date=(?), data=(?) where id=(?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
        }
        
        if sqlite3_bind_text(statement, 1, dateFormatter.string(from: ev.date!), -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding: \(errmsg)")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(ev)
        let json = String(data: data, encoding: .utf8)!
        
        if sqlite3_bind_text(statement, 2, json, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 3, Int32(ev.id)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating: \(errmsg)")
        } else {
            print("UPDATE OK!")
        }
        
        //events.append(ev)
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    func getLastId() -> Int {
        var id: Int = 0
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "select max(id) from events", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        if sqlite3_step(statement) == SQLITE_ROW {
            id = (Int)(sqlite3_column_int64(statement, 0))
            print("id = \(id); ", terminator: "")
        }
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        return id;
    }
    
    func remove(event ev: CalendarEvent) {
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, "delete from events where id=(?)", -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
        }
        
        if sqlite3_bind_int(statement, 1, Int32(ev.id)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding foo: \(errmsg)")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure deleting : \(errmsg)")
        } else {
            print("DELETE OK!")
        }
        
        events = events.filter {$0.id != ev.id}
        
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        statement = nil
        
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
    }
    
    public func getEvents(for date: Date)->[CalendarEvent] {
        var result: [CalendarEvent] = []
        result = events.filter {
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let itemYear = calendar.component(.year, from: $0.date!)
            let itemMonth = calendar.component(.month, from: $0.date!)
            let itemDay = calendar.component(.day, from: $0.date!)

            return year == itemYear && month == itemMonth && day == itemDay
        }
        return result
    }
}
