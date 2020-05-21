(in-package #:stumpwm)

(import 'arrows:->)

(defun ast->string (lst)
  ;; this needed here, otherwise write-to string would use fully qualified names
  ;; making it like (stumpwm::load "~/.stumpwm.d/stump.el")
  (in-package #:stumpwm)
  (string-downcase (write-to-string (write-to-string lst))))

(defvar *edit-w-mx/prev-selection* nil)

(defun edit-w-mx/get-current-selection ()
  "Returns current selection, otherwise nil"
  (let ((cur (get-x-selection nil :primary)))
    (when (or (not cur)
              (string-not-equal *edit-w-mx/prev-selection* cur))
      (setq *edit-w-mx/prev-selection* cur)
      cur)))

(defcommand edit-with-emacs (&optional dont-copy?) (:y-or-n)
  (let* ((cur-win (current-window))
         (win-class (string (slot-value cur-win 'class)))
         (win-id (->
                  cur-win
                  (slot-value 'xwin)
                  (slot-value 'xlib::id)
                  (write-to-string)))
         (cmd (ast->string `(progn
                              (load "~/.stumpwm.d/stump.el")
                              (require 'stump)
                              (stump/edit-with-emacs ,win-id ,win-class ,dont-copy?))))
         (selected-text (edit-w-mx/get-current-selection)))
    (unless dont-copy?
      (unless selected-text
        (stumpwm::send-fake-key cur-win (kbd "C-a")))
      (stumpwm::send-fake-key cur-win (kbd "C-c")))
    (run-shell-command (concat "emacsclient -e " cmd))
    (run-or-raise "emacs" '(:class "Emacs"))
    (setf *edit-w-mx/prev-selection* nil)))

(define-key *top-map* (kbd "C-s-o") "edit-with-emacs")
(define-key *top-map* (kbd "C-s-O") "edit-with-emacs y")

(defcommand finish-edit-with-emacs
    (win-id &optional succes-p)
    ((:string "window id: ") (:y-or-n))
  (let ((win (->
              win-id
              (parse-integer)
              (window-by-id))))
    (focus-window win t)
    (when succes-p
      (send-fake-key win (kbd "C-v")))))
