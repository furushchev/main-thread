(in-package :mt)

(defun main-thread ()
  "Returns a main thread of your lisp implementation."
  #+ccl ccl::*initial-process*
  #+sbcl (sb-thread:main-thread)
  #+ecl (find 'si:top-level (bt:all-threads) :key #'bt:thread-name))

(let ((semaphore-table (make-hash-table)))
  (defun get-semaphore-by-thread ()
    "Returns a one semaphore per thread."
    (let* ((semaphore (gethash (bt:current-thread) semaphore-table)))
      (unless semaphore
	(let ((new-semaphore (bt-sem:make-semaphore)))
	  (setf (gethash (bt:current-thread) semaphore-table) new-semaphore
		semaphore new-semaphore)))
      semaphore)))

#-ccl 
(defmacro call-in-main-thread ((&key (waitp t)) &body body)
  "Some routine must call in main thread. especially about sounds or gui works.
 This macro interruption to main-thread, and wait until returning body form."
  (alexandria:with-gensyms (semaphore result)
    `(cond ((eql (main-thread) (bt:current-thread)) ,@body)
	   (t
	    (if ,waitp (let ((,semaphore (get-semaphore-by-thread))
			     (,result nil))
			 (bt:interrupt-thread
			  (main-thread)
			  (lambda () (unwind-protect (setf ,result (progn ,@body))
				       (bt-sem:signal-semaphore ,semaphore))))
			 (bt-sem:wait-on-semaphore ,semaphore)
			 ,result)
		(bt:interrupt-thread
		 (main-thread)
		 (lambda () ,@body)))))))


#+ccl
(defmacro call-in-main-thread ((&key (waitp t)) &body body)
  "Some routine must call in main thread. especially about sounds or gui works.
 This macro interruption to main-thread, and wait until returning body form."
  (if waitp `(ccl::call-in-initial-process
	      (lambda () ,@body))
      `(ccl::process-interrupt
	ccl::*initial-process*
	(lambda () ,@body))))
