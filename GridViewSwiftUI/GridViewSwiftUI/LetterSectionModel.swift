//
//  ContentView.swift
//  GridViewSwiftUI
//
//  Created by Pirlitu Vasilica on 18/08/2020.
//  Copyright © 2020 Pirlitu Vasilica. All rights reserved.
//

import Foundation
import Combine

enum Points: Int {
    case minimum = 10
    case medium = 20
    case high = 100
    case none = 0
}

enum CharNumber: Int {
    case minimum = 3
    case medium = 5
    case high = 8
}


class LetterSectionModel: ObservableObject {
    
    private var _letters = [Int: RectLetterInfo]()
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var nextID = 0
    var nextChoosenID = 0
    var word = ""
    
    init() {
        setLetters(word: "abcdedffsad")
    }
    
    var selectedLetters = [Int: RectLetterInfo]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var points = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    var letterIDs = [Int]() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var letters: [Int: RectLetterInfo] {
        get {
            return _letters
        }
        set {
            objectWillChange.send()
            _letters = newValue
        }
    }
    
    func getCurrentLetter(letterID: Int) -> RectLetterInfo  {
        return (letterID > nextChoosenID ? RectLetterInfo.star : letters[letterID]) ?? .star
    }
    
    func reset() {
        if !letterIDs.isEmpty {
            letterIDs = []
            letters = [:]
        }
    }
    
    func setLetters(word: String) {
        self.reset()
        self.resetLettersId()
        nextChoosenID = 0
        
        self.word = word
        letterIDs =  word.enumerated().map{ element -> Int in
            element.offset
        }
        
        letters =  word.enumerated().reduce([:]) { res , element -> [Int: RectLetterInfo] in
            var result = res
            result[element.0] = RectLetterInfo(char: String(element.1))
            return result
        }
        
        selectedLetters = word.enumerated().reduce([:]) { res , element -> [Int: RectLetterInfo] in
            var result = res
            if element.offset > 0 {
                result[element.0] = .star
            } else {
                result[element.0] = RectLetterInfo(char: String(element.1))
            }
            return result
        }
    }
    
    func resetLettersId() {
        nextChoosenID = 0
    }
    
    func addLetter(_ value: RectLetterInfo, notify: Bool = false) {
        let id = nextID
        nextID += 1
        selectedLetters[id] = value
        letterIDs.append(id)
    }
    
    func addLetterAt(_ value: RectLetterInfo) {
        nextChoosenID += 1
        selectedLetters[nextChoosenID] = value
    }
    
    func removeLetter(id: Int, notify: Bool = false) {
        if let indexToRemove = letterIDs.firstIndex(where: { $0 == id }) {
            letterIDs.remove(at: indexToRemove)
            selectedLetters.removeValue(forKey: id)
        }
    }
    
    func removeLastLetter() {
        if nextChoosenID > 0 {
            selectedLetters[nextChoosenID] = .star
            nextChoosenID -= 1
        }
    }
    
    var wordEnabled: Bool {
        word.count == nextChoosenID + 1
    }
    
    var checkWord: Bool {
        let wordArray = letterIDs.map { key -> String in
            letters[key]?.char ?? ""
        }
        
        let choosenArray = selectedLetters.enumerated().map { index, arg -> String in
            let value = selectedLetters[index]
            return value?.char ?? ""
        }
        
        let string = choosenArray.joined()
        return string == self.word
    }
    
    func calculatePoints() -> Bool {
        if checkWord == true {
            switch word.count {
            case 0...3:
                self.points += 10
            case 3...5:
                self.points += 20
            case 5...10:
                self.points += 30
            case let x where x > 10:
                self.points += 40
            default:
                self.points += 10
            }
        }
        return checkWord
    }
    
    func isLetterCorrect(id: Int) -> Bool {
        let value = letters[id]
        let valueSelected = id < nextChoosenID + 1 ? selectedLetters[id] : .star
        return value?.char == valueSelected?.char
    }
}

