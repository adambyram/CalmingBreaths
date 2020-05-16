//
//  StartView.swift
//  Calming Breaths
//
//  Created by Adam Byram on 5/16/20.
//  Copyright © 2020 Matter Reactor. All rights reserved.
//

import SwiftUI

struct StartView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        Button(action: {
            self.isPresented = true
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
