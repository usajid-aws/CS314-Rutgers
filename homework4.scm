;;Usama Sajid
;;us71
;;cs314 
;;hw4


;; Define (i.e. write) the function (echo lst). This function doubles each top-level element of list
;; lst. E.g., (echo '(a b c)) returns (a a b b c c).  '(a (b c))) returns (a a (b c) (b c))
;; Q1



(define (echo lst) 
  (if (null? lst) '() 
    (cons (car lst) (cons (car lst) (echo (cdr lst)) ) ) ))

;; testing purposes 
;;(echo '(a (b c)))
;;(echo '(a b c) )

;;Define the function (echo-lots lst n). (echo-lots '(a (b c)) 3) returns (a a a (b c) (b c) (b c)), that
;;is, it is like echo but it repeats each element of lst n times.
;;Q2

(define (echo-lots lst n)
  (define (echo-help a b) 
    (if (= b 0) '() 
      (cons a (echo-help a (- b 1) ) ) )) 
  (if (null? lst) '() 
    (append (echo-help (car lst) n) 
            (echo-help (cdr lst) n) ) ))

;;(echo-lots '(a (b c)) 3) 
;;Q3
(define (echo-all lst) 
  (if (null? lst) '() 
    (if (not (list? (car lst))) 
      (cons (car lst) (cons (car lst) (echo-all (cdr lst) ) ) ) 
      (cons (echo (car lst)) (cons (echo (car lst)) (echo-all (cdr lst))) ) ) ))

;;(echo-all '(a (b c))

;;Q4

(define (nth n lst) 
  (if (= n 0) (car lst) 
    (nth (- n 1) (cdr lst) ) ))



;;(nth 0 '(a b c))
;;(nth 1 '(a (b c) d) )


;; Q5  
(define (assoc-all keys a-list)
  (map (lambda (k) (cadr (assoc k a-list)))
       keys))

(assoc-all '(a d c d) '((a apple)(b boy)(c (cat cow))(d dog)))

;;Q6

(define (filter-out-er fn) 
  (define helper (lambda(x) (if (null? x) '() 
                         (if (not (fn (car x))) (cons (car x) (helper (cdr x)) ) 
                           (helper (cdr x)) ) ) )) helper)

;; (filter even? '(3 4 6 7 8))
