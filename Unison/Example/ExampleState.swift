//
//  ExampleState.swift
//  Unison
//
//  Created by David's MBP16 on 19.02.23.
//

import Foundation

struct ExampleState: State {
    let input: String
    let isButtonActive: Bool
    let isLoading: Bool
    
    static let initial = ExampleState(input: "", isButtonActive: false, isLoading: false)
}
