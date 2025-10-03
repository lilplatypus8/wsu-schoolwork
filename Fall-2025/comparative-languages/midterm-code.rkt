#lang racket
; Josiah Schmitz

; Problem 5
; div-by
; single number as input
; returns all divisors of input number less than 15 
(define (div-by num)

  ; return list
  (define less-than-15 '())

  ; iterate on every i < 15
  (for ([i 15])
    (when (not (equal? i 0)) ; do nothing if i is 0 (because we don't want to divide by 0
      (when (equal? (modulo num i) 0) (set! less-than-15 (append less-than-15 (list i)))))) ; if the input mod i equals 0, than i divides the input number and gets added to less-than 15

  less-than-15) ; return list of all divisors less than 15

; Problem 6a
; count-evens
; list of numbers as input
; returns the number of even integers in list
(define (count-evens lst)
  
  (cond [(empty? lst) 0] ; BASECASE: if lst is empty, return an empty list
        [(equal? (modulo (car lst) 2) 0) (+ 1 (count-evens (rest lst)))] ; if car of lst is even (divisible by 2), add one to output of recursive call on rest of list
        [else (count-evens (rest lst))])) ; otherwise, just recursively call count-evens on rest of lst


; Problem 6b
; count-evens-nested
; list of numbers and nested lists as input
; returns the number of even integers in list
(define (count-evens-nested lst)

  (cond [(empty? lst) 0] ; BASECASE: if lst is empty, return an empty list
        [(list? (car lst)) (+ (count-evens-nested (car lst)) (count-evens-nested (rest lst)))] ; if car of lst is a sub-list, add results of recursive calls on car and rest of list
        [(equal? (modulo (car lst) 2) 0) (+ 1 (count-evens-nested (rest lst)))] ; if car of lst is even (divisible by 2), add one to output of recursive call on rest of list
        [else (count-evens-nested (rest lst))])) ; otherwise, just recursively call count-evens on rest of lst


; TEST CASES
(div-by 30)
(count-evens '(1 4 3 7 8))
(count-evens-nested '(1 (2 3) (4 (5 6))))
