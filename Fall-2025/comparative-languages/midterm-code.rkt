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
        [(equal? (modulo (first lst) 2) 0) (+ 1 (count-evens (rest lst)))] ; if car of lst is even (divisible by 2), add one to output of recursive call on rest of list
        [else (count-evens (rest lst))])) ; otherwise, just recursively call count-evens on rest of lst

; Problem 6b
; count-evens-nested
; list of numbers and nested lists as input
; returns the number of even integers in list
(define (count-evens-nested lst)

  (cond [(empty? lst) 0] ; BASECASE: if lst is empty, return an empty list
        [(list? (first lst)) (+ (count-evens-nested (first lst)) (count-evens-nested (rest lst)))] ; if car of lst is a sub-list, add results of recursive calls on car and rest of list
        [(equal? (modulo (first lst) 2) 0) (+ 1 (count-evens-nested (rest lst)))] ; if car of lst is even (divisible by 2), add one to output of recursive call on rest of list
        [else (count-evens-nested (rest lst))])) ; otherwise, just recursively call count-evens on rest of lst


; Problem 9b
(define-struct car (type model color num-doors top-speed)#:mutable)

(define ford
  (car "truck" "f-150" "blue" 4 120))

(define honda
  (car "sedan" "pilot" "red" 2 110))

(define kia 
  (car "sedan" "soul" "silver" 4 100))

; modifying the last 3 values for all 3 car types
(set-car-color! ford "purple")
(set-car-num-doors! ford 2)
(set-car-top-speed! ford 150)
(set-car-color! honda "yellow")
(set-car-num-doors! honda 4)
(set-car-top-speed! honda 80)
(set-car-color! kia "green")
(set-car-num-doors! kia 2)
(set-car-top-speed! kia 90)

; accessing the last 3 values for all 3 car types
(car-color ford)
(car-num-doors ford)
(car-top-speed ford)
(car-color honda)
(car-num-doors honda)
(car-top-speed honda)
(car-color kia)
(car-num-doors kia)
(car-top-speed kia)


; TEST CASES for problems 5 and 6
(div-by 30)
(count-evens '(1 4 3 7 8))
(count-evens-nested '(1 (2 3) (4 (5 6))))