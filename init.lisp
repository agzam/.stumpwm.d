(in-package :stumpwm)

(run-shell-command "~/.xinitrc")
(set-prefix-key (kbd "s-SPC"))
(setf *mouse-focus-policy* :click)

;; which-key-mode is always on
;; can't use it until https://github.com/stumpwm/stumpwm/issues/784 fixed
;; (add-hook *key-press-hook* 'which-key-mode-key-press-hook)

(defcommand run-shell-command-and-pop (cmd)
  ((:shell "/bin/sh -c "))
  "Runs the comand and pops to the top menu. Useful for binding in interactive keymaps."
  (stumpwm::run-prog *shell-program* :args (list "-c" cmd) :wait nil)
  (pop-top-map))

(setf *frame-number-map* "123456789abcdefghijklmnopqrstuvwxyz")
;;;;;;;;;;;;;;;;;
;; keybindings ;;
;;;;;;;;;;;;;;;;;

(define-key *top-map* (kbd "s-:") "colon")
(define-key *top-map* (kbd "s-!") "exec")
(define-key *top-map* (kbd "s-n") "pull-hidden-next")
(define-key *top-map* (kbd "s-p") "pull-hidden-previous")
(define-key *top-map* (kbd "C-s-ESC")
  "run-shell-command systemctl suspend")
(define-key *help-map*  (kbd "R") "loadrc")

(defvar *window-bindings* nil)
(setf *window-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "v") "hsplit")
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

;; remove when https://github.com/stumpwm/stumpwm/pull/786 merged
(defcommand (pull-from-windowlist2 tile-group) (&optional (fmt *window-format*)) (:rest)
    (let ((pulled-window (select-window-from-menu
                          (group-windows (current-group))
                          fmt)))
      (when pulled-window
        (pull-window pulled-window))))

(defvar *buffers-bindings* nil)
(setf *buffers-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "b") "pull-from-windowlist2 %n %c")
        (define-key m (kbd "d") "delete")
        (define-key m (kbd "D") "kill")
        m))
(define-key *root-map* (kbd "b") '*buffers-bindings*)

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
       ("s-r" . "C-r")
       ("s-L" . "C-l")
       ("s-0" . "C-0")
       ("s-1" . "C-1")
       ("s-2" . "C-2")
       ("s-3" . "C-3")
       ("s-4" . "C-4")
       ("s-5" . "C-5")
       ("s-6" . "C-6")
       ("s-7" . "C-7")
       ("s-8" . "C-8")
       ("s-9" . "C-9")
       )))

;;;;;;;;;;;;;
;; visuals ;;
;;;;;;;;;;;;;

(setq *message-window-gravity* :bottom-right)
(setq *message-window-input-gravity* :bottom-right)
(setq *message-window-input-gravity* :bottom-right)
(setf *window-border-style* :thick)
(set-focus-color "olivedrab")
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
(clx-truetype:cache-fonts)
(clx-truetype:cache-font-file "/usr/share/fonts/TTF/JetBrainsMono-Medium.ttf")
(set-font
 (make-instance 'xft:font
                :family "JetBrains Mono"
                :subfamily "Regular"
                :size 16
                :antialias t))

;;;;;;;;;;;;
;; xrandr ;;
;;;;;;;;;;;;

(defvar xrandr-modes nil)
(setf xrandr-modes
      '((laptop . "xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP2 --off")
        (external-home . "xrandr --output eDP1 --off --output DP2 --primary --mode 2560x1440")
        (laptop+external-home . "xrandr --output eDP1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP2 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off")))

(dotimes (i (length xrandr-modes))
  (let ((k (kbd (concatenate
                 'string "s-C-"
                 (write-to-string (+ 1 i)))))
        (cmd (concatenate
              'string "run-shell-command "
              (cdr (nth i xrandr-modes)))))
    (define-key *top-map* k cmd)))

;;;;;;;;;;;
;; media ;;
;;;;;;;;;;;

(defcommand volume-up () () (run-shell-command "xdotool key --delay 1 XF86AudioRaiseVolume"))
(defcommand volume-down () () (run-shell-command "xdotool key --delay 1 XF86AudioLowerVolume"))
(defcommand volume-mute
    () ()
    (run-shell-command "xdotool key --delay 1 XF86AudioMute")
    (pop-top-map))

(defcommand audio-toggle-play
    () ()
    (run-shell-command "xdotool key --delay 1 XF86AudioPlay")
    (message "Toggle media play/pause")
    (pop-top-map))

(defcommand media-prev
    () ()
    (run-shell-command "xdotool key --delay 1 XF86AudioPrev")
    (message "Previous song")
    (pop-top-map))

(defcommand media-next
    () ()
    (run-shell-command "xdotool key --delay 1 XF86AudioNext")
    (message "Next song")
    (pop-top-map))

(define-interactive-keymap imedia
    ()
  ((kbd "k") "volume-up")
  ((kbd "j") "volume-down")
  ((kbd "m") "volume-mute")
  ((kbd "h") "media-prev")
  ((kbd "l") "media-next")
  ((kbd "s") "audio-toggle-play")
  ((kbd "SPC") "audio-toggle-play")
  ((kbd "a") "run-shell-command-and-pop gpmdp")
  ((kbd "p") "run-shell-command-and-pop pavucontrol"))

(undefine-key *root-map* (kbd "m"))
(define-key *root-map* (kbd "m") "imedia")

;;;;;;;;;;
;; apps ;;
;;;;;;;;;;
(defcommand browser () () (run-or-raise "brave" '(:class "Brave-browser")))

(defvar *apps-bindings* nil)
(setf *apps-bindings*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "g") "browser")
        (define-key m (kbd "e") "emacs")
        (define-key m (kbd "m") "media-app")
        (define-key m (kbd "t") "run-shell-command terminator")
        (define-key m (kbd "T") "run-shell-command telegram-desktop")
        m))

(define-key *root-map* (kbd "a") '*apps-bindings*)
