#lang racket
; Josiah Schmitz

; set-equal?
; takes two lists as input
; returns true if the sets are equal
; returns false otherwise
(define (set-equal? set1 set2)
  ; uses an 'and' operator to return logical 'and' of two for loops
  (and (for/and ([i set1]) ; iterates over every element in set1 and returns false if element is not in set2
         (not (not (member i set2)))) ; have to use weird double-not to turn return value to strict t/f
       (for/and ([i set2]) ; same logic as above but vice versa
         (not (not (member i set1))))))

; nested-set-equal?
; takes two lists as input that can contain nested sets
; returns true if the sets are equal
; returns false otherwise
(define (nested-set-equal? set1 set2)

  ; member-list? recursively checks if x is a member of set lst
  (letrec ([member-list? (lambda (x lst)
                           ;  iterates over the list and returns #t if x is member of lst
                           (for/or ([y lst]) 
                             (nested-set-equal? x y)))]
    
           ; subset? checks if set 'a' is a subset of set 'b'
           [subset? (lambda (a b)
                      ; iterates over set and check if each element is a member of other set
                      (for/and ([x a]) 
                        (member-list? x b)))]) 

    ; returns #t for whole function if both sets are subsets of each other
    ; returns #f otherwise
    (and (subset? set1 set2) (subset? set2 set1))))
   
; union
; takes two lists as input that are non-nested sets of integers
; returns the union of both sets
(define (union set1 set2)

  ; initialize new set to return union of set1 and set2
  (define new-set '())

  ; iterate over set1 and add all values to new-set
  (for ([i set1])
    (set! new-set (append new-set (list i))))

  ; iterate over set2 and add all values not already in new-set to new-set
  (for ([i set2])
    (when (not (member i new-set))
      (set! new-set (append new-set (list i)))))

  ; return new set containing union
  new-set)

; intersection
; takes two lists as input that are non-nested sets of integers
; returns the intersection of both sets
(define (intersection set1 set2)

  ; initialize new set to return intersection of set1 and set2
  (define new-set '())

  ; iterate over set1 and add all values to new-set that are also in set2
  (for ([i set1])
    (when (not (not (member i set2)))
      (set! new-set (append new-set (list i)))))

  ; return new set containing intersection
  new-set)

; mergesort
; takes a list as input that is a flat set of integers
; returns the mergesorted result of the two lists as new list
(define (mergesort lst)

  (letrec ([merge (lambda (first-list second-list) ; helper function that sorts and merges two lists together

                    ; BASE CASE: if one list is empty, return the other one in the merge function
                    (cond
                      [(empty? first-list) second-list]
                      [(empty? second-list) first-list]
                      [else
                       ; if neither list is empty, set x and y to the first values of their respective lists
                       (let* ([x (car first-list)] 
                              [y (car second-list)])
                       ; create new list by putting least value in front and recursively merging the rest of the two lists 
                       (if (< x y)
                           (cons x (merge (cdr first-list) second-list))
                           (cons y (merge first-list (cdr second-list)))))]))]) 

           ; if lst has one or zero items return it
           ; otherwise go through the whole sorting process
           (if (< (length lst) 2)
               lst
               
               ; else block that splits and sorts the list recursively
               (let* ([half-length (quotient (length lst) 2)] ; variable to hold half of lst's length
                [left-list (take lst half-length)] ; list that holds first half of lst's elements
                [right-list (drop lst half-length)] ; list that holds second half nof lst's elements
                [left-sorted (mergesort left-list)] ; runs merge-sort recursively on left-list
                [right-sorted (mergesort right-list)]) ; runs merge-sort recursively on right-list
                (merge left-sorted right-sorted))))) ; merges now-sorted left and right lists


; powerset
; takes a list as input that is a flat set of integers
; returns the powerset of the list

(define (powerset lst)

  ; list to hold final powerset to return
  (define return-set '())
  
  ; complete recursive function to compute powerset
  (if (empty? lst)
      (list '()) ; BASECASE: if lst is empty, return empty set
      (let* ([first-val (first lst)] ; variable to hold first value of lst
             [rest-of-list (rest lst)] ; list that holds all values except the first value of lst
             [powerset-rest (powerset rest-of-list)]) ; powerset of rest-of-list
        (set! return-set powerset-rest) ; adds powerset of all but first value of lst to return-set
        

        ; iterate over the rest of the list
        (for ([i powerset-rest])
          (set! return-set (append return-set (list (cons first-val i))))) ; for each element of powerset-rest, add the first value of lst and i to return-set as a list

  return-set)))

  
  

; TEST CASES
(set-equal? '(1 2 3 4) '(4 2 1 3))
(nested-set-equal? '(1 2 (3 4 5)) '(2 (4 3 5) 1))
(union '(1 2 3 4) '(2 3 4 5))
(intersection '(1 2 3 4) '(2 3 4 5))
(mergesort '(3 1 2 7 9))
(powerset '(1 3 5))