//
//  CustomBox.swift
//  CubeAR
//
//  Created by Maksim  on 28.10.2022.
//


import SwiftUI
import RealityKit
import Combine

class CustomEntityA: Entity, HasModel, HasAnchoring, HasCollision {
    
    var collisionSubs: [Cancellable] = []
    
    required init(color: UIColor) {
        super.init()
        
        self.components[CollisionComponent.self] = CollisionComponent(
            shapes: [.generateBox(size: [0.2,0.2,0.2])],
            mode: .trigger,
            filter: CollisionFilter(group: CollisionGroup(rawValue: 1), mask: CollisionGroup(rawValue: 1))
        )
        
        self.components[ModelComponent.self] = ModelComponent(
            mesh: .generateBox(size: [0.2,0.2,0.2]),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

extension CustomEntityA {
    func addCollisions(scene: RealityKit.Scene? = nil) {
        var myScene = scene
        
        if scene == nil {
            guard let _ = self.scene else { return }
            myScene = self.scene
        }
        
        collisionSubs.append(myScene!.subscribe(to: CollisionEvents.Began.self, on: self) { event in
            guard let boxA = event.entityA as? CustomEntityA else { return }
            boxA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
            }
        )
        
        collisionSubs.append(myScene!.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
            guard let boxA = event.entityA as? CustomEntityA else { return }
            boxA.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
            }
        )
    }
}




//class CustomEntityB: Entity, HasModel, HasAnchoring, HasCollision {
//
//    var collisionSubs: [Cancellable] = []
//
//    required init(color: UIColor) {
//        super.init()
//
//        self.components[CollisionComponent.self] = CollisionComponent(
//            shapes: [.generateSphere(radius: 0.03)],
//            mode: .trigger,
//            filter: CollisionFilter(group: CollisionGroup(rawValue: 2), mask: CollisionGroup(rawValue: 2))
//        )
//
//        self.components[ModelComponent.self] = ModelComponent(
//            mesh: .generateSphere(radius: 0.03),
//            materials: [SimpleMaterial(
//                color: color,
//                isMetallic: false)
//            ]
//        )
//    }
//
//    convenience init(color: UIColor, position: SIMD3<Float>) {
//        self.init(color: color)
//        self.position = position
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}



//extension CustomEntityB {
//    func addCollisions(scene: RealityKit.Scene? = nil) {
//        var myScene = scene
//        if scene == nil{
//            guard let _ = self.scene else {
//                return
//            }
//
//            myScene = self.scene
//        }
//
//        collisionSubs.append(myScene!.subscribe(to: CollisionEvents.Began.self, on: self) { event in
//            guard let sphere = event.entityA as? CustomEntityB else {
//                return
//            }
//
//            sphere.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
//
//        })
//        collisionSubs.append(myScene!.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
//            guard let sphere = event.entityA as? CustomEntityB else {
//                return
//            }
//            sphere.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
//        })
//    }
//}
