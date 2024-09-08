//
//  LeitnerSystem.swift
//  LeitnerAlgorithm
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation

class LeitnerSystem {
    private(set) var boxes: [[Card]]
    
    /// Initializes a `LeitnerSystem` with a specified number of boxes.
    ///
    /// - Parameter boxAmount: The number of boxes to initialize the system with.
    ///   If the provided value is less than 2, the system will default to 2 boxes.
    ///   This ensures that there is a minimum of two boxes to support the basic
    ///   functionality of the Leitner System. Defaults to 5.
    ///
    /// Example Usage:
    /// ```
    /// let system = LeitnerSystem(boxAmount: 7) // Creates a system with 7 boxes
    /// let defaultSystem = LeitnerSystem()      // Creates a system with the default 5 boxes
    /// ```
    ///
    /// Note: Adjusting the number of boxes may affect the behavior and complexity
    /// of the spaced repetition algorithm. Ensure that the number of boxes aligns
    /// with your intended use case.
    init(boxAmount: UInt = 5) {
        boxes = Array(repeating: [], count: boxAmount < 2 ? 2 : Int(boxAmount))
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
