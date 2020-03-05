//
//  TimeDifferenceView.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

class TimeDifferenceView: BaseView {

    enum DifferenceType {
        case left
        case spent
    }

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
    
    var differenceType = DifferenceType.left

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
            let timeDifference = NSCalendar.current.dateComponents(components, from: date, to: currentDate).day ?? 0
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        case .weekday:
            let timeDifference = Int((NSCalendar.current.dateComponents(components, from: date, to: currentDate).day ?? 0) / 7)
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        case .month:
            let timeDifference = NSCalendar.current.dateComponents(components, from: date, to: currentDate).month ?? 0
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        case .hour:
            let timeDifference = NSCalendar.current.dateComponents(components, from: date, to: currentDate).hour ?? 0
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        case.minute:
            let timeDifference = NSCalendar.current.dateComponents(components, from: date, to: currentDate).minute ?? 0
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        case .second:
            let timeDifference = NSCalendar.current.dateComponents(components, from: date, to: currentDate).second ?? 0
            switch differenceType {
            case .left:
                return timeDifference > 0 ? 0 : -timeDifference
            case .spent:
                return timeDifference > 0 ? timeDifference : 0
            }
        default:
            return 0
        }
    }

    override func setup() {
        UINib(nibName: "TimeDifferenceView", bundle: nil).instantiate(withOwner: self, options: nil)
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

extension TimeDifferenceView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayType.cellsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        struct ComponentsSet {
            static let Day: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            static let MonthDay: Set<Calendar.Component> = [.day, .month, .hour, .minute, .second]
        }
        let cell = UITableViewCell()
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        switch indexPath.row {
        case 0:
            switch displayType {
            case .day:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .day), component: .day)
            case .monthDay, .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .month), component: .month)
            case .weekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .weekday), component: .weekday)
            }
        case 1:
            switch displayType {
            case .day:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .hour), component: .hour)
            case .monthDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .day), component: .day)
            case .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .weekday), component: .weekday)
            case .weekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .day), component: .day)
            }
        case 2:
            switch displayType {
            case .day:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .minute), component: .minute)
            case .monthDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .hour), component: .hour)
            case .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .day), component: .day)
            case .weekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .hour), component: .hour)
            }
        case 3:
            switch displayType {
            case .day:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .second), component: .second)
            case .monthDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .minute), component: .minute)
            case .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .hour), component: .hour)
            case .weekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .minute), component: .minute)
            }
        case 4:
            switch displayType {
            case .monthDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .second), component: .second)
            case .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .minute), component: .minute)
            case .weekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.Day, requiredComponent: .second), component: .second)
            default:
                cell.textLabel?.text = ""
            }
        case 5:
            switch displayType {
            case .monthWeekDay:
                cell.textLabel?.text = formatedTimeWord(value: calculateDate(ComponentsSet.MonthDay, requiredComponent: .second), component: .second)
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

private extension TimeDifferenceView {
    func formatedTimeWord(value: Int, component: Calendar.Component) -> String {
        switch value % 10 {
        case 0, 5, 6, 7, 8, 9:
            switch component {
            case .day:
                return "\(value) дней"
            case .month:
                return "\(value) месяцев"
            case .weekday:
                return "\(value) недель"
            case .hour:
                return "\(value) часов"
            case .minute:
                return "\(value) минут"
            case .second:
                return "\(value) секунд"
            default:
                return ""
            }
        case 2, 3, 4:
            switch component {
            case .day:
                return "\(value) дня"
            case .month:
                return "\(value) месяца"
            case .weekday:
                return "\(value) недели"
            case .hour:
                return "\(value) часа"
            case .minute:
                return "\(value) минуты"
            case .second:
                return "\(value) секунды"
            default:
                return ""
            }
        case 1:
            switch component {
            case .day:
                return "\(value) день"
            case .month:
                return "\(value) месяц"
            case .weekday:
                return "\(value) неделя"
            case .hour:
                return "\(value) час"
            case .minute:
                return "\(value) минута"
            case .second:
                return "\(value) секунда"
            default:
                return ""
            }
        default:
            return ""
        }
    }

    func formatedMonthWord(value: Int) -> String {
        switch value % 10 {
        case 0, 5, 6, 7, 8, 9:
            return "\(value) дней"
        case 2, 3, 4:
            return "\(value) дня"
        case 1:
            return "\(value) день"
        default:
            return ""
        }
    }
}
