import UIKit

final class BreathAnimator: NSObject, CAAnimationDelegate {
    
    let duration: Double
    let repeatCount: Float
    let autoreverse: Bool
    
    init(duration: Double, repeatCount: Float, autoreverse: Bool) {
        self.duration = duration
        self.repeatCount = repeatCount
        self.autoreverse = autoreverse
    }
    
    func animate(breathIn: Bool, layers: [CALayer], delegate: CAAnimationDelegate?) {
        layers.enumerated().forEach { i, layer in
            layer.add(generateAnimationSet(breathIn: breathIn, factor: i, count: layers.count, delegate: i == 0 ? delegate : nil), forKey: nil)
        }
    }
    
    private func generateAnimationSet(breathIn: Bool, factor: Int, count: Int, delegate: CAAnimationDelegate?) -> CAAnimationGroup {
        if(breathIn)
        {
            let rotationFactor = (2*CGFloat.pi/360) * CGFloat(factor)
            let axis = generateAnchorPoint(spherePos: Double(factor), count: Double(count))
            
            let anchoring = CABasicAnimation(keyPath: "anchorPoint")
            anchoring.toValue = [axis.x, axis.y]
            
            let rotating = CABasicAnimation(keyPath: "transform.rotation.z")
            rotating.toValue = 3*CGFloat.pi - rotationFactor
            
            let scaling = CABasicAnimation(keyPath: "transform.scale")
            scaling.toValue = 5
            
            let animationSet = CAAnimationGroup()
            animationSet.repeatCount = repeatCount
            animationSet.fillMode = CAMediaTimingFillMode.forwards
            animationSet.isRemovedOnCompletion = false
            animationSet.autoreverses = autoreverse
            animationSet.animations = [rotating, scaling, anchoring]
            
            [anchoring, rotating, scaling, animationSet].forEach{
                $0.setTiming(with: duration, timingName: .easeOut)
            }
            
            animationSet.delegate = delegate
            return animationSet
        }
        else
        {
            let rotationFactor = -(2*CGFloat.pi/360) * CGFloat(factor)
            let axis = generateAnchorPoint(spherePos: Double(factor), count: Double(count))
            
            let anchoring = CABasicAnimation(keyPath: "anchorPoint")
            anchoring.toValue = CGPoint(x: 0.5, y: 0.5)
            
            let rotating = CABasicAnimation(keyPath: "transform.rotation.z")
            rotating.toValue = -(3*CGFloat.pi - rotationFactor)
            
            let scaling = CABasicAnimation(keyPath: "transform.scale")
            scaling.toValue = 1
            
            let animationSet = CAAnimationGroup()
            animationSet.repeatCount = repeatCount
            animationSet.fillMode = CAMediaTimingFillMode.forwards
            animationSet.isRemovedOnCompletion = false
            animationSet.autoreverses = autoreverse
            animationSet.animations = [rotating, scaling, anchoring]
            
            [anchoring, rotating, scaling, animationSet].forEach{
                $0.setTiming(with: duration, timingName: .easeInEaseOut)
            }
            
            animationSet.delegate = delegate
            return animationSet
        }
    }
    
    private func generateAnchorPoint(spherePos: Double, count: Double) -> (x: Double, y: Double) {
        let sen = (sin(((360 * spherePos)/count) * Double.pi / 180) + 1) / 2
        let coss = (cos(((360 * spherePos)/count) * Double.pi / 180) + 1) / 2
        return (x: coss, y: sen)
    }
}

extension CAAnimation {
    func setTiming(with duration: Double, timingName: CAMediaTimingFunctionName) {
        self.duration = duration
        self.timingFunction = CAMediaTimingFunction(name: timingName)
    }
}
