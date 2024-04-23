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
        if #available(iOS 11.3, *) {
            configuration.planeDetection = .vertical
        }
        if #available(iOS 13.0, *) {
            // 开启景深人员遮挡
            configuration.frameSemantics.insert(.personSegmentationWithDepth)
        }
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
        self.view.addSubview(sceneView)
        self.addTapGestureToSceneView()
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

extension ARShowTaskViewController {
    
    /// 运行AR Scene View
    private func runSceneView() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(arWordTrackingConfiguration)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    /// 点击返回按钮
    @objc private func pressBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: 点击添加任务 Node

extension ARShowTaskViewController {
    /// 添加点击手势
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARShowTaskViewController.addTaskToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func addTaskToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {

        let location = recognizer.location(in: sceneView)
//        let hitTestResults = sceneView.hitTest(location, types: .existingPlaneUsingExtent)
        let raycastQuery: ARRaycastQuery? = sceneView.raycastQuery(from: location, allowing: .existingPlaneInfinite, alignment: .any)
        let hitTestResults: [ARRaycastResult] = sceneView.session.raycast(raycastQuery!)
        if let hitResult = hitTestResults.first, let planeAnchor = hitResult.anchor as? ARPlaneAnchor {
            // 在这里，你可以使用 planeAnchor 获取平面的信息
            let position = planeAnchor.center
            let extent = planeAnchor.extent
            let alignment = planeAnchor.alignment

            print("平面信息：")
            print("位置：\(position)")
            print("范围：\(extent)")
            print("方向：\(alignment)")
            // 获取平面的变换矩阵
            let transform = planeAnchor.transform
            // 获取当前平面相对于地面的旋转
            let rotationMatrix = SCNMatrix4(m11: transform.columns.0.x, m12: transform.columns.1.x, m13: transform.columns.2.x, m14: 0.0,
                                            m21: transform.columns.0.y, m22: transform.columns.1.y, m23: transform.columns.2.y, m24: 0.0,
                                            m31: transform.columns.0.z, m32: transform.columns.1.z, m33: transform.columns.2.z, m34: 0.0,
                                            m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0)

            let euler = rotationMatrix.eulerAngles
            // 获取绕Y轴的旋转角度
            let rotationAngle = euler.y
            // 现在，rotationAngle 包含了平面相对于地面的旋转角度
            print("平面相对于地面的旋转角度: \(rotationAngle) 度")
            
            guard let task = taskArray.last else { return }
            let squareNode = createTaskSquareNode(with: task)
            // Set the node's position to the hit result position
            squareNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                             hitResult.worldTransform.columns.3.y,
                                             hitResult.worldTransform.columns.3.z)
            squareNode.eulerAngles.y = rotationAngle
            // Add the node to the scene
            sceneView.scene.rootNode.addChildNode(squareNode)
            
        } else {
            print("点击位置不在垂直面上")
        }
    }
    
    func createTaskSquareNode(with task: TaskModel) -> SCNNode {
        let width = 0.1
        let height = 0.1
        
        let boxGeometry = SCNBox(width: width, height: height, length: 0.001, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        boxGeometry.materials = [material]
        let squareNode = SCNNode(geometry: boxGeometry)
        
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = ARTaskCardView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200), task: task)
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3(0, 0, 0.0007)
        squareNode.addChildNode(planeNode)
        
        return squareNode
    }
}

extension ARShowTaskViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 检测平面
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
        // 创建平面节点
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.20)
//        plane.materials.first?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode(geometry: plane)
        
        // 转换坐标系
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        // 将节点加到平面
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // 1
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
        let planeNode = node.childNodes.first,
        let plane = planeNode.geometry as? SCNPlane
        else { return }

        // 2
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height

        // 3
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }
    
}

extension SCNMatrix4 {
    var eulerAngles: SCNVector3 {
        get {
            // 将旋转矩阵转换为欧拉角
            return SCNVector3(
                x: atan2(m32, m22),
                y: atan2(-m31, sqrt(m32 * m32 + m33 * m33)),
                z: atan2(m21, m11)
            )
        }
    }
}
