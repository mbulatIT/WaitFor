//
//  SelectActiveViewController.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 3/5/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class SelectActiveViewController: UIViewController {

    @IBOutlet weak var eventsPickerView: UIPickerView!
    
    private var events = [Event]()
    private var activeEvent: Event?
    private let heightForRow: CGFloat = 30
    
    var selectedEvent: Event {
        return self.events[eventsPickerView.selectedRow(inComponent: 0)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsPickerView.dataSource = self
        eventsPickerView.delegate = self
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        EventManager.shared.getEvents { (events) in
            self.events = events
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        EventManager.shared.getActiveEvent { (event) in
            self.activeEvent = event
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.eventsPickerView.reloadComponent(0)
        }
        // Do any additional setup after loading the view.
    }
}

extension SelectActiveViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        events.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return heightForRow
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let event = events[row]
        let view = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: heightForRow))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width, height: heightForRow ))
        label.font = event.id == activeEvent?.id ? UIFont.boldSystemFont(ofSize: 15) : UIFont.systemFont(ofSize: 15)
        let attributedString = NSMutableAttributedString(string: event.title)
        if activeEvent?.id == event.id {
            let clockAttribute = NSTextAttachment()
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: label.font.pointSize)
            clockAttribute.image = UIImage(systemName: "clock", withConfiguration: imageConfiguration)?.withRenderingMode(.alwaysTemplate)
            let clockString = NSMutableAttributedString(attachment: clockAttribute)
            clockString.addAttributes([.foregroundColor: UIColor.white], range: NSRange(location: 0, length: 1))
            attributedString.append(NSAttributedString(string: " "))
            attributedString.append(clockString)
        }
        label.attributedText = attributedString
        label.textColor = .white
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
}
