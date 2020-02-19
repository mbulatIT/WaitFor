//
//  SpentTimeView.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class SpentTimeView: BaseView {

    enum DisplayType {
        case day
        case monthDay
        case monthWeekDay
        case weekDay

        fileprivate func cellsCount() -> Int {
            switch self {
            case .day:
                return 4
            case .monthDay, .weekDay:
                return 5
            case .monthWeekDay:
                return 6
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: TableViewWithoutScroll!
    @IBOutlet var view: UIView!

    var displayType: DisplayType = .day {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var date = Date() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var title = "" {
        willSet(value) {
            DispatchQueue.main.async {
                self.titleLabel.text = value
            }
        }
    }
    
    func calculateDate(_ components: Set<Calendar.Component>, requiredComponent: Calendar.Component) -> Int {
        let currentDate = Date()
        switch requiredComponent {
        case .day:
            return abs(NSCalendar.current.dateComponents(components, from: date, to: currentDate).day ?? 0)
        case .weekday:
            return abs(Int((NSCalendar.current.dateComponents(components, from: date, to: currentDate).day ?? 0) / 7))
        case .month:
            return abs(NSCalendar.current.dateComponents(components, from: date, to: currentDate).month ?? 0)
        case .hour:
            return abs(NSCalendar.current.dateComponents(components, from: date, to: currentDate).hour ?? 0)
        case.minute:
            return abs(NSCalendar.current.dateComponents(components, from: date, to: currentDate).minute ?? 0)
        case .second:
            return abs(NSCalendar.current.dateComponents(components, from: date, to: currentDate).second ?? 0)
        default:
            return 0
        }
    }

    override func setup() {
        UINib(nibName: "SpentTimeView", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        clipViewToBounds(view: view)
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = title
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension SpentTimeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayType.cellsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        struct ComponentsSet {
            static let Day: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            static let MonthDay: Set<Calendar.Component> = [.day, .month, .hour, .minute, .second]
        }
        switch indexPath.row {
        case 0:
            switch displayType {
            case .day:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .day)) дня"
            case .monthDay, .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .month)) месяцев"
            case .weekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .weekday)) недель"
            }
        case 1:
            switch displayType {
            case .day:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .hour)) часов"
            case .monthDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .day)) дней"
            case .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .weekday)) недель"
            case .weekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .day)) дней"
            }
        case 2:
            switch displayType {
            case .day:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .minute)) минут"
            case .monthDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .day)) часов"
            case .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .day)) дней"
            case .weekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .day)) часов"
            }
        case 3:
            switch displayType {
            case .day:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .second)) секунд"
            case .monthDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .minute)) минут"
            case .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .hour)) часов"
            case .weekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .minute)) минут"
            }
        case 4:
            switch displayType {
            case .monthDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .second)) секунд"
            case .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .minute)) минут"
            case .weekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.Day, requiredComponent: .second)) секунд"
            default:
                cell.textLabel?.text = ""
            }
        case 5:
            switch displayType {
            case .monthWeekDay:
                cell.textLabel?.text = "\(calculateDate(ComponentsSet.MonthDay, requiredComponent: .second)) секунд"
            default:
                cell.textLabel?.text = ""
            }
        default:
            cell.textLabel?.text = ""
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
}
