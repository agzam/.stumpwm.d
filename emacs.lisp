(in-package #:stumpwm)

(import 'arrows:->)

(defun ast->string (lst)
  ;; this needed here, otherwise write-to string would use fully qualified names
  ;; making it like (stumpwm::load "~/.stumpwm.d/stump.el")
  (in-package #:stumpwm)
  (string-downcase (write-to-string (write-to-string lst))))

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
                              (stump/edit-with-emacs ,win-id ,win-class ,dont-copy?)))))
    (unless dont-copy?
      (stumpwm::send-fake-key cur-win (kbd "C-a"))
      (stumpwm::send-fake-key cur-win (kbd "C-c")))
    (run-shell-command (concat "emacsclient -e " cmd))
    (run-or-raise "emacs" '(:class "Emacs"))))

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
