(in-package #:stumpwm)

(import 'arrows:->)

(defun ast->string (lst)
  ;; this needed here, otherwise write-to string would use fully qualified names
  ;; making it like (stumpwm::load "~/.stumpwm.d/stump.el")
  (in-package #:stumpwm)
  (string-downcase (write-to-string (write-to-string lst))))

(defvar *edit-w-mx/prev-selection* nil)

(get-x-selection nil :clipboard)

(defun on-change-selection (a b c d)
  (setq *edit-w-mx/prev-selection* (get-x-selection nil :primary)))

(add-hook *click-hook* 'on-change-selection)

(defun edit-w-mx/get-current-selection ()
  "Returns current selection, otherwise nil"
  (let ((cur (get-x-selection nil :primary)))
    (if (string-equal *edit-w-mx/prev-selection* cur)
        nil
        cur)))

(defun need-split-with-emacs-p (win)
  "Returns nil if Emacs is already visible and on the same display."
  (act-on-matching-windows (w)
      (classed-p w "Emacs")
      (not (within-split-p win w))))

(defun show-emacs-next-to-window (win)
  (run-commands "dump-screen-to-file .stump-before-edit")
  (when (need-split-with-emacs-p win)
        (hsplit))
  (run-or-raise "emacs" '(:class "Emacs")))

(defcommand edit-with-emacs (&optional dont-copy?) (:y-or-n)
  (let* ((cur-win (current-window))
         (win-class (string (slot-value cur-win 'class)))
         (win-title (string (slot-value cur-win 'title)))
         (win-id (->
                  cur-win
                  (slot-value 'xwin)
                  (slot-value 'xlib::id)
                  (write-to-string)))
         (cmd (ast->string `(progn
                              (load "~/.stumpwm.d/stump.el")
                              (require 'stump)
                              (stump/edit-with-emacs ,win-id ,win-title ,win-class ,dont-copy?))))
         (selected-text (edit-w-mx/get-current-selection)))
    (unless dont-copy?
      (unless selected-text
        (stumpwm::send-fake-key cur-win (kbd "C-a")))
      (stumpwm::send-fake-key cur-win (kbd "C-c"))
      (on-change-selection nil nil nil nil))
    (run-shell-command (concat "emacsclient -e " cmd))
    (show-emacs-next-to-window cur-win)))

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
      (send-fake-key win (kbd "C-v")))
    (setf *edit-w-mx/prev-selection* nil)
    (run-commands "restore-from-file .stump-before-edit")))
