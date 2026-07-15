#lang slideshow
(require pict/flash)
(require slideshow/code)
(require racket/class
         racket/gui/base)

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

(list (circle 10) (square 10))

(define (rainbow p)
  (map (lambda (color)
         (colorize p color))
       (list "red" "orange" "yellow" "green" "blue" "purple")))

(apply vc-append
       (rainbow (filled-rectangle 100 10)))

(filled-flash 40 30)

(code (circle 10))

;; MACROS!!! super cool
(define-syntax pict+code
  (syntax-rules ()
    [(pict+code expr)
     (hc-append 10
                expr
                (code expr))]))

(pict+code (circle 100))

(define f (new frame% [label "My Art"]
               [width 300]
               [height 300]
               [alignment '(center center)]))

(send f show #t)

(define (add-drawing p)
  (let
      ([drawer (make-pict-drawer p)])
      (new canvas%
           [parent f]
           [style '(border)]
           [paint-callback (lambda (self dc)
                             (drawer dc 0 0))])))

(add-drawing (pict+code (circle 10)))
(add-drawing (colorize (filled-flash 50 30) "yellow"))
