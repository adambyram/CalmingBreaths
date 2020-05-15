import SwiftUI

class HostingController<ContentView> : UIHostingController<ContentView> where ContentView : View {
    
    override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}
