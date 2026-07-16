;; #lang racket
#lang racket/gui

(require racket/class
         racket/gui/base)

(require "game_state.rkt")

;; (define (colored-square side-size color)
;;   (colorize (square side-size) color))

;; (define black-square (colored-square 10 "black"))

;; (define (create-col col-height pict)
;;   (if (> col-height 1)
;;       (vc-append 2 pict
;;                  (create-col
;;                   (- col-height 1)
;;                   (vc-append 2 pict)))
;;       pict))

;; (define (create-row row-width pict)
;;   (if (> row-width 1)
;;       (hc-append 2 pict
;;                  (create-row
;;                   (- row-width 1)
;;                   (hc-append 2 pict)))
;;       pict))

;; (define (square-grid n picture)
;;   (let ([grid-col (create-col n picture)])
;;     (create-row n grid-col)))


;; starting up the GUI
(define window (new frame%
                    [label "Conway's Game of Life"]
                    [width 300]
                    [height 300]
                    [alignment '(center center)]))

(define main (new vertical-panel%
                  [parent window]))

;; (define (add-drawer picture)
;;   (let ([drawer (make-pict-drawer picture)])
;;     (new canvas%
;;          [parent main]
;;          [style '(border)]
;;          ;; [alignment '(center center)]
;;          [paint-callback (lambda (self dc)
;;                            (drawer dc 0 0))])))

(define msg (new message%
                 [parent main]
                 [label "New message"]))

(new button%
     [parent main]
     [label "Click Me"]
     ; Callback procedure for a button click:
     [callback
      (lambda (button event)
        (send msg set-label "Button click"))])

;; (add-drawer (square-grid 5 black-square))
;; (for-each displayln grid-4)

(define grid-size-cells 10)   ; plural because the unit is "cells"
(define cell-size-px 10)
(define grid-size-px
  (* grid-size-cells cell-size-px))


(define grid (create-grid grid-size-cells))

(define game-canvas
  (make-bitmap grid-size-px grid-size-px))

(define dc (new bitmap-dc% [bitmap game-canvas]))

(send dc set-brush "beige" 'solid)
(send dc set-pen "gray" 1 'solid)


(define (draw-cell
         cell-size-px
         x-pos
         y-pos)
  (send dc draw-rectangle
      x-pos y-pos
      cell-size-px cell-size-px))

(define test-grid (list
               (list 0 0 1)
               (list 1 1 0)
               (list 1 1 0)))

(define (draw-grid grid dc)
  (for ([row grid] [i (in-naturals)])
    (for ([cell row] [j (in-naturals)])
      (let*
          ([x-pos (* j cell-size-px)]
           [y-pos (* i cell-size-px)])
        (if (= cell 0)
            (send dc set-brush "beige" 'solid)
            (send dc set-brush "black" 'solid))
        (draw-cell cell-size-px x-pos y-pos)))))

(draw-grid test-grid dc)

game-canvas

(new canvas%
     [parent main]
     [style '(border)]
     [paint-callback
      (lambda (canvas dc)
        (send dc set-scale 3 3)
        (send dc set-text-foreground "white")
        (send dc draw-bitmap game-canvas 0 0))])
;; (send window show #t)
