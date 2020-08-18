//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import SwiftUI
import Combine

struct AnimatableWordSection: View {
    var numberLetters: Int = 0
    var word: String = ""
    @EnvironmentObject var letterSection: LetterSectionModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach ( 0 ..< self.letterSection.letterIDs.count) { index in
                    Rectangle().fill(Color.red)
                        .overlay(
                            //                                            Text("self.word[index]")
                            Text(String(Array(self.word)[index]))
                                .foregroundColor(.white).customSize(size: 20)
                            
                    ).frame(width: geometry.size.width / CGFloat(self.numberLetters), height: geometry.size.height)
                }
            }.padding(0)
        }
    }
}

struct RectLetterInfo: Equatable {
    
    var char: String
    var hue: Double = .random(in: 0 ... 1)
    var nextIndex = 0
    var color: Double = 0.3
    var backgroundColor: Color = .white
    var isCorrect = false
    
    init(char: String, color: Double = 0.3) {
        self.char = char
        self.color = color
        backgroundColor = Color(hue: hue, saturation: 0.5, brightness: 0.8, opacity: 1)
    }

    /// The wedge's start location, as an angle in radians.
    fileprivate(set) var start = 0.0
    /// The wedge's end location, as an angle in radians.
    fileprivate(set) var end = 0.0
    
    static var random: RectLetterInfo {
        return RectLetterInfo(char: "B")
    }
    
    static var star: RectLetterInfo {
        return RectLetterInfo(char: "*", color: 0.5)
    }
    
    static func == (lhs: RectLetterInfo, rhs: RectLetterInfo) -> Bool {
        return lhs.char == rhs.char
    }

}

class ColorsInterval {
    var colors: [Double] = [0.3, 0.4, 0.5, 0.6, 0.7]
    var indexColor: Int = 0
    
    var nextColor: Double {
        indexColor += 1
        if indexColor >= colors.count {
            indexColor = 0
        }
        return colors[indexColor]
    }
}

extension RectLetterInfo {
        
    var startColor: Color {
        return Color(hue: hue, saturation: 0.4, brightness: 0.8)
    }
    
    var endColor: Color {
        return Color(hue: hue, saturation: 0.7, brightness: 0.9)
    }
            
    var foregroundGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [startColor, endColor]),
            center: .center,
            startAngle: .radians(start),
            endAngle: .radians(end)
        )
    }
}

//views
struct LetterShapeView: View {
    var letterInfo: RectLetterInfo
    var showGreenColor = false
    
    var body: some View {
        // Fill the wedge shape with its chosen gradient.
        GeometryReader { geometry in
            Rectangle().fill(self.showGreenColor ? Color.green : self.letterInfo.backgroundColor).frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center).overlay(
            Text(self.letterInfo.char).arialSize().foregroundColor(.white).padding(0)
        )
        }
    }
}

