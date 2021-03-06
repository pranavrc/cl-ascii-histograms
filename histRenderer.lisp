(asdf:operate 'asdf:load-op :restas)
(asdf:operate 'asdf:load-op :cl-who)

(import :histograms)

(restas:define-module :restas.histRenderer
    (:use :cl))

(in-package :restas.histRenderer)
(restas:debug-mode-on)

(setf (who:html-mode) :html5)

(defparameter *invalidEntry* "<a href=\"\/\">Back Home</a>.")

(defparameter *invalidURL* "Yeah, well, y'know, that's just like, uh, a bad URL, man.")

(defun getLabels (input)
  (histograms::bufferSeparator
   (histograms::listLabels
    (histograms::equalizeLists
     (histograms::getLabelCountPairs
      (histograms::stringSplit input #\,) #\=)))))

(defun getBars (input)
  (histograms::generateBars
   (histograms::barCount
    (histograms::percentList
     (histograms::convertToListOfInts
      (histograms::listCounts
       (histograms::equalizeLists
	(histograms::getLabelCountPairs
	 (histograms::stringSplit input #\,) #\=))))))))

(defmacro responseTemplate ((&key header) &body response)
  `(who:with-html-output-to-string (*standard-output* nil :prologue t)
     (:html
      (:head
       (:meta :charset "utf-8")
       (:title "QuickHist")
       (:link :rel "stylesheet" :href (restas:genurl 'css))
       (:link :rel "shortcut icon" :type "image/x-icon" :href (restas:genurl 'favicon)))
      (:body
       (:h3 ,header)
       (:p :id "response"
	   ,@response)))))

(restas:define-route main ("")
  (pathname "/home/vanharp/workbase/QuickHist/res/index.html"))

(restas:define-route css ("index.css")
  (pathname "/home/vanharp/workbase/QuickHist/res/index.css"))

(restas:define-route favicon ("favicon.ico")
  (pathname "/home/vanharp/workbase/QuickHist/res/favicon.ico"))

(restas:define-route fromtheterm ("fromtheterm.png")
  (pathname "/home/vanharp/workbase/QuickHist/res/fromtheterm.png"))

(restas:define-route histInput (":(input)/*title")
  (progn
    (handler-case
	(progn
	  (setf histogramTitle (first title))
	  (setf histogramOutput
	    (histograms::concatList
	     (histograms::mergeListItems
	      (getLabels input)
	      (getBars input) " | ") "")))
      (error (e) 
	(setf histogramTitle *invalidURL*)
	(setf histogramOutput *invalidEntry*))))
  (responseTemplate (:header (who:str histogramTitle)) (:pre (who:str
							      (concatenate 'string (list #\Newline) histogramOutput)))))

(restas:define-route not-found ("*any")
  (responseTemplate (:header (who:str *invalidURL*)) (:pre (who:str *invalidEntry*))))

(restas:start :restas.histRenderer :port 8080)
