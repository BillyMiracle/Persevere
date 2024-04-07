//
//  ARCardIconAndLabelCell.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/21.
//

import UIKit

class ARCardIconAndLabelCell: UITableViewCell {

    private lazy var iconView: UIImageView = {
        UIImageView()
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.adjustsFontSizeToFitWidth = true
        return label
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
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        selectionStyle = .none
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellHeight = contentView.bounds.height
        let cellWidth = contentView.bounds.width
        
        if cellHeight > kborderWidth * 2 && cellWidth >= cellHeight {
            let iconViewLength = min(kimageMaxWidth, cellHeight - 2 * kborderWidth)
            iconView.frame = CGRect(x: kborderWidth, y: (cellHeight - iconViewLength) / 2,  width:iconViewLength, height: iconViewLength)
            let titleLabelHeight = titleLabel.font.lineHeight
            titleLabel.frame = CGRect(x: iconView.frame.maxX + kborderWidth, y: (cellHeight - titleLabelHeight) / 2, width: cellWidth - 2 * kborderWidth - iconView.frame.maxX, height: titleLabelHeight)
        } else {
            iconView.frame = CGRect.zero
            titleLabel.frame = CGRect.zero
        }
    }
}

// MARK: bindData
extension ARCardIconAndLabelCell {
    public func bindData(icon: UIImage?, title: NSString?) {
        iconView.image = icon
        titleLabel.text = title as String?
    }
}
