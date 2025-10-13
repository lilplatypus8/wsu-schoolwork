#lang racket
; Josiah Schmitz

; defining card types
(define faces '(2 3 4 5 6 7 8 9 10 J Q K A)) 
(define suits '(♣ ♦ ♥ ♠))

; make-deck
; no input
; returns a list of cards representing the deck
(define (make-deck)

  (let ([returndeck '()]) ; list to return created deck

  ; iterates over all the suits and faces and adds pairs of each to returndeck
  (for ([suit suits])
    (for ([face faces])
      (set! returndeck (append returndeck (list (cons face suit))))))

  returndeck))

; eval-hand
; takes a list of cards representing a hand as a parameter
; returns the best value of hand as integer (determines if Ace = 1 or 11)
(define (eval-hand hand)
  
  (let* ([score 0] ; holds total value of hand
         [containsace #f]); determines if the hand contains an ace
    (for ([card (unbox hand)]) ; iterate over each card in the hand
      (cond [(member (car card) '(J Q K)) (set! score (+ score 10))] ; set value for face cards if present
            [(equal? (car card) 'A) ; check if hand has an ace
             (set! score (+ score 11)) ; give it the higher score (11) from the ace as a default
             (set! containsace #t)]
            [else (set! score (+ score (car card)))])) ; set score as raw values of cards if no aces or face cards present
    
    (when (and (> score 21) containsace) (set! score (- score 10))) ; if the score is above a 21 and an ace is in the hand, reduce total score by 10 for the ace

    score))

; deal!
; takes a list of cards representing the deck as a parameter
; returns a two-card hand from the first two cards of the deck
(define (deal! deck)

  (let ([newhand '()]) ; holds hand to be returned

  (set! newhand (append newhand (list (first (unbox deck))))) ; add first card from deck to hand
  (set! newhand (append newhand (list (second (unbox deck))))) ; add second card from deck

  (set-box! deck (cddr (unbox deck))) ; remove first two cards from deck

  newhand))

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
; returns void
(define (show-hand hand how description)

  (display description) ; display preceding text
  
  (cond [(equal? how 'Full) (displayln (unbox hand))] ; if how is 'Full, just display the hand normally
        [else (display "((*****)") ; if how is 'Part, display the hidden first card
        (for ([card (rest (unbox hand))]) ; display rest of cards normally
          (display " ")
          (display card))
        (display ")\n")]))


; define deck and dealer/player hands
; using boxes for each global variable to make them globally mutable
(define thedeck (box (make-deck)))
(define playerhand (box '()))
(define dealerhand (box '()))


; MAIN ROUTINE -----------------------------------------------------

; GAME SETUP
(define totalmoney 100) ; start player with $100
(define betamount 0) ; variable to hold amount user has bet this session

; MAIN GAME LOOP
(let loop ()
  
  (set-box! thedeck (shuffle (unbox thedeck))) ; shuffle the deck
  (printf "Current amount: $~a\nEnter amount to bet or press q to quit game: " totalmoney) ; display starting prompt
  (define startinginput (read-line)) ; set user input
  (cond [(equal? startinginput "q") (exit)] ; if user types 'q', quit program
        [(and (number? (string->number startinginput)) (<= (string->number startinginput) totalmoney)) (set! betamount (string->number startinginput))] ; if user's input is a number less than the starting amount, make it the betamount
        [else ((displayln "Invalid input. Exiting...") (exit))]) ; if input is anything else, exit the program

; INITIAL DEALING
  (displayln "\nDealing:")
  (displayln "-----------")
  (set-box! dealerhand (deal! thedeck)) ; deal two cards to dealer's hand
  (set-box! playerhand (deal! thedeck)) ; deal two cards to player's hand
  (show-hand dealerhand 'Part "The dealer has: ") ; display dealer's hand in part
  (show-hand playerhand 'Full "The player has: ") ; display player's hand in full
  (display "Player value: ")
  (displayln (number->string (eval-hand playerhand))) ; display player's score

; HIT OR STAY
  (let loop ()
    (display "Choose Hit or Stay (h/s): ")
    (define playerchoice (read-line)) ; read whether player hits or stays
    (cond [(equal? playerchoice "h") (hit! thedeck playerhand) ; if user hits, add card to hand
                                     (show-hand playerhand 'Full "\nThe player has: ") ; display player's updated hand in full
                                     (display "Player value: ")
                                     (displayln (number->string (eval-hand playerhand))) ; display player's score
                                     (if (> (eval-hand playerhand) 21)
                                         (void) ; break from loop if player's score is greater than 21
                                         (loop))] 
          [(not (equal? playerchoice "s")) ((displayln "Invalid input. Exiting...") (exit))])) ; if user types any input other than 'h' or 's', exit program

; DEALER'S TURN
  (displayln "\nDealer's Turn")
  (displayln "-----------")
  (let loop ()
    (show-hand dealerhand 'Full "\nThe dealer has: ") ; display dealer's hand in full
    (show-hand playerhand 'Full "The player has: ") ; display player's hand in full
    (display "Player value: ")
    (displayln (number->string (eval-hand playerhand))) ; display player's score
    (display "Dealer value: ")
    (displayln (number->string (eval-hand dealerhand))) ; display dealer's score
    (when (< (eval-hand dealerhand) 17) ; if dealer's score is less than 17, hit and do his turn again
      (hit! thedeck dealerhand)
      (loop)))

; FINAL EVALUATION
  (cond [(> (eval-hand playerhand) 21) (displayln "\nBust! Player loses.") ; player loses if their score is over 21 
                                       (printf "You lost $~a.\n" betamount)
                                       (set! totalmoney (- totalmoney betamount))]
        [(> (eval-hand dealerhand) 21) (displayln "\nBust! Player wins.") ; player wins if dealer's score is over 21
                                       (printf "You won $~a.\n" betamount)
                                       (set! totalmoney (+ totalmoney betamount))]
        [(> (eval-hand dealerhand) (eval-hand playerhand)) (displayln "\nPlayer loses.") ; player loses if their score is greater than the dealer's
                                                           (printf "You lost $~a.\n" betamount)
                                                           (set! totalmoney (- totalmoney betamount))]
        [(> (eval-hand playerhand) (eval-hand dealerhand)) (displayln "\nPlayer wins.") ; player wins if their score is less than the dealer's
                                                           (printf "You won $~a.\n" betamount)
                                                           (set! totalmoney (+ totalmoney betamount))]
        [else (displayln "You tied. Your money has been returned to you.")]) ; simply display message if game is a tie

; GAME RESTART
  (when (<= totalmoney 0)
    (displayln "You are broke! Exiting game...") ; if player becomes bankrupt or in debt, tell player and exit game
    (exit))
  (set! betamount 0) ; reset betamount
  (printf "Current amount: $~a\n" totalmoney)
  (display "Enter p to play again. Enter any other key to quit:") ; prompt player to play again
  (define replayinput (read-line))
  (if (equal? replayinput "p") (loop) (exit))) ; if player inputs 'p', restart loop and play again; otherwise, exit game