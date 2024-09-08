//
//  LeitnerSystemTest.swift
//  LeitnerAlgorithmTests
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation
import XCTest
@testable import LeitnerAlgorithm

class LeitnerFlowTest: XCTestCase {
    
    func test_init_canNotBecreatedWithZeroAmountOfBoxes() {
        let sut = makeSUT(boxAmount: 0)
        XCTAssert(!sut.boxes.isEmpty, "System can not be created with 0 amount of boxes.")
    }
    
    func test_init_canNotBecreatedWithOneBox() {
        let sut = makeSUT(boxAmount: 1)
        XCTAssertEqual(sut.boxes.count, 2, "System can not be created with 0 amount of boxes.")
    }

    func test_init_createsWithGivenAmountOfBoxes() {
        let sut2 = makeSUT(boxAmount: 2)
        XCTAssertEqual(sut2.boxes.count, 2)
        
        let sut3 = makeSUT(boxAmount: 3)
        XCTAssertEqual(sut3.boxes.count, 3)
        
        let sut10 = makeSUT(boxAmount: 10)
        XCTAssertEqual(sut10.boxes.count, 10)
        
        let sut21 = makeSUT(boxAmount: 21)
        XCTAssertEqual(sut21.boxes.count, 21)
    }

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
        sut.addCard(card)
        
        // Move the card to the second box manually
        moveCardForward(card: card, to: 1, in: sut)

        sut.updateCard(card, correct: true)
        
        XCTAssertEqual(sut.boxes[0].count, 0, "The first box should be empty.")
        XCTAssertEqual(sut.boxes[1].count, 0, "The second box should be empty.")
        XCTAssertEqual(sut.boxes[2][0].id, id, "The next(third) box should contain the card just moved.")
    }
    
    func test_cardInLastBox_correctAnswer_keepsCardInLastBox() {
        let sut = makeSUT()
        
        let id = fixedUuid
        let card = makeCard(with: id)
        sut.addCard(card)
        // Move the card to the last box manually
        moveCardForward(card: card, to: 4, in: sut)
        
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
        sut.addCard(card)
        // Move the card to the second box manually
        moveCardForward(card: card, to: 1, in: sut)
        
        sut.updateCard(card, correct: false)
        
        XCTAssertEqual(sut.boxes[1].count, 0, "The second box should be empty after an incorrect answer.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The card should move back to the first box after an incorrect answer.")
    }
    
    func test_cardInLastBox_incorrectAnswer_movesCardToFirstBox() {
        let sut = makeSUT()

        let id = fixedUuid
        let card = makeCard(with: id)
        sut.addCard(card)
        // Move the card to the last box manually
        moveCardForward(card: card, to: 4, in: sut)
        
        sut.updateCard(card, correct: false)
        
        XCTAssertEqual(sut.boxes[4].count, 0, "The last box should be empty after an incorrect answer.")
        XCTAssertEqual(sut.boxes[0][0].id, id, "The card should move back to the previous box after an incorrect answer.")
    }

     // MARK: - Test Helpers
    
    private func makeSUT(boxAmount: UInt = 5) -> LeitnerSystem {
        return LeitnerSystem(boxAmount: boxAmount)
    }
    
    private func moveCardForward(card: Card, to boxIndex: Int, in sut: LeitnerSystem) {
        for _ in 0..<boxIndex {
            sut.updateCard(card, correct: true)
        }
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
