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
    var nextReviewDate: Date?
    
    init(
        id: UUID = UUID(),
        word: Word,
        lastReviewed: Date = Date()
    ) {
        self.id = id
        self.word = word
        self.lastReviewed = lastReviewed
    }
}
