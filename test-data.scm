;;;; to manually run tests for project 1, CS 314, Fall 2017

;;;; - put this file in the same folder as your figure-code.scm (or whatever
;;;;   file your answer code is in)

;;;; - open your figure-code.scm in Dr. Racket and execute it (hit command-R or
;;;; choose Run from the Racket menu)
;;;; - then type (load "test-data.scm")
;;;; - type (do-spin 1) to do the first test
;;;; - type (do-spin 2) to do the second test, etc
;;;; there are 9 tests.


;;; a checkerboard function of A and B
(define (ab-check row col)
  (if (= (remainder (+ row col) 2)
	 0)
      #\A #\B))

;;; a checkerboard function of C and D
(define (cd-check row col)
  (if (= (remainder (+ row col) 2)
	 0)
      #\C #\D))


(define ab2x1fig (make-figure ab-check 2 1)) ;; a 2 row, 1 col checkerboard figure of A and B
;;  A
;;  B

(define ab2x3fig (make-figure ab-check 2 3)) ;; a 2 row, 3 column checkerboard figure of A and B
;;  ABA
;;  BAB

(define cd3x3fig (make-figure cd-check 3 3)) ;; a 3 row, 3 column checkerboard figure of C and D
;; CDC
;; DCD
;; CDC

;;; do the actual testing.  a "spin" is a test case
(define (do-spin n)
  (case n
    ((1) (let* ((figfn (lambda (row col)   ; test add-check
			 (cond ((and (eq? row 0)(eq? col 0))
				#\A)
			       ((and (eq? row 0)(eq? col 1))
				#\B)
			       (else #\C))))
		(test-fn (add-check figfn 1 2)))
	   (test-equal n (for-n-list
			  -1 1
			  (lambda (row)
			    (for-n-list
			     -1 2
			     (lambda (col)
			       (test-fn row col)))))
		       '((#\. #\. #\. #\.) (#\. #\A #\B #\.) (#\. #\. #\. #\.))
                       20)))    ; this test is worth 20 points
    ((2) (let ((ab4x3fig (repeat-rows 2 ab2x3fig)))  ;  test repeat-rows
	   (test-equal n (window->strings 0 4 0 4 ab4x3fig)
		       '("ABA.." "BAB.." "ABA.." "BAB.." ".....")
		       8)))    ; this test is worth 8 points
    ((3) (let ((ab6x3fig (repeat-rows 3 ab2x3fig)))  ;  test repeat-rows
	   (test-equal n (window->strings 0 9 0 4 ab6x3fig)
		       '("ABA.." "BAB.." "ABA.." "BAB.." "ABA.." "BAB.."
			 "....." "....." "....." ".....")
		       8)))
    ((4) (let* ((ap-cfig (append-cols ab2x3fig cd3x3fig)))  ;  test append-cols
	   (test-equal n (window->strings 0 2 0 6 ap-cfig)
		       '("ABACDC." "BABDCD." ".......")
		       8)))
    ((5) (let* ((ap-cfig (append-cols ab2x3fig cd3x3fig)))  ;  test append-cols
	   (test-equal n (window->strings 0 2 0 6 ap-cfig)
		       '("ABACDC." "BABDCD." ".......")
		       8)))
    ((6) (let* ((ap-rfig (append-rows cd3x3fig ab2x3fig)))  ;  test append-rows
	   (test-equal n (window->strings 0 5 0 4 ap-rfig)
		       '("CDC.." "DCD.." "CDC.." "ABA.." "BAB.." ".....")
		       8)))
    ((7) (let* ((ap-rfig2 (append-rows ab2x3fig cd3x3fig)))  ;  test append-rows
	   (test-equal n (window->strings 0 5 0 4 ap-rfig2)
		       '("ABA.." "BAB.." "CDC.." "DCD.." "CDC.." ".....")
		       8)))
    ((8) (let* ((fl-cfig (flip-cols (sw-corner 4))))  ;  test flip cols
	   (test-equal n (window->strings 0 5 0 5 fl-cfig)
		       '("   *.." "  **.." " ***.." "****.." "......" "......")
		       16)))
    ((9) (let* ((fl-rfig (flip-rows (sw-corner 4))))  ;  test flip cols
	   (test-equal n (window->strings 0 5 0 5 fl-rfig)
		       '("****.." "*** .." "**  .." "*   .." "......" "......")
		       16)))

    ))

(define (trace x) (display x) (display "\n") x)

;;; like display-window but rather than printing the result, it
;;; returns a list of strings, one string per line that would be
;;; printed by display-window.
(define (window->strings start-row stop-row start-col stop-col figure)
  (trace
   (for-n-list start-row stop-row 
         (lambda (r)
           (for-n-string start-col stop-col 
                  (lambda (c)
                    ((figure-func figure) r c)))))
))
          

;;; like for-n 
(define (for-n-list start stop fn)
  (if (> start stop) '()
      (cons (fn start) (for-n-list (+ 1 start) stop fn))))

;;; like for-n but result of fn must be a string and this function
;;; string-appends the results together rather than making a list of
;;; them.
(define (for-n-string start stop fn)
  (if (> start stop) ""
      (string-append (string (fn start)) (for-n-string (+ 1 start) stop fn))))

(define (test-equal n test-value correct-value points)                                                      
  (begin (display "actual: ") (newline)
	 (map (lambda (line) (display line)(newline))
	      test-value)
	 (newline)
	 (display "correct: ")
	 (newline)
	 (map (lambda (line) (display line)(newline))
	      correct-value)
	 (if (equal? test-value correct-value)
	     (display (string-append "correct. points: " (number->string points)))
	     (display (string-append "wrong. points: 0 out of " (number->string points))))))
		      

	 