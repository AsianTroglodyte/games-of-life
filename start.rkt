#lang slideshow

(define c (circle 10))
(define r (rectangle 10 20))
(define (square n)
  (filled-rectangle n n))

(define (four p)
  (let ([p12 (hc-append p p)]
        [p21 (hc-append p p)])
    (vc-append p12 p21)))

(define (checker p1 p2)
  (let ([p12 (hc-append p1 p2)]
        [p21 (hc-append p2 p1)])
    (vc-append p12 p21)))

(checker (colorize (square 10) "red")
         (colorize (square 10) "black"))

(define (checkerboard p)
  (let* ([rp (colorize p "red")]
         [bp (colorize p "black")]
         [c (checker rp bp)]
         [c4 (four c)])
    (four c4)))

(checkerboard (square 10))

(define (series draw-func)
  (hc-append 4 (draw-func 5) (draw-func 10) (draw-func 20)))

(series (lambda (size) (checkerboard (square size))))

(define (rgb-series draw-func)
  (vc-append
   (series (lambda (sz) (colorize (draw-func sz) "red")))
   (series (lambda (sz) (colorize (draw-func sz) "green")))
   (series (lambda (sz) (colorize (draw-func sz) "blue")))))

(rgb-series circle)
(rgb-series square)

(define (rgb-maker draw-func)
  (lambda (size)
    (vc-append (colorize (draw-func size) "red")
               (colorize (draw-func size) "green")
               (colorize (draw-func size) "blue"))))

(series (rgb-maker circle))

;; (series ())
;; (require racket/draw)

;; (display "Hello World\n")

;; (define target (make-bitmap 30 30))
;; (define dc (new bitmap-dc% [bitmap target]))

;; (send dc draw-rectangle
;;       0 10
;;       30 10)

;; (send dc draw-line
;;       0 0
;;       30 30)

;; (send dc draw-line
;;       0 0
;;       30 30)xs
