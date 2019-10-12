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
//    @EnvironmentObject var model: CalculatorModel
    @State private var editingHistory = false
    @State private var showingResult = false
    
    var body: some View {
        VStack (spacing: 12) {
            Spacer()
            Button("History: \(model.history.count)") {
                self.editingHistory = true
            }.sheet(isPresented: $editingHistory) {
//                HistoryView(model: self.model)
                HistoryView(model: self.model, editingHistory: self.$editingHistory)
            }
            Button(action: {
                self.showingResult = true
            }){
                Text(model.brain.output)
//                    .font(.system(size: 76))
                    .minimumScaleFactor(0.5)
                    .foregroundColor(Color.primary)
                    .lineLimit(1)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                //                .padding(.trailing, 24)
            }.alert(isPresented: $showingResult) {
                return Alert(title: Text("\(self.model.historyDetail)"), message: Text("\(self.model.brain.output)"))
            }
            
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
//    @EnvironmentObject var model: CalculatorModel
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

struct HistoryView: View {
    @ObservedObject var model: CalculatorModel
    @Binding var editingHistory: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Close"){
                self.editingHistory = false
            }
            VStack{
                
                Spacer()
                if model.totalCount == 0 {
                    Text("No history")
                } else {
                    HStack {
                        Text("History").font(.headline)
                        Text("\(model.historyDetail)").lineLimit(nil)
                    }
                    HStack {
                        Text("Output").font(.headline)
                        Text("\(model.brain.output)").lineLimit(nil)
                    }
                    
                    Slider(value: $model.slidingIndex, in: 0...Float(model.totalCount), step: 1)
                }
                Spacer()
            }
            .frame(maxWidth:.infinity, alignment: .center)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return Group{
            ContentView()
//            HistoryView(model: CalculatorModel())
//            ContentView().environment(\.colorScheme, .dark)
//            ContentView().previewDevice("iPad Air (3rd generation)")
        }
    }
}
