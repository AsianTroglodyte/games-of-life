#lang racket

(provide create-grid)
;; grid as nested lists

(define some-list (list 1 2 3 4))

(define (create-grid n)
  (make-list n (make-list n 0)))

(define grid-4 (create-grid 20))

;; (displayln grid-4)

;; (for-each displayln grid-4)
