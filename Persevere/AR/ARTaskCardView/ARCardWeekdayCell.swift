//
//  ARCardWeekdayCell.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/21.
//

import UIKit

class ARCardWeekdayCell: UITableViewCell {

    private lazy var iconView: UIImageView = {
        UIImageView()
    }()
        
    private lazy var weekdayPickerView: BPWeekDayPickerView = {
        BPWeekDayPickerView()
    }()
        
    private let kborderWidth: CGFloat = 10.0
    private let kimageMaxWidth: CGFloat = 20.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(weekdayPickerView)
        self.selectionStyle = .none
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.addSubview(iconView)
        self.contentView.addSubview(weekdayPickerView)
        self.selectionStyle = .none
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellHeight = self.contentView.bounds.height
        let cellWidth = self.contentView.bounds.width
        if cellHeight > kborderWidth * 2 && cellWidth >= cellHeight {
            let iconViewLength = min(kimageMaxWidth, cellHeight - 2 * kborderWidth)
            iconView.frame = CGRect(x: kborderWidth, y: (cellHeight - iconViewLength) / 2, width: iconViewLength, height: iconViewLength)
            let weekdayPickerHeight = self.bounds.height - kborderWidth
            weekdayPickerView.frame = CGRect(x: iconView.frame.maxX + kborderWidth, y: (cellHeight - weekdayPickerHeight) / 2, width: cellWidth - 2 * kborderWidth - iconView.frame.maxX, height: weekdayPickerHeight)
        } else {
            iconView.frame = CGRect.zero
            weekdayPickerView.frame = CGRect.zero
        }
    }
}
