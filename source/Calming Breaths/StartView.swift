//
//  StartView.swift
//  Calming Breaths
//
//  Created by Adam Byram on 5/16/20.
//  Copyright © 2020 Matter Reactor. All rights reserved.
//

import SwiftUI

struct ViewControllerHolder {
    weak var value: UIViewController?
}


struct ViewControllerKey: EnvironmentKey {
    static var defaultValue: ViewControllerHolder { return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController ) }
}

extension EnvironmentValues {
    var viewController: ViewControllerHolder {
        get { return self[ViewControllerKey.self] }
        set { self[ViewControllerKey.self] = newValue }
    }
}

extension UIViewController {
    func present<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder builder: () -> Content) {
        // Must instantiate HostingController with some sort of view...
        let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
        toPresent.modalPresentationStyle = style
        // ... but then we can reset rootView to include the environment
        toPresent.rootView = AnyView(
            builder()
                .environment(\.viewController, ViewControllerHolder(value: toPresent))
        )
        self.present(toPresent, animated: true, completion: nil)
    }
}

struct StartView: View {
    @State var isPresented: Bool = false
    
    @Environment(\.viewController) private var viewControllerHolder: ViewControllerHolder
    private var viewController: UIViewController? {
        self.viewControllerHolder.value
    }
    
    var body: some View {
        Button(action: {
            //self.isPresented = true
            self.viewController?.present(style: .fullScreen) {
                BreathViewControllerWrapper()
            }
        }, label: {
            Text("Start")
        })
        .sheet(isPresented: self.$isPresented) {
            BreathViewControllerWrapper()
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
