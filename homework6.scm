(define-syntax 
  firstnon0
  (syntax-rules()
    ((firstnon0 expr1 expr2 expr3)
     (cond
       ((not (zero? expr1)) expr1)
       ((not (zero? expr2)) expr2)
       ((not (zero? expr3)) expr3)
       (else 0)))))

;; ==test==
;;(firstnon0 (+ -1 1) (- 2 2) (- 1 1))
;;(firstnon0 (+ 1 1) (- 2 2) (- 1 1))
;;(firstnon0 (+ -1 1) (- 2 2) (+ 5 1))

;; number 2
;;

(define (tribonacci n)

   (cond
     ((zero? n) 0)
     ((= n 1) 0)
     ((= n 2) 0)
     ((= n 3) 1)
     (else (+ (tribonacci (- n 1) ) (+ (tribonacci (- n 2)) (tribonacci (- n 3) ))))))

;; == test == 
;;(tribonacci 9)
;;(tribonacci 6)

