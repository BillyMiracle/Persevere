//
//  ARImageRecognizeViewController.swift
//  Persevere
//
//  Created by 张博添 on 2024/3/19.
//

import UIKit
import ARKit

@objcMembers
@objc(BPARImageRecognizeViewController)
class ARImageRecognizeViewController: UIViewController {
    // MARK: 声明属性
    /// 任务数组
    private var taskArray: [TaskModel]
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
    
    // MARK: 初始化
    public init(taskArray: [TaskModel]) {
        self.taskArray = taskArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = titleView
        self.setupDetectionImages()
        self.view.addSubview(sceneView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.runSceneView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

// MARK: 私有方法

extension ARImageRecognizeViewController {
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
    
    /// 运行AR Scene View
    private func runSceneView() {
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors, .resetSceneReconstruction]
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(arWordTrackingConfiguration, options: options)
    }
    
    /// 点击返回按钮
    @objc private func pressBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: ARSCNViewDelegate

extension ARImageRecognizeViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            if let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.referenceImage.name {
                // 找到task
                if let task = self.getTask(name: imageName) {
                    print("识别出来了：\(task)")
                    let width = CGFloat(imageAnchor.referenceImage.physicalSize.height)
                    let height = CGFloat(imageAnchor.referenceImage.physicalSize.height)
                    print("width: \(width) height: \(height)")
                    let plane = SCNPlane(width: width, height: height)
                    plane.materials.first?.diffuse.contents = ARTaskCardView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200), task: task)
                    let planeNode = SCNNode(geometry: plane)
                    planeNode.position = SCNVector3(0, 0, 0)
                    planeNode.eulerAngles.x = -.pi / 2
                    node.addChildNode(planeNode)
                }
            }
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
            if let imageAnchor = anchor as? ARImageAnchor, let imageName = imageAnchor.referenceImage.name {
                node.childNodes.map {
                    $0.removeFromParentNode()
                }
            }
        }
    }
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            
        }
    }
}

extension ARImageRecognizeViewController {
    func getTask(name: String) -> TaskModel? {
        return taskArray.first(where: { $0.name == name })
    }
}
