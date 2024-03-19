//
//  BPARImageRecognizeViewController.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/19.
//

import UIKit
import ARKit

class BPARImageRecognizeViewController: UIViewController {
    // MARK: 声明属性
    /// 任务数组
    private var taskArray: [TaskModel]
    /// AR view
    private lazy var sceneView: ARSCNView! = {
        let navigationBarHeight = UIDevice.bp_navigationFullHeight()
        let sceneView = ARSCNView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: self.view.bp_width, height: self.view.bp_height - navigationBarHeight))
        sceneView.delegate = self
        sceneView.isPlaying = false
        return sceneView
    }()
    /// AR Session
    private lazy var arSession: ARSession = {
        let session = ARSession()
        return session
    }()
    /// AR 配置
    private lazy var arWordTrackingConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.automaticImageScaleEstimationEnabled = true
        return configuration
    }()
    
    // MARK: 私有方法
    init(taskArray: [TaskModel]) {
        self.taskArray = taskArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDetectionImages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: 私有方法

extension BPARImageRecognizeViewController {
    /// 设置检测图片
    private func setupDetectionImages() {
        let tasks = self.taskArray
        var detectionImages = Set<ARReferenceImage>()
        for task in tasks {
            if let taskImageData = task.imageData {
                let taskImage = UIImage(data: taskImageData)
                let refImage = ARReferenceImage((taskImage?.cgImage)!, orientation: .up, physicalWidth: 0.3)
                refImage.name = task.name
                detectionImages.insert(refImage)
            }
        }
        self.arWordTrackingConfiguration.detectionImages = detectionImages
    }
    
    /// 设定AR Scene View
    private func setUpSceneView() {
        
    }
}

// MARK: ARSCNViewDelegate

extension BPARImageRecognizeViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
        }
    }
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
        }
    }
}
