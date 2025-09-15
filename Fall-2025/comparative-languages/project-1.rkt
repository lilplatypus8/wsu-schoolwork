#lang racket
; Josiah Schmitz

; Part 1
(cons 1 (cons 2 (cons 3 (cons 4 null))))
(cons 1 (cons (cons 2 3) (cons 4 null)))
(cons 1 (cons 2 (cons (cons 3 (cons (cons 4 5) null)) null)))
(cons 1 (cons 2 (cons (cons 3 (cons 4 (cons 5 null))) null)))
(cons (cons 1 2) (cons (cons 3 4) 5))

; Part 2
(cons 1 (cons 2 (cons 3 null)))
(cons 1 (cons 2 (cons 3 4)))
(cons 1 (cons 2 (cons (cons 3 4) (cons 5 6))))
(cons 1 (cons (cons null 2) (cons 3 null)))
(cons (cons (cons 2 3) (cons 4 5)) (cons 6 7))

; Part 3
(define (avg3 num1 num2 num3)
  (define sum (+ num1 num2 num3))
  (/ sum 3))

(define (third-item args)
  (list-ref args 2))