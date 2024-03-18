//
//  BPARImageRecognizeViewController.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/19.
//

import UIKit
import ARKit

class BPARImageRecognizeViewController: UIViewController {
    /// 任务数组
    private var taskArray: [TaskModel]
    /// AR view
    private lazy var sceneView: ARSCNView! = {
        let navigationBarHeight = UIDevice.bp_navigationFullHeight()
        let sceneView = ARSCNView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: self.view.bp_width, height: self.view.bp_height - navigationBarHeight))
        return sceneView
    }()
    
    init(taskArray: [TaskModel]) {
        self.taskArray = taskArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}

extension BPARImageRecognizeViewController {
    
}
