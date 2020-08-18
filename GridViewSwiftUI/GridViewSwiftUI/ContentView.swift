//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import SwiftUI

private var sharedGrid = GridViewSelectionModel()
private var sharedRing = LetterSectionModel()

struct ContentView: View {
    var body: some View {
//        return Text.init("dasda")
    return    GeometryReader { geometry in

        GridView(onDetail: { string, key, isLast, contains   in
            withAnimation(.spring()) {
                if isLast {
                    sharedRing.removeLastLetter()
                }

                if !sharedRing.wordEnabled {
                    if !isLast {
                        if !contains {
                            sharedRing.addLetterAt(RectLetterInfo(char: string))
                        }
                    }
//                    self.isSubmitEnabled = sharedRing.wordEnabled
                    sharedGrid.selectIndex(key: key)
                }
            }
        }).environmentObject(sharedGrid)
            .frame(width: geometry.size.width > 450 ? CGFloat(550) : geometry.size.width, height: geometry.size.height > 1000 ? 500 : geometry.size.height/2)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
