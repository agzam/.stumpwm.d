(in-package :stumpwm)

(set-prefix-key (kbd "s-SPC"))
(setf *mouse-focus-policy* :click)

(run-shell-command "xset r rate 200 60")
(run-shell-command "./redshift.sh")


;; which-key-mode is always on
;; (add-hook *key-press-hook* 'which-key-mode-key-press-hook)

;;;;;;;;;;;;;;;;;
;; keybindings ;;
;;;;;;;;;;;;;;;;;

(define-key *top-map* (kbd "s-:") "colon")
(define-key *top-map* (kbd "s-n") "next")
(define-key *top-map* (kbd "s-p") "prev")

(defvar *window-bindings*
  (let ((m (make-sparse-keymap)))
    (define-key m (kbd "v") "hsplit")
    (define-key m (kbd "s") "vsplit")
    (define-key m (kbd "w") "other")
    (define-key m (kbd "l") "move-focus right")
    (define-key m (kbd "h") "move-focus left")
    (define-key m (kbd "j") "move-focus down")
    (define-key m (kbd "k") "move-focus up")
    m))

(define-key *root-map* (kbd "w") '*window-bindings*)

(define-remapped-keys
    '(("(Brave|Chrome|Firefox)"
       ("C-n" . "Down")
       ("C-p" . "Up")
       ("C-f" . "Right")
       ("C-b" . "Left")
       ("s-k" . "C-Tab")
       ("s-j" . "C-S-Tab")
       ("s-w" . "C-w")
       ("s-c" . "C-c")
       ("s-v" . "C-v")
       ("s-t" . "C-t")
       ("s-T" . "C-T")
       ("M-DEL" . "C-DEL")
       ("s-=" . "C-=")
       ("s--" . "C--")
       )))

;;;;;;;;;;;;;
;; visuals ;;
;;;;;;;;;;;;;

(setq *message-window-gravity* :bottom-right)
(setq *message-window-input-gravity* :bottom-right)
(setq *message-window-input-gravity* :bottom-right)

;;;;;;;;;;;
;; gaps  ;;
;;;;;;;;;;;

(load-module "swm-gaps")
(swm-gaps:toggle-gaps-off)
;; Head gaps run along the 4 borders of the monitor(s)
(setf swm-gaps:*head-gaps-size* 3)
;; Inner gaps run along all the 4 borders of a window
(setf swm-gaps:*inner-gaps-size* 3)
;; Outer gaps add more padding to the outermost borders of a window (touching
;; the screen border)
(setf swm-gaps:*outer-gaps-size* 3)
(swm-gaps:toggle-gaps-on)

;;;;;;;;;;
;; font ;;
;;;;;;;;;;

;; git clone git@github.com:LispLima/clx-truetype.git ~/quicklisp/local-projects/clx-truetype
(ql:quickload "clx-truetype")
(load-module "ttf-fonts")
(clx-truetype:cache-font-file "/usr/share/fonts/TTF/JetBrainsMono-Medium.ttf")
(set-font
 (make-instance 'xft:font
                :family "JetBrains Mono"
                :subfamily "Regular"
                :size 16
                :antialias t))
