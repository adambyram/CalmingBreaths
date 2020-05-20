import UIKit

final class BreathViewController: UIViewController, CAAnimationDelegate {
    
    var generator: BreathLayerGenerator?
    var animatorOut: BreathAnimator?
    var animatorIn: BreathAnimator?
    var animatorFinish: BreathAnimator?
    var animatorStart: BreathAnimator?
    var layers: Array<CAShapeLayer>?
    var breathCount: Int = -1
    var maxBreathCount: Int = 7
    var breathIn: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        generator = BreathLayerGenerator(center: view.center)
        animatorOut = BreathAnimator(duration: 4, repeatCount: 0, autoreverse: false)
        animatorIn = BreathAnimator(duration: 3, repeatCount: 0, autoreverse: false)
        animatorFinish = BreathAnimator(duration: 2, repeatCount: 0, autoreverse: false)
        animatorStart = BreathAnimator(duration: 1, repeatCount: 0, autoreverse: true)
        
        setupBreath()
    }
    
    private func setupBreath(){
        self.layers = generator?.generateLayers(numberOfLayers: 6)
        self.layers!.forEach { view.layer.addSublayer($0) }
        
        animatorStart?.animate(breathIn: true, layers: layers!, delegate: self)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        print("Finished \(breathCount) - In: \(breathIn)")
        if(breathCount == -1) {
            breathCount = 0
            breathIn = false
            sleep(2)
        }
        
        if(breathCount > maxBreathCount) {
            self.dismiss(animated: true) {
                
            }
            return
        }
        print("Finished \(breathCount) - In: \(breathIn)")
        
        breathIn = !breathIn
        
        if(breathIn && breathCount == maxBreathCount) {
            breathCount = breathCount + 1
            animatorFinish?.animate(breathIn: true, layers: layers!, delegate: self)
            return
        }
        
        if(breathIn && breathCount >= 1) {
            sleep(1)
        } else {
            //sleep(2)
        }
        
        if(breathIn) {
         //   DispatchQueue.main.async {
            breathCount = breathCount + 1
                self.animatorIn!.animate(breathIn: true, layers: self.layers!, delegate: self)
         //   }
        } else {
         //   DispatchQueue.main.async {
                self.animatorOut!.animate(breathIn: false, layers: self.layers!, delegate: self)
         //   }
        }
    }
}
    
