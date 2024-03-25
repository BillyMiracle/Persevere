//
//  BPARTaskCardView.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/20.
//

import UIKit

class ARTaskCardView: UIView {
    /// 任务
    private var task: TaskModel
    /// 展示列表
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView.init(frame: self.frame, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ARCardIconAndLabelCell.self, forCellReuseIdentifier: "IconLabelCell")
        tableView.register(ARCardWeekdayCell.self, forCellReuseIdentifier: "WeekdayCell")
        return tableView
    }()
    /// icon 列表
    private let iconArray: [UIImage] = {
        var array = [UIImage]()
        array.append(UIImage.init(named: "ARCardRemindTime")!)  // 0
        array.append(UIImage.init(named: "ARCardDuration")!)    // 1
        array.append(UIImage.init(named: "ARCardWeekday")!)     // 2
        array.append(UIImage.init(named: "ARCardMemo")!)        // 3
        return array
    }()
    
    public init(task: TaskModel) {
        self.task = task
        super.init(frame: CGRect.zero)
    }
    
    public init(frame: CGRect, task: TaskModel) {
        self.task = task
        super.init(frame: frame)
        
        self.addSubview(infoTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ARTaskCardView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1, 2, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconLabelCell", for: indexPath) as! ARCardIconAndLabelCell
            var icon: UIImage?, title: NSString?
            if indexPath.row == 0 { // 任务名称
                let punched = self.task.hasPunched(on: Date())
                icon = punched ?
                        UIImage(named: "ARCardFinished")?.withTintColor(UIColor.systemGreen) :
                        UIImage(named: "ARCardUnfinished")?.withTintColor(UIColor.systemRed)
                title = task.name as NSString
            } else if indexPath.row == 1 { // 提醒时间
                icon = iconArray[0]
                if let reminderTime = task.reminderTime as NSDate? {
                    title = reminderTime.formattedDate(withFormat: BPTimeFormat) as NSString
                } else {
                    title = "全天"
                }
            } else if indexPath.row == 2 { // 持续时间
                icon = iconArray[1]
                title = ""
                if let start = task.startDate as NSDate? {
                    title?.appending(start.formattedDate(withFormat: BPTimeFormat))
                }
                title?.appending(" 到 ")
                if let end = task.endDate as NSDate? {
                    title?.appending(end.formattedDate(withFormat: BPTimeFormat))
                } else {
                    title?.appending("无限期")
                }
            } else if indexPath.row == 4 { // 备注
                icon = iconArray[3]
            }
            cell.bindData(icon: icon, title: title)
            return cell
        case 3:// weekday
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayCell", for: indexPath) as! ARCardWeekdayCell
            cell.bindData(icon: iconArray[2], weekdays: task.reminderDays)
            return cell
        default:
            return UITableViewCell.init()
        }
    }
}
