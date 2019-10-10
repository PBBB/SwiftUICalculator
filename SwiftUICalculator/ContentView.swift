//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by Issac Penn on 2019/10/6.
//  Copyright © 2019 Issac Penn. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    let scale: CGFloat = UIScreen.main.bounds.width / 414
//    @State private var brain: CalculatorBrain = .left("0")
    @ObservedObject private var model = CalculatorModel()
    
    var body: some View {
        VStack (spacing: 12) {
            Spacer()
            Button("History: \(model.history.count)") {
                print(self.model.history)
            }
            Text(model.brain.output)
                .font(.system(size: 76))
                .minimumScaleFactor(0.5)
                .foregroundColor(Color.primary)
                .lineLimit(1)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
//                .padding(.trailing, 24)
            CalculatorButtonPad(model: model)
//                .padding(.bottom)
        }.scaleEffect(scale)
    }
}

struct CalculatorButton: View {
    let fontSize: CGFloat = 38
    let title: String
    let foregroundColorName: String?
    let backgroundColorName: String
    let size: CGSize
    let action :()->Void
    
    
    var body: some View {
        Button(action: action){
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(foregroundColorName != nil ?  Color(foregroundColorName!) : Color.white)
                .frame(width: size.width, height: size.height)
                .background(Color(backgroundColorName))
                .cornerRadius(size.width / 2)
        }
    }
}

struct CalculatorButtonRow: View {
//    @Binding var brain: CalculatorBrain
    var model: CalculatorModel
    let row: [CalculatorButtonItem]
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(title: item.title, foregroundColorName: item.foregroundColorName, backgroundColorName: item.backgroundColorName, size: item.size) {
                    self.model.apply(item)
                }
            }
        }
    }
}

struct CalculatorButtonPad: View {
//    @Binding var brain: CalculatorBrain
    var model: CalculatorModel
    let pad:[[CalculatorButtonItem]] = [ [.command(.clear), .command(.flip), .command(.percent), .op(.divide)], [.digit(7), .digit(8), .digit(9), .op(.multiply)], [.digit(4), .digit(5), .digit(6), .op(.minus)], [.digit(1), .digit(2), .digit(3), .op(.plus)], [.digit(0), .dot, .op(.equal)]]
    var body: some View {
        VStack(spacing: 8) {
            ForEach(pad, id: \.self) { item in
                CalculatorButtonRow(model: self.model, row: item)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
//            ContentView().environment(\.colorScheme, .dark)
//            ContentView().previewDevice("iPad Air (3rd generation)")
        }
    }
}
