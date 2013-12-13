
(defpackage #:mt
  (:use #:cl)
  (:export #:main-thread
	   #:get-semaphore-by-thread
	   #:call-in-main-thread))
