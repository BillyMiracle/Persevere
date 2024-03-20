//
//  BPARTaskCardView.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/20.
//

import UIKit

class BPARTaskCardView: UIView {
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

extension BPARTaskCardView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0, 1, 2, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IconLabelCell", for: indexPath)
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayCell", for: indexPath)
            
            return cell
        default:
            return UITableViewCell.init()
        }
    }
}
