//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import SwiftUI
import Combine

struct Row: Identifiable {
    let id = UUID()
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0 ..< self.rows, id: \.self) { row in
                    HStack {
                        ForEach(0 ..< self.columns, id: \.self) { column in
                            self.content(row, column)
                        }
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct GridView: View {
    @EnvironmentObject var gridViewModel: GridViewSelectionModel
    
    var frame: CGSize = .zero
    let onDetail: (String, KeyInt, Bool, Bool) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            GridStack(rows: 5, columns: 5) { row, col in
                LetterView(info: self.gridViewModel.letters[KeyInt(row: row, column: col)] ?? RectLetterInfo.star, text: self.gridViewModel.letters[KeyInt(row: row, column: col)]?.char ?? "", showBorder: self.gridViewModel.selectedIndexes.contains(KeyInt(row: row, column: col)), isLast: self.gridViewModel.isLast(key: KeyInt(row: row, column: col)), highlightShape: self.gridViewModel.showAndAnimateNextLetter(key: KeyInt(row: row, column: col)))
                .onTapGesture {
                    self.onDetail(self.gridViewModel.letters[KeyInt(row: row, column: col)]?.char ?? "", KeyInt(row: row, column: col), self.gridViewModel.isLast(key: KeyInt(row: row, column: col)), self.gridViewModel.contains(key: KeyInt(row: row, column: col)))
                }
            }
        }
    }
    
    func randomLetter() -> String {
        String("AAAAABBCCDDDDEEEEEEFGGHIIIJKLLLMMMMNNNNOOOOPPPQRRRRSSSSTTTTUVWWXYZ".randomElement() ?? "E")
    }
    
    func letterMoved(location: CGPoint, letter: String) -> DragState {
        return .unknown
    }
    
    func letterDropped(location: CGPoint, trayIndex: Int, letter: String) {
    }
}
