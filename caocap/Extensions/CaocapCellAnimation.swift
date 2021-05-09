//
//  caocapCellAnimation.swift
//  caocap
//
//  Created by Azzam AL-Rashed on 03/08/1440 AH.
//  Copyright © 1440 Ficruty. All rights reserved.
//

import UIKit

class Pulsing: CALayer {
    var animationGroup = CAAnimationGroup()
    
    var initialPulseScale:Float = 0
    var nextPulseAfter:TimeInterval = 0
    var animationDuration:TimeInterval = 1.5
    var radius:CGFloat = 200
    var numberOfPulses:Float = Float.infinity
    
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init (numberOfPulses:Float = Float.infinity, radius:CGFloat, position:CGPoint) {
        super.init()
        
        self.backgroundColor = UIColor.black.cgColor
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.radius = radius
        self.numberOfPulses = numberOfPulses
        self.position = position
        
        self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        self.cornerRadius = radius
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "pulse")
            }
        }
    }
    
    
    private func createScaleAnimation () -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
        scaleAnimation.toValue = NSNumber(value: 1)
        scaleAnimation.duration = animationDuration
        return scaleAnimation
    }
    
    private func createOpacityAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        return opacityAnimation
    }
    
    private func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration + nextPulseAfter
        self.animationGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        self.animationGroup.timingFunction = defaultCurve
        
        self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]
    }
    
}

func loadingAnimation(image: UIImageView){
    image.layer.sublayers?.removeAll()
    let maskView = UIImageView()
    maskView.image = UIImage(named: "loading mask")
    
    maskView.frame = image.bounds
    maskView.contentMode = .scaleAspectFit
    image.mask = maskView
    let pulse = Pulsing(numberOfPulses: 25, radius: image.frame.width * 1.5 , position: CGPoint(x: 0, y: 0))
    pulse.animationDuration = 0.8
    pulse.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
    image.layer.insertSublayer(pulse, at:  0)
}
