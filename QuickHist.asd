(in-package :asdf)

(asdf:defsystem "QuickHist"
    :depends-on (#:cl-who #:hunchentoot)
    :description "QuickHist: ASCII Histograms API in Common Lisp."
    :version "1.0"
    :author "Pranav Ravichandran <me@onloop.net>"
    :license "WTFPL <http://en.wikipedia.org/wiki/WTFPL>"
    :components ((:file "histRenderer")
		 (:file "histUtil" :depends-on ("histRenderer"))))