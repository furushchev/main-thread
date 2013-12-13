
(asdf/defsystem:defsystem #:main-thread
  :name "main-thread"
  :author "Park Sungmin. byulparan@icloud.com"
  :description "Thread Utility"
  :version "0.1"
  :depends-on (#:bordeaux-threads #:bt-semaphore)
  :components ((:file "package")
	       (:file "main-thread")))
