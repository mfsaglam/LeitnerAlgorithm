//
//  LeitnerSystemTest.swift
//  LeitnerAlgorithmTests
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation
import XCTest

class LeitnerFlowTest: XCTestCase {
    
    func test_addCard_addsToFirstBox() {
        let sut = LeitnerSystem()
        
        let card = makeCard()
        sut.addCard(card)

        XCTAssertEqual(sut.boxes[0].count, 1, "The first box should contain the card after it's added.")
    }
    
    func test_correctAnswer_movesCardToNextBox() {
        let sut = LeitnerSystem()
        
        let card = makeCard()
        sut.addCard(card)
        
        sut.updateCard(card, correct: true)
        
        XCTAssertEqual(sut.boxes[0].count, 0, "The first box should be empty.")
        XCTAssertEqual(sut.boxes[1].count, 1, "The second box should contain the card just moved.")
    }
    
    private func makeCard() -> Card {
        return Card(word: anyWord, lastReviewed: Date(), reviewInterval: 1)
    }
    
    private var anyWord: Word {
        let word = Word(id: UUID(), word: "apple", languageCode: "en", meaning: "a fruit", exampleSentence: nil)
        return word
    }
}

class LeitnerSystem {
    var boxes: [[Card]] = Array(repeating: [], count: 5)  // 5 boxes (0 to 4)

    func addCard(_ card: Card) {
        boxes[0].append(card)  // Start card in the first box
    }

    func updateCard(_ card: Card, correct: Bool) {
        // Find the card's current box
        for (boxIndex, box) in boxes.enumerated() {
            if let index = box.firstIndex(where: { $0.id == card.id }) {
                boxes[boxIndex].remove(at: index)
                
                if correct {
                    let nextBox = min(boxIndex + 1, boxes.count - 1)
                    boxes[nextBox].append(card)  // Move card to the next box
                } else {
                    boxes[0].append(card)  // Move card back to the first box
                }
                break
            }
        }
    }
}

struct Word {
    let id: UUID
    let word: String
    let languageCode: String
    let meaning: String
    let exampleSentence: String?
    
    init(
        id: UUID = UUID(),
        word: String,
        languageCode: String,
        meaning: String,
        exampleSentence: String?
    ) {
        self.id = id
        self.word = word
        self.languageCode = languageCode
        self.meaning = meaning
        self.exampleSentence = exampleSentence
    }
}

struct Card {
    let id: UUID
    let word: Word
    let lastReviewed: Date
    let reviewInterval: Int
    
    init(
        id: UUID = UUID(),
        word: Word,
        lastReviewed: Date,
        reviewInterval: Int
    ) {
        self.id = id
        self.word = word
        self.lastReviewed = lastReviewed
        self.reviewInterval = reviewInterval
    }
}
