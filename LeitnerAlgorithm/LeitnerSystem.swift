//
//  LeitnerSystem.swift
//  LeitnerAlgorithm
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation

class LeitnerSystem {
    var boxes: [[Card]]
    
    init(boxAmount: UInt = 5) {
        boxes = Array(repeating: [], count: Int(boxAmount))
    }

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
