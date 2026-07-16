;; #lang racket
#lang racket/gui

(require racket/class
         racket/gui/base)

(require "game_state.rkt")

;; starting up the GUI
(define window (new frame%
                    [label "Conway's Game of Life"]
                    [width 300]
                    [height 400]
                    [alignment '(center center)]))

(define main (new vertical-panel%
                  [parent window]))

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

(struct cell-point (x y))

(define grid-size-cells 10)   ; plural because the unit is "cells"
(define cell-size-px 30)
(define grid-size-px
  (* grid-size-cells cell-size-px))

(define game-canvas
  (make-bitmap grid-size-px grid-size-px))

(define dc (new bitmap-dc% [bitmap game-canvas]))

(send dc set-brush "beige" 'solid)
(send dc set-pen "gray" 1 'solid)

(define grid
  (create-grid grid-size-cells))

(define (draw-cell
         cell-size-px
         x-pos
         y-pos)
  (send dc draw-rectangle
      x-pos         y-pos
      cell-size-px  cell-size-px))

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

(draw-grid grid dc)

(define (cell x-pos y-pos)
  (let*
      ([x-coord (modulo x-pos )]
       [y-coord (modulo y-pos)]
       [pointed-cell (cell-point x-coord y-coord)])
  (displayln pointed-cell)))

;; game-canvas
(define game-canvas%
  (class canvas%
    (super-new)
    (define/override (on-event evt)
      (when (send evt button-down?)
        (let
            ([cell-col (quotient (send evt get-x) cell-size-px)]
             [cell-row (quotient (send evt get-y) cell-size-px)])
          (send msg set-label
                (format "Clicked at ~a, ~a"
                        ;; (send evt get-x)
                        ;; (send evt get-y)
                        cell-col
                        cell-row)))))))

(new game-canvas%
     [parent main]
     [style '(border)]
     [paint-callback
      (lambda (canvas dc)
        (send dc set-scale 1 1)
        (send dc set-text-foreground "white")
        (send dc draw-bitmap game-canvas 0 0))])



(send window show #t)
