#lang racket
; Josiah Schmitz

; defining card types
(define faces '(2 3 4 5 6 7 8 9 10 J Q K A)) 
(define suits '(♣ ♦ ♥ ♠))

; make-deck
; no input
; returns a list of cards representing the deck
(define (make-deck)

  (define returndeck '()) ; list to return created deck

  ; iterates over all the suits and faces and adds pairs of each to returndeck
  (for ([suit suits])
    (for ([face faces])
      (set! returndeck (append returndeck (list (cons face suit))))))

  returndeck)

; eval-hand
; takes a list of cards representing a hand as a parameter
; returns the best value of hand as integer (determines if Ace = 1 or 11)
(define (eval-hand hand)
  
  (define score 0) ; holds total value of hand
  (define containsace #f) ; determines if the hand contains an ace
  
  (for ([card hand]) ; iterate over each card in the hand
    (cond [(member (car card) '(J Q K)) (set! score (+ score 10))] ; set value for face cards if present
          [(equal? (car card) 'A) ; check if hand has an ace
           (set! score (+ score 11)) ; give it the higher score (11) from the ace as a default
           (set! containsace #t)]
          [else (set! score (+ score (car card)))])) ; set score as raw values of cards if no aces or face cards present

  (when (and (> score 21) containsace) (set! score (- score 10))) ; if the score is above a 21 and an ace is in the hand, reduce total score by 10 for the ace

  score)

; deal!
; takes a list of cards representing the deck as a parameter
; returns a two-card hand from the first two cards of the deck
(define (deal! deck)

  (define newhand '()) ; holds hand to be returned

  (set! newhand (append newhand (list (first (unbox deck))))) ; add first card from deck to hand
  (set! newhand (append newhand (list (second (unbox deck))))) ; add second card from deck

  (set-box! deck (cddr (unbox deck))) ; remove first two cards from deck

  newhand)

; hit!
; takes a list of cards representing the deck as the first parameter
; takes a list of cards representing the caller's hand as the second parameter 
; returns void
(define (hit! deck hand)

  (set-box! hand (append (unbox hand) (list (first (unbox deck))))) ; add first card from deck to end of given hand

  (set-box! deck (cdr (unbox deck)))) ; remove first card from deck

; show-hand
; takes a list of cards representing a hand as the first parameter
; takes a string (either 'Full or 'Part) which determines how hand should be displayed as the second parameter
; takes a string to precede the hand as the third parameter
;(define (show-hand hand how description)
;  )


; define deck and dealer/player hands
; using boxes for each global variable to make them globally mutable
(define thedeck (box (make-deck)))
(define playerhand (box '()))
(define dealerhand (box '()))


; TEST CODE
;(unbox thedeck)
(eval-hand '((K . ♥) (3 . ♠) (A . ♥) (7 . ♥)))
(set-box! playerhand (append (unbox playerhand) (list (deal! thedeck))))
(display (unbox playerhand))
(display "\n")
(hit! thedeck playerhand)
(display (unbox playerhand))
(display "\n")
(display (unbox thedeck))