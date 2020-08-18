//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import Foundation
import Combine


struct KeyInt: Hashable, Equatable {
    var row: Int
    var column: Int
    
    static var random: KeyInt {
        return KeyInt(row: 0, column: 0)
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}


class GridViewSelectionModel: ObservableObject {
    var isSelected: Bool = false
    var wordSelected = ""
    
    private var _letters = [KeyInt: RectLetterInfo]()
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var nextID = 0
    var nextChoosenID = 0
    var isHelpHidden = true {
        willSet {
            objectWillChange.send()
        }
    }
    
    var selectedIndexes = [KeyInt]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var correctKeys = [KeyInt]()
    
    var letterIDs = [KeyInt]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var letters: [KeyInt: RectLetterInfo] {
        get {
            return _letters
        }
        set {
            objectWillChange.send()
            _letters = newValue
        }
    }
    
    init() {
        setLetters(word: "adsadsada")
    }
    
    func reset() {
        if !letterIDs.isEmpty {
            letterIDs = []
            letters = [:]
        }
        nextChoosenID = 0
    }
    
    func selectIndex(key: KeyInt) {
        if let isSelected = self.isSelected(key: key) {
            if isLast(key: key) {
                removeIndex(key: isSelected)
            }
        } else {
            selectedIndexes.append(key)
        }
        nextChoosenID += 1
    }
    
    func isSelected(key: KeyInt) -> KeyInt? {
        guard let index = selectedIndexes.firstIndex(of: key) else { return nil }
        return selectedIndexes[index]
    }
    
    func isLast(key: KeyInt) -> Bool {
        return selectedIndexes.last == key
    }
    
    func contains(key: KeyInt) -> Bool {
        return selectedIndexes.contains(key)
    }
    
    func removeIndex(key: KeyInt) {
        guard let index = selectedIndexes.firstIndex(of: key) else { return }
        selectedIndexes.remove(at: index)
        nextChoosenID -= 1
    }
    
    func removeLastIndex() {
        if selectedIndexes.isEmpty {
            return
        }
        if selectedIndexes.count > 0 {
            selectedIndexes.removeLast()
            nextChoosenID -= 1
        }
    }
    
    func setLetters(word: String) {
        if self.wordSelected != word {
            self.wordSelected = word
            
            var shuffledLetters = word.shuffled().map {String.init($0)}
            let numberLetters = 25 - shuffledLetters.count
            let gridLetters = (0..<numberLetters).map { index -> String in
                var letter: String = ""
                repeat {
                    letter = randomLetter()
                } while (word.contains(letter))
                return letter
            }
            shuffledLetters.append(contentsOf: gridLetters)
            
            let keys = (0..<5).map { i -> [KeyInt] in
                (0..<5).map { j -> KeyInt in
                    return KeyInt(row: i, column: j)
                }
            }
            
            let lettersBuffer = keys.reduce([:]) { res, element -> [KeyInt: RectLetterInfo] in
                var result = res
                result.merge(dict: element.reduce([:]) { res, element -> [KeyInt: RectLetterInfo] in
                    var result = res
                    result[element] = RectLetterInfo(char: shuffledLetters.randomElement() ?? "")
                    return result
                })
                return result
            }
            
            let letterstwo = lettersBuffer.keys.enumerated().reduce([:]) { res, key -> [KeyInt: RectLetterInfo] in
                var result = res
                result[key.element] = RectLetterInfo(char: shuffledLetters[key.offset])
                return result
            }
            
            var lettersStrings = lettersBuffer.keys.enumerated().reduce([:]) { res, key -> [KeyInt: String] in
                var result = res
                result[key.element] =  shuffledLetters[key.offset]
                return result
            }
            
            nextChoosenID = 0
            correctKeys = word.map { ch -> KeyInt in
                let key = (lettersStrings.someKey(forValue: String(ch)) ?? .random)
                lettersStrings.removeValue(forKey: key)
                return key
            }
            
            letters = letterstwo
            letterIDs = Array(letters.keys)
            selectedIndexes = [KeyInt]()
        }
    }
    
    func randomLetter() -> String {
        String("AAAAABBCCDDDDEEEEEEFGGHIIIJKLLLMMMMNNNNOOOOPPPQRRRRSSSSTTTTUVWWXYZ".randomElement() ?? "E")
    }
    
    func showAndAnimateNextLetter(key: KeyInt) -> Bool {
        if correctKeys.isEmpty || isHelpHidden {
            return false
        }
        print(nextChoosenID + 1)
        return correctKeys.firstIndex(of: key) == nextChoosenID + 1
    }
}
