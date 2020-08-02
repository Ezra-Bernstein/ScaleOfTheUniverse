//
//  ViewController.swift
//  ScaleOfTheUniverse
//
//  Created by Ezra Bernstein on 7/31/20.
//  Copyright © 2020 Ezra Bernstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    
//    let material = SCNMaterial()
//    let scene = SCNScene(named: "art.scnassets/Earth2k.dae")!
    
    
    //sphereGeometry.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.5, blue: 0.4, alpha: 1 )
    
//    let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.1))
//    let bigSphere = SCNNode(geometry: SCNSphere(radius: 10.92983833))
    
//    var data: [SCNNode: [String: Any]] = [:]
    var nodeArr: Array<SCNNode> = []
    var strArr: Array<String> = []
    
//    let cameraNode = SCNNode()
    var globalScale = 1.0
    var totalScale = 1.0
    let minRad = 0.1
    var movement = 4
    
    let screenSize: CGRect = UIScreen.main.bounds
    let label = UILabel()
    
    let data: KeyValuePairs = [
        "moon": [
            "imgPath": "art.scnassets/8k_moon.jpg",
            "name": "Moon",
            "radius": 1737,
            "mass": 7.3477e22,
            "dist": 384400
        
        ],
        
        "mercury": [
            "imgPath": "art.scnassets/8k_mercury.jpg",
            "name": "Mercury",
            "radius": 2440,
            "mass": 3.3011e23,
            "dist": 77000000
        
        ],
        
        "venus": [
            "imgPath": "art.scnassets/8k_venus_surface.jpg",
            "name": "Venus",
            "radius": 6052,
            "mass": 4.867e24,
            "dist": 41000000
        
        ],
        
        "mars": [
            "imgPath": "art.scnassets/8k_mars.jpg",
            "name": "Mars",
            "radius": 3390,
            "mass": 6.4171e23,
            "dist": 54600000
        
        ],
        
        
        "earth": [
            "imgPath": "art.scnassets/land_ocean_ice_2048.jpg",
            "name": "Earth",
            "radius": 6370,
            "mass": 5.97e24,
            "dist": 0
        ],
        
        "jupiter": [
            "imgPath": "art.scnassets/PIA19643.jpg",
            "name": "Jupiter",
            "radius": 71492,
            "mass": 1.898e27,
            "dist": 588000000
        ],
        
        "sun": [
            "imgPath": "art.scnassets/Map_of_the_full_sun.jpg",
            "name": "Sun",
            "radius": 696340,
            "mass": 1.989e30,
            "dist": 151810000
        ],
 
        "sirius_a": [
            "imgPath": "art.scnassets/sirius.jpg",
            "name": "Sirius",
            "radius": 1190000,
            "mass": 3.978e30,
            "dist": 81460000000000
    
        ]

    ]
    
    
    //let textNode = SCNNode(geometry: SCNText(string: NSString(string: "TEXT"), extrusionDepth: 0.0))
    //let textNode = SKLabelNode(text: "TEST")
    
//    let earth = SCNNode(geometry: SCNGeometry(sources: SCNScene(named: "Earth2k.scn"), inDirectory: "art.scnassets)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scalePiece))
        sceneView.addGestureRecognizer(pinch)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPiece))
        sceneView.addGestureRecognizer(tap)
        
        
//        sceneView.allowsCameraControl = true
        
        
        
        //camera setup
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0,z: 0)
//        scene.rootNode.addChildNode(cameraNode)
        
        sceneView.scene = scene
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: screenSize.height)
        label.center = CGPoint(x: 100, y: screenSize.height/2)
        label.backgroundColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Name: Earth \nRadius: 6370 km \nMass: 6.4171e23 kg \nDistance from Earth: 0 km"
        self.view.addSubview(label)
        
        //data and loading
//        let newSphereNode = sphereNode.clone()
//        let newBigSphere = bigSphere.clone()
        
        
        for (str, _) in data{
            strArr.append(str)
        }
        
        
        createNodes(data: data)
        
//        earth.position = SCNVector3(2,0, 0)
//        sceneView.scene.rootNode.addChildNode(earth)
        
        
//        let filePath = Bundle.main.path(forResource: "Earth2k", ofType: "scn", inDirectory: "art.scnassets")
//        let earth = SCNReferenceNode(url: URL(fileURLWithPath: filePath!))!
        //earth.scale
//        print(earth)
        
//
//        let earth = SCNReferenceNode(url: URL("art.scnassets/ball.dae"))
//        sceneView.scene.rootNode.addChildNode(earth)
        
//        let earth = SCNScene(named: "art.scnassets/Earth2k.dae")
//        let earthNode = earth?.rootNode.childNode(withName: "Earth2k", recursively: true)
//        print(earthNode)
//        earthNode?.position = SCNVector3Make(0, 0, -0.1)
//        sceneView.scene.rootNode.addChildNode(earthNode!)
//
//        earth.position = SCNVector3(0,10,0)
//        scene.rootNode.addChildNode(earth)
    }
    
    
    
    
    
    
//    @objc func pinchFunc(gesture: UIPinchGestureRecognizer) {
//        print("hit from pinch function")
//    }
//
    
    
    @IBAction func scalePiece(_ gestureRecognizer : UIPinchGestureRecognizer) {   guard gestureRecognizer.view != nil else { return }
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
//            sphereNode.scale = SCNVector3(x: Float(gestureRecognizer.scale), y: Float(gestureRecognizer.scale), z: Float(gestureRecognizer.scale))
//            print(sphereNode.scale)
//
            globalScale = Double(gestureRecognizer.scale)
            scaleNodes()

//            gestureRecognizer.view?.transform = (gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale))!
            
//            gestureRecognizer.scale = 1.0
    }}
    
    @IBAction func tapPiece(_ touch : UITapGestureRecognizer) { guard touch.view != nil else
    {return}
        let touchPoint = touch.location(in: self.view)
        
        
        var right: BooleanLiteralType = false
        
        if touchPoint.x > screenSize.width-150 {
            right = true
             print("right press detected")
            moveNodes(right: right)
        }
        else if touchPoint.x < 150{
            right = false
            print("left press detected")
            moveNodes(right: right)
        }
        
        updateText()
        
        
        
    }
    
    
    func createNodes(data: KeyValuePairs<String, [String: Any]>){
        
        var currX: CGFloat = 0.1
        //var currXSmall: CGFloat = 0.1
        var smallDist: CGFloat = calcSmallDist()
        for (_, nodeData) in data{
            let radius = nodeData["radius"] as! Int
            let doubleRad = Double(radius)/Double(63700)
            let cgRadius = CGFloat(doubleRad)
            let sphereNode = SCNNode(geometry: SCNSphere(radius: cgRadius))
            sphereNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: nodeData["imgPath"] as! String)
            
            let sphereRadius = (sphereNode.geometry as? SCNSphere)!.radius
            if sphereRadius > 0.1 {
                currX += 0.5 + sphereRadius
                sphereNode.position = SCNVector3(-1*(currX),0,-0.5)
                currX += sphereRadius
            }
            else if sphereRadius < 0.1 {
                sphereNode.position = SCNVector3(smallDist,0,-0.5)
                smallDist -= 0.25
                smallDist -= sphereRadius
//                currXSmall += 0.25 + sphereRadius
//                sphereNode.position = SCNVector3(currXSmall,0,-0.5)
//                currX += sphereRadius
                
            }
            else {
                sphereNode.position = SCNVector3(0,0,-0.5)
            }
            print(sphereNode.position)
            print(sphereRadius)
            sceneView.scene.rootNode.addChildNode(sphereNode)
            nodeArr.append(sphereNode)
        }
        
        
    }
    
    func calcSmallDist() -> CGFloat {
        var totalDist: CGFloat = CGFloat(0.0)
        for (_, nodeData) in data {
            let radius = nodeData["radius"] as! Int
            let doubleRad = Double(radius)/Double(63700)
            let cgRadius = CGFloat(doubleRad)
            if cgRadius < 0.1 {
                totalDist += 0.25
                totalDist += cgRadius
            }
        }
        return totalDist
    }
    
    func scaleNodes(){
        for node in nodeArr {
            node.position = SCNVector3(x: node.position.x * Float(globalScale),
                                       y: node.position.y,
                                       z: node.position.z)
            node.scale = SCNVector3(x: node.scale.x * Float(globalScale),
                                       y: node.scale.y * Float(globalScale),
                                       z: node.scale.z * Float(globalScale))
//            print((node.geometry as? SCNSphere)!.radius)
        }
        totalScale *= globalScale
//        print(globalScale)
        
        
    }
    
    
    func moveNodes(right: BooleanLiteralType){
        let originNode = nodeArr[movement]
        
        if right && (movement > 0) {
            let rightNode = nodeArr[movement - 1]
            let xDiff = (rightNode.position.x - originNode.position.x)
            for node in nodeArr{
                node.position.x -= xDiff
            }
            movement -= 1
        }
        else if !right && (movement < nodeArr.count - 1) {
            let leftNode = nodeArr[movement + 1]
            let xDiff = (originNode.position.x - leftNode.position.x)
            for node in nodeArr{
                node.position.x += xDiff
            }
            movement += 1
        }
    }
    
    func updateText(){
        let nodeName: String = strArr[movement]
        var name = ""
        var rad = 0
        var mass = 0.0
        var dist = 0
        for (keyName, nodeData) in data{
            if keyName == nodeName {
                name = nodeData["name"] as! String
                rad = nodeData["radius"] as! Int
                mass = nodeData["mass"] as! Double
                dist = nodeData["dist"] as! Int
            }
        }
        
        label.text = "Name: " + name
        label.text! += "\nRadius: " + String(rad) + "km"
        label.text! += "\nMass: " + String(mass) + "kg"
        label.text! += "\nDistance from Earth: " + String(dist) + "km"
        
    }
    
    
    
    
    
    
    
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
