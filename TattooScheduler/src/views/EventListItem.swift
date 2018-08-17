//
//  EventListItem.swift
//  TattooScheduler
//
//  Created by Artem on 28.07.2018.
//  Copyright © 2018 Artem. All rights reserved.
//

import UIKit

@IBDesignable
class EventListItem: UITableViewCell {
    
    @IBOutlet weak var eventTypeLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var event: CalendarEvent?
    var controller: EventViewController?
    
    var eventType: String = String()
    var eventTime: String = String()
    var desc: String = String()
    
    var view: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
    }
    
    @IBAction func onTap(_ sender: Any) {
        controller!.edit(event: event!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        
        view.layer.cornerRadius = 20
        
        addSubview(view)
    }
    
    func updateText() {
        eventTypeLabel.text = eventType
        eventTimeLabel.text = eventTime
        descLabel.text = desc
        
        updateBackgroundColor()
    }
    
    func updateBackgroundColor() {
        switch eventType {
        case "Tattoo":
            view.backgroundColor = #colorLiteral(red: 0.9430051813, green: 0.2300890819, blue: 0.2300461844, alpha: 0.5)
            break
        case "Training":
            view.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.5)
            break
        case "Massage":
            view.backgroundColor = #colorLiteral(red: 0.00193524558, green: 1, blue: 0.08592860449, alpha: 0.5)
            break
        case "Consult":
            view.backgroundColor = #colorLiteral(red: 1, green: 0.9663416273, blue: 0.1480508167, alpha: 0.5)
        default:
            break
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EventListItem", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        view?.prepareForInterfaceBuilder()
    }
}
