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
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        sut.addCard(card)

        XCTAssertEqual(sut.boxes[0].count, 1, "The first box should contain the card after it's added.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The first box should contain the card after it's added.")
    }
    
    func test_cardInFirstBox_correctAnswer_movesCardToSecondBox() {
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        sut.addCard(card)
        
        sut.updateCard(card, correct: true)
        
        XCTAssertEqual(sut.boxes[0].count, 0, "The first box should be empty.")
        XCTAssertEqual(sut.boxes[1][0].id, id, "The second box should contain the card just moved.")
    }
    
    func test_cardInSecondBox_correctAnswer_movesCardToThirdBox() {
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        
        // Move the card to the last box manually
        sut.boxes[1].append(card)
        
        sut.updateCard(card, correct: true)
        
        XCTAssertEqual(sut.boxes[0].count, 0, "The first box should be empty.")
        XCTAssertEqual(sut.boxes[1].count, 0, "The second box should be empty.")
        XCTAssertEqual(sut.boxes[2][0].id, id, "The next(third) box should contain the card just moved.")
    }
    
    func test_cardInLastBox_correctAnswer_keepsCardInLastBox() {
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        
        // Move the card to the last box manually
        sut.boxes[4].append(card)
        
        sut.updateCard(card, correct: true)
        
        XCTAssertEqual(sut.boxes[4].count, 1, "The last box should still contain the card after a correct answer.")
        XCTAssertEqual(sut.boxes[4][0].id, id, "The card should not move beyond the last box.")
    }
    
    func test_cardInFirstBox_incorrectAnswer_keepsCardInFirstBox() {
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        sut.addCard(card)
        
        sut.updateCard(card, correct: false)
        
        XCTAssertEqual(sut.boxes[0].count, 1, "The first box should still contain the card after an incorrect answer.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The card should not move after an incorrect answer in the first box.")
    }
    
    func test_cardInSecondBox_incorrectAnswer_movesCardBackToFirstBox() {
        let sut = makeSUT()

        let id = fixedUuid
        let card = makeCard(with: id)
        
        // Move the card to the second box manually
        sut.boxes[1].append(card)
        
        sut.updateCard(card, correct: false)
        
        XCTAssertEqual(sut.boxes[1].count, 0, "The second box should be empty after an incorrect answer.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The card should move back to the first box after an incorrect answer.")
    }
    
    func test_cardInLastBox_incorrectAnswer_movesCardToFirstBox() {
        let sut = makeSUT()

        let id = fixedUuid
        let card = makeCard(with: id)
        
        // Move the card to the last box manually
        sut.boxes[4].append(card)
        
        sut.updateCard(card, correct: false)
        
        XCTAssertEqual(sut.boxes[4].count, 0, "The last box should be empty after an incorrect answer.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The card should move back to the previous box after an incorrect answer.")
    }

     // MARK: - Test Helpers
    
    private func makeSUT() -> LeitnerSystem {
        return LeitnerSystem()
    }
    
    private func makeCard(with id: UUID) -> Card {
        let word = makeWord()
        return Card(id: id, word: word, lastReviewed: fixedDate, reviewInterval: 1)
    }
    
    private func makeWord(
        word: String = "defaultWord",
        languageCode: String = "en",
        meaning: String = "defaultMeaning",
        exampleSentence: String? = nil
    ) -> Word {
        return Word(
            word: word,
            languageCode: languageCode,
            meaning: meaning,
            exampleSentence: exampleSentence
        )
    }
    
    private var fixedUuid: UUID {
        return UUID(uuidString: "2A8DDD36-50D3-458A-A2BF-B0A1E36C1759")!
    }

    private var fixedDate: Date {
        return Date(timeIntervalSince1970: 0)  // Fixed date for testing
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
    let word: String
    let languageCode: String
    let meaning: String
    let exampleSentence: String?
    
    init(
        word: String,
        languageCode: String,
        meaning: String,
        exampleSentence: String?
    ) {
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
        lastReviewed: Date = Date(),
        reviewInterval: Int
    ) {
        self.id = id
        self.word = word
        self.lastReviewed = lastReviewed
        self.reviewInterval = reviewInterval
    }
}
