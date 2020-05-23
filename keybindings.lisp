(in-package #:stumpwm)

(define-key *top-map* (kbd "s-:") "colon")
(define-key *top-map* (kbd "s-!") "exec")
(define-key *top-map* (kbd "s-n") "pull-hidden-next")
(define-key *top-map* (kbd "s-p") "pull-hidden-previous")

(defcommand goto-sleep () ()
  ;; for when you undock the laptop after it goest to sleep
  (run-shell-command (assoc-value xrandr-modes 'laptop))
  (run-shell-command "systemctl suspend"))

(define-key *top-map* (kbd "C-s-ESC") "goto-sleep")

(define-key *help-map*  (kbd "R") "loadrc")
(define-key *root-map*  (kbd "SPC") "run-and-float albert show")

(defvar *window-bindings* nil)
(setf *window-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "v") "hsplit")
        (define-key m (kbd "V") "hsplit")
        (define-key m (kbd "s") "vsplit")
        (define-key m (kbd "w") "other")
        (define-key m (kbd "W") "fselect")
        (define-key m (kbd "l") "move-focus right")
        (define-key m (kbd "h") "move-focus left")
        (define-key m (kbd "j") "move-focus down")
        (define-key m (kbd "k") "move-focus up")
        (define-key m (kbd "L") "move-window right")
        (define-key m (kbd "H") "move-window left")
        (define-key m (kbd "J") "move-window down")
        (define-key m (kbd "K") "move-window up")
        (define-key m (kbd "m") "only")
        (define-key m (kbd "d") "remove-split")
        (define-key m (kbd "=") "balance-frames")
        (define-key m (kbd "e") "expose")
        (define-key m (kbd ".") "iresize")
        m))

(undefine-key *root-map* (kbd "k"))
(undefine-key *root-map* (kbd "K"))
(define-key *root-map* (kbd "h") "move-focus left")
(define-key *root-map* (kbd "l") "move-focus right")
(define-key *root-map* (kbd "j") "move-focus down")
(define-key *root-map* (kbd "k") "move-focus up")
(define-key *root-map* (kbd "H") *help-map*)
(define-key *root-map* (kbd "w") '*window-bindings*)

(loop for n from 0 to 9
      for key = (kbd (write-to-string n))
      for cmd = (concatenate 'string "fselect " (write-to-string n))
      do (define-key *root-map* key cmd))

(defvar *buffers-bindings* nil)
(setf *buffers-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "b") "pull-from-windowlist %n %c")
        (define-key m (kbd "d") "delete")
        (define-key m (kbd "D") "kill")
        m))
(define-key *root-map* (kbd "b") '*buffers-bindings*)

(setq apps-commonly-remapped-keys
      '(;; navigation Vim-style
        ("M-h" . "Left")
        ("M-l" . "Right")
        ("M-j" . "Down")
        ("M-k" . "Up")

        ;; ;; navigation Emacs-style
        ("C-n" . "Down")
        ("C-p" . "Up")
        ("C-f" . "Right")
        ("C-b" . "Left")

        ;; copy-cut-paste
        ("s-c" . "C-c")
        ("s-x" . "C-x")
        ("s-v" . "C-v")))

(setq browsers-commonly-remapped-keys
      '(;; tabs
        ("s-k" . "C-Tab")
        ("s-j" . "C-S-Tab")
        ("s-w" . "C-w")
        ("s-t" . "C-t")
        ("s-T" . "C-T")
        ("s-r" . "C-r")

        ("s-L" . "C-l") ; jump to address bar

        ;; zoom
        ("M-DEL" . "C-DEL")
        ("s-=" . "C-=")
        ("s--" . "C--")

        ;; seach
        ("s-f" . "C-f")
        ("s-g" . "C-g")
        ("s-G" . "C-G")
        ))

(setq firefox-remapped-keys
      (append
       '("(firefox)")
       apps-commonly-remapped-keys
       browsers-commonly-remapped-keys
       '(;; tabs
         ("s-0" . "M-0")
         ("s-1" . "M-1")
         ("s-2" . "M-2")
         ("s-3" . "M-3")
         ("s-4" . "M-4")
         ("s-5" . "M-5")
         ("s-6" . "M-6")
         ("s-7" . "M-7")
         ("s-8" . "M-8")
         ("s-9" . "M-9"))))

(define-remapped-keys
    `(,firefox-remapped-keys))

;;;;;;;;;;
;; apps ;;
;;;;;;;;;;

;; (defcommand browser () () (run-or-raise "brave" '(:class "Brave-browser")))
(defcommand browser () () (run-or-raise "firefox" '(:class "firefox")))
(defcommand terminal-app () () (run-or-raise "gnome-terminal" '(:class "Gnome-terminal")))

(setf *apps-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "g") "browser")
        (define-key m (kbd "e") "emacs")
        (define-key m (kbd "m") "media-app")
        (define-key m (kbd "t") "terminal-app")
        (define-key m (kbd "T") "run-shell-command telegram-desktop")
        m))

(define-key *root-map* (kbd "a") '*apps-bindings*)
