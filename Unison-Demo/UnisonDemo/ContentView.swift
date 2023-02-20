//
//  ContentView.swift
//  Unison
//
//  Created by David's MBP16 on 19.02.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ExampleView
            .create(
                update: ExampleUpdate(),
                effectHandler: ExampleEffectHandler() // resolve/inject dependencies
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
