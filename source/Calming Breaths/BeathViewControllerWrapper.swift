import SwiftUI

struct BreathViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = BreathViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<BreathViewControllerWrapper>) -> BreathViewControllerWrapper.UIViewControllerType {

    //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController: BreathViewController = BreathViewController()
        return mainViewController
    }

    func updateUIViewController(_ uiViewController: BreathViewControllerWrapper.UIViewControllerType, context: UIViewControllerRepresentableContext<BreathViewControllerWrapper>) {
        //
    }
}
