;; #lang racket
#lang slideshow

(require racket/class
         racket/gui/base)
;; (require racket/sha)

(define window (new frame%
                    [label "Conway's Game of Life"]
                    [width 300]
                    [height 300]))


(define yellow-circle
  (colorize (circle 20) "yellow"))

(define (add-drawer picture)
  (let ([drawer (make-pict-drawer picture)])
    (new canvas%
         [parent window]
         [style 'border]
         [paint-callback (lambda (self dc)
                           (drawer dc 0 0 ))])))

(define (square side-size)
  (filled-rectangle side-size side-size))

;; (square 10)

(define (colored-square side-size color)
  (colorize (square side-size) color))

(define white-square (colored-square 10 "white"))

;; (vc-append 2 white-square
;;            (vc-append 2 white-square
;;                       (vc-append 2 white-square)))

(define (create-col col-height pict)
  (if (> col-height 1)
      (vc-append 2 pict
                 (create-col
                  (- col-height 1)
                  (vc-append 2 pict)))
      pict))

(define (create-row row-width pict)
  (if (> row-width 1)
      (hc-append 2 pict
                 (create-row
                  (- row-width 1)
                  (hc-append 2 pict)))
      pict))

;; (create-col 14 white-square)

(define (square-grid n picture)
  (let ([grid-col (create-col n picture)])
    (create-row n grid-col)))


(square-grid 5 white-square)

;; (white-square)
;;      [parent window]
;;      [style 'border]
;;      [paint-callback ])

;; (define (add-drawing p)
;; (let )

;; (send window show #t)
