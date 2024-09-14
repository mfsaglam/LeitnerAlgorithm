//
//  Card.swift
//  LeitnerAlgorithm
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation

struct Card {
    let id: UUID
    let word: Word
    var lastReviewed: Date
    var nextReviewDate: Date
    
    init(
        id: UUID = UUID(),
        word: Word,
        lastReviewed: Date = Date()
    ) {
        self.id = id
        self.word = word
        self.lastReviewed = lastReviewed
        self.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: lastReviewed)! // since system adds it to the first box immediately.
    }
    
    // Method to check if the card is due for review
    func isDueForReview(currentDate: Date = Date()) -> Bool {
        return currentDate >= nextReviewDate
    }
}
