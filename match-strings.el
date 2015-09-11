; <mson> Hey, how can I write a function that takes two regions? I'm stuck on
;        how to grab them, as I can only select one at a time, and even if I
;        could select two, I'm not sure the (interactive "r") form would accept
;        both start and end points.
; <mson> I was thinking about calling interactive "r" twice, one inside the
;        other, but got a bit overwhelmed at the thought.  [18:33]
; <offby1> mson: I'm pretty sure "interactive" isn't set up to do that :-|
; <offby1> mson: you could conceivable write a wrapper that prompts for the
; 	 regions, the invokes your main code with the four numbers
; <e1f> mson: there a second region you can select in parallel while holding
;       down the meta key. it's likely called something else  [18:34]
; <offby1> mson: I'd look at how ediff-windows prompts you for the windows
; <offby1> e1f: really?!
; <e1f> yes really

(require 'cl)

(defun jaccard-similarity (l1 l2)
  (let ((|union|        (length (cl-union        l1 l2)))
	(|intersection| (length (cl-intersection l1 l2))))
    (print (length l1))
    (/ (float |intersection|) |union|)))

(defun match-strings ()
  (interactive)
  (let ((first-region (x-get-selection 'PRIMARY))
	(second-region (x-get-selection 'SECONDARY)))
    (set-text-properties 0 (length first-region) nil first-region)
    (set-text-properties 0 (length second-region) nil second-region)
    (let ((token-list-1  (split-string first-region "\n")) ; splitting on newline is a bit problems
	  (token-list-2  (split-string second-region "\n")))
      (print (get-string-similarity token-list-1
				    token-list-2
				    'jaccard-similarity)))))

; currently it's unioning the lines, not the characters. dagn
  
; metric: [Char] -> [Char] -> Numeric
; The number returned from metric should measure how similar s1 and s2 are.
(defun get-string-similarity (s1 s2 metric)
  (let* ((string->char-list (lambda (s) (delete "" (split-string "" s)))))
    (funcall metric
	     (mapcar string->char-list s1)
	     (mapcar string->char-list s2))))

; bbbbb
; bbbbb

