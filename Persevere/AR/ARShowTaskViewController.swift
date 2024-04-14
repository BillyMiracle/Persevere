//
//  ARShowTaskViewController.swift
//  Persevere
//
//  Created by 张博添 on 2024/4/15.
//

import UIKit
import ARKit

@objcMembers
@objc(BPARShowTaskViewController)
class ARShowTaskViewController: UIViewController {
    /// 返回按钮
    var backButton: UIBarButtonItem {
        let backButton = UIBarButtonItem(image: UIImage(named: "NavBack"), style: .plain, target: self, action: #selector(pressBackButton))
        backButton.tintColor = UIColor.white
        return backButton
    }
    /// 标题
    var titleView: BPNavigationTitleView {
        BPNavigationTitleView(title: "AR展示任务", andColor: nil, andShouldShowType: false)
    }
    
    // MARK: 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = titleView
        // Do any additional setup after loading the view.
    }

}
// MARK: 私有方法

extension ARShowTaskViewController {
    
    /// 点击返回按钮
    @objc private func pressBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
