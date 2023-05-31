//
//  UnisonApp.swift
//  Unison
//
//  Created by David's MBP16 on 19.02.23.
//

import SwiftUI

@main
struct UnisonApp: App {
    
    init() {
        Dependencies.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
