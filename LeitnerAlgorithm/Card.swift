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
    var reviewInterval: Int
    var nextReviewDate: Date?
    
    init(
        id: UUID = UUID(),
        word: Word,
        lastReviewed: Date = Date(),
        reviewInterval: Int = 1
    ) {
        self.id = id
        self.word = word
        self.lastReviewed = lastReviewed
        self.reviewInterval = reviewInterval
    }
}
