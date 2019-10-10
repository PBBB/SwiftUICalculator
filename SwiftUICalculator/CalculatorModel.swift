//
//  CalculatorModel.swift
//  SwiftUICalculator
//
//  Created by Issac Penn on 2019/10/10.
//  Copyright © 2019 Issac Penn. All rights reserved.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
//    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @Published var brain: CalculatorBrain = .left("0")
    @Published var history: [CalculatorButtonItem] = []
    
    func apply(_ item: CalculatorButtonItem) {
        brain = brain.apply(item: item)
        history.append(item)
    }
}
