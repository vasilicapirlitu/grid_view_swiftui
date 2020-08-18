//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import SwiftUI


enum DragState {
    case unknown
    case good
    case bad
}


struct LetterView: View {
    
    @State private var dragAmount = CGSize.zero
    @State private var dragState = DragState.unknown
    @State var animateShape: Bool = false

    let info: RectLetterInfo
    var text: String
    var hue: Double = .random(in: 0 ... 1)
    /// The wedge's start location, as an angle in radians.
    fileprivate(set) var start = 0.0
    /// The wedge's end location, as an angle in radians.
    fileprivate(set) var end = 0.0
    
    var showBorder: Bool
    
    var showBorderNextLetter: Bool = false
    var isLast: Bool
    var animateBorder: Bool = false
    var highlightShape: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if self.highlightShape {
                    Text(self.text).overlay(
                        RoundedRectangle(cornerRadius: 10).fill(self.info.backgroundColor)
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center)
                            .border(Color.blue, width: self.animateShape ? 0 : 6)
                            .cornerRadius(10)
                            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false)).onAppear(){
                                self.animateShape.toggle()
                        }
                    )
                } else {
                    if self.isLast {
                        Text(self.text).overlay(
                            RoundedRectangle(cornerRadius: 10).fill(self.info.backgroundColor)
                                .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center)
                                .border(Color.blue, width: self.animateBorder ? 0 : 4)
                                .cornerRadius(10)
                        )
                    }
                    else {
                        if self.showBorder {
                            Text(self.text).overlay(
                                RoundedRectangle(cornerRadius: 10).fill(self.info.backgroundColor)
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center)
                                    .border(Color.red, width: self.animateBorder ? 0 : 4)
                                    .cornerRadius(10)
                            )
                        } else {
                            Text(self.text).overlay(
                                RoundedRectangle(cornerRadius: 10).fill(self.info.backgroundColor)
                                    .frame(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8, alignment: .center)
                                    .cornerRadius(10)
                            )
                        }
                    }
                }
                Text(self.text).arialSize().foregroundColor(Color.white)
            }
        }
    }
}

