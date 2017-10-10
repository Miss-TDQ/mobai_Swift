//
//  ViewController.swift
//  mobai-swift
//
//  Created by ecaray_mac on 2017/10/10.
//  Copyright © 2017年 Miel_TDQ. All rights reserved.
//

import UIKit
import CoreMotion
class ViewController: UIViewController {

    var animator:UIDynamicAnimator?
    var gravity:UIGravityBehavior?
    
    var motionManager:CMMotionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        
        self.creatBallWithImageArr(arr: ["01","02","03","04"], diameter: 40)
        self.initGyroManager()
    }
    
//    创建小球
    func creatBallWithImageArr(arr:Array<String>,diameter:CGFloat)->Void{
        
        var ballViewArr:Array<UIView> = Array.init()
        
        for index in 0...arr.count-1{
            let img:UIImageView = UIImageView.init(frame: CGRect(x:CGFloat(arc4random_uniform(UInt32(self.view.bounds.size.width - diameter))),y:0,width:diameter,height:diameter))
            img.image = UIImage.init(named: arr[index])
            img.layer.masksToBounds = true;
            img.layer.cornerRadius = diameter/2;
            self.view.addSubview(img)
            ballViewArr.append(img)
        }
        
        animator = UIDynamicAnimator.init(referenceView: self.view)
        
        gravity = UIGravityBehavior.init(items: ballViewArr)
        animator?.addBehavior(gravity!)
        
        let collision:UICollisionBehavior = UICollisionBehavior.init(items: ballViewArr)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collision)
        
        let dyItem:UIDynamicItemBehavior = UIDynamicItemBehavior.init(items: ballViewArr)
        dyItem.allowsRotation = true
        dyItem.elasticity = 0.8
        animator?.addBehavior(dyItem)
    }
    
//    创建传感器
    func initGyroManager()  {
        motionManager = CMMotionManager.init()
        motionManager?.deviceMotionUpdateInterval = 0.01
        
        motionManager?.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (m, e) in
            //            print("pitch:+\(m!.attitude.pitch)--->roll:+\(m!.attitude.roll)")
            let rotation:Double = atan2((m!.attitude.pitch), (m!.attitude.roll))
            self.gravity?.angle = CGFloat(rotation)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        motionManager?.stopDeviceMotionUpdates()
        print("vc 销毁...")
    }
}

