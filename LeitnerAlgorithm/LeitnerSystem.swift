//
//  LeitnerSystem.swift
//  LeitnerAlgorithm
//
//  Created by Fatih Sağlam on 8.09.2024.
//

import Foundation

class LeitnerSystem {
    private(set) var boxes: [Box]
    
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
        let boxCount = max(2, Int(boxAmount))  // Ensure at least 2 boxes
        let reviewIntervals = LeitnerSystem.generateReviewIntervals(for: boxCount)
        
        boxes = (0..<boxCount).map { index in
            Box(
                cards: [],
                reviewInterval: TimeInterval(reviewIntervals[index]),
                lastReviewedDate: Date()
            )
        }
    }
    
    /// Loads the provided boxes with their respective cards into the Leitner system.
    /// This method replaces the current set of boxes with the provided boxes.
    /// - Parameter boxes: A two-dimensional array of `Card` objects, where each subarray represents a box in the Leitner system.
    func loadBoxes(boxes: [Box]) {
        self.boxes = boxes
    }

    // Generates review intervals based on the number of boxes
    static private func generateReviewIntervals(for boxCount: Int) -> [Int] {
        let baseIntervals = [1, 3, 7, 14, 30, 60]
        var intervals = [Int]()
        
        for i in 0..<boxCount {
            if i < baseIntervals.count {
                intervals.append(baseIntervals[i])
            } else {
                // Extend the intervals for more boxes (e.g., double the last one or add a custom logic)
                let extendedInterval = intervals.last! * 2  // Example: extend by doubling the last interval
                intervals.append(extendedInterval)
            }
        }
        
        return intervals
    }
    
    /// Adds a new card to the Leitner system.
    ///
    /// - Parameter card: The `Card` object to be added to the system.
    ///
    /// The card is added to the first box (box 0) upon creation. This is the starting
    /// point for new cards in the Leitner system. As the user interacts with the card
    /// and provides correct or incorrect answers, the card will be moved between
    /// boxes based on the spaced repetition algorithm.
    ///
    /// Example Usage:
    /// ```
    /// let card = Card(id: UUID(), word: word, lastReviewed: Date(), reviewInterval: 1)
    /// let system = LeitnerSystem()
    /// system.addCard(card) // Adds the card to the first box
    /// ```
    ///
    /// Note: Ensure that the card provided is valid and properly initialized.
    /// The system assumes that new cards start in the first box and will handle
    /// moving the card between boxes based on user interactions.
    func addCard(_ card: Card) {
        boxes[0].cards.append(card)  // Start card in the first box
    }
    
    /// Updates the status of a card based on whether the user's answer was correct or incorrect.
    ///
    /// - Parameters:
    ///   - card: The `Card` object to be updated. The system will locate this card
    ///     in its current box and modify its position based on the correctness of
    ///     the user's response.
    ///   - correct: A Boolean value indicating whether the user's answer was correct.
    ///     If `true`, the card will be moved to the next box. If `false`, the card
    ///     will be moved back to the first box.
    ///
    /// The method performs the following steps:
    /// 1. Finds the card in its current box by matching its `id`.
    /// 2. Removes the card from its current box.
    /// 3. Moves the card to the next box if the answer was correct, or back to the
    ///    first box if the answer was incorrect. The box index is constrained to
    ///    valid ranges (i.e., between 0 and the total number of boxes - 1).
    ///
    /// Example Usage:
    /// ```
    /// let card = Card(id: UUID(), word: word, lastReviewed: Date(), reviewInterval: 1)
    /// let system = LeitnerSystem()
    /// system.addCard(card)
    /// system.updateCard(card, correct: true) // Moves the card to the next box
    /// system.updateCard(card, correct: false) // Moves the card back to the first box
    /// ```
    ///
    /// Note: Ensure that the `card` provided is correctly initialized and exists
    /// in one of the boxes. This method assumes that the `card` is present and
    /// will not handle cases where the card is not found.
    func updateCard(_ card: inout Card, correct: Bool) {
        // Find the card's current box
        for (boxIndex, box) in boxes.enumerated() {
            if let index = box.cards.firstIndex(where: { $0.id == card.id }) {
                boxes[boxIndex].cards.remove(at: index)
                
                if correct {
                    let nextBox = min(boxIndex + 1, boxes.count - 1)
                    appendCard(&card, to: nextBox)
                } else {
                    appendCard(&card, to: 0) // Move back to the first box
                }
                break
            }
        }
    }
    
    /// Returns the list of cards that are due for review, based on their `nextReviewDate`
    /// compared to the current date. The method strips the time component, so only the day
    /// is considered when determining if a card is due for review.
    ///
    /// - Parameter limit: The maximum number of cards to return (default is 10).
    /// - Returns: An array of `Card` objects that are due for review, limited by the specified number.
    func dueForReview(limit: Int = 10) -> [Card] {
        let today = Calendar.current.startOfDay(for: Date())
        var dueCards: [Card] = []
        
        for box in boxes where box.nextReviewDate <= today {
            dueCards.append(contentsOf: box.cards)
        }
        
        return Array(dueCards.prefix(limit))
    }

    private func appendCard(_ card: inout Card, to boxIndex: Int) {
        // Move the card to the target box
        boxes[boxIndex].cards.append(card)
    }
}
