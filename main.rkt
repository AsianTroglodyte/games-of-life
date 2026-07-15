;; #lang racket
#lang slideshow

(require racket/class
         racket/gui/base)

;; building blocks
(define (square side-size)
  (filled-rectangle side-size side-size))

(define (colored-square side-size color)
  (colorize (square side-size) color))

(define black-square (colored-square 10 "black"))

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

(define (square-grid n picture)
  (let ([grid-col (create-col n picture)])
    (create-row n grid-col)))


;; starting up the GUI
(define window (new frame%
                    [label "Conway's Game of Life"]
                    [width 300]
                    [height 300]
                    [alignment '(center center)]))

(define msg (new message%
                 [parent window]
                 [label "New message"]))

(new button%
     [parent window]
     [label "Click Me"]
     ; Callback procedure for a button click:
     [callback (lambda (button event)
                 (send msg set-label "Button click"))])

(define (add-drawer picture)
  (let ([drawer (make-pict-drawer picture)])
    (new canvas%
         [parent window]
         [style '(border)]
         ;; [alignment '(center center)]
         [paint-callback (lambda (self dc)
                           (drawer dc 0 0))])))

(add-drawer (square-grid 5 black-square))


(send window show #t)
