(in-package #:stumpwm)

;;;;;;;;;;;;;
;; visuals ;;
;;;;;;;;;;;;;

;; use orange-circle instead of the default square cursor
(setf *grab-pointer-character* 25)
(setf *grab-pointer-character-mask* 25)
(setf *grab-pointer-foreground* (xlib:make-color :red 1 :green 0.7 :blue 0))

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
(import 'arrows:->>)
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
;; you can generate these values using arandr
(setf xrandr-modes
      '((laptop . "xrandr --output DP1 --off --output eDP1 --primary")
        (external-home . "xrandr --output eDP1 --off --output DP1 --primary")
        (laptop+external-home . "xrandr --output eDP1 --mode 1920x1080 --pos 0x769 --rotate normal --output DP1 --primary --mode 2560x1440 --pos 1920x0 --rotate normal --output DP2 --off --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off")))

(dotimes (i (length xrandr-modes))
  (let ((key (->> (+ i 1)
                  (write-to-string)
                  (concat "s-C-")
                  (kbd)))
        (cmd (->> xrandr-modes
                  (nth i)
                  (cdr)
                  (concat "run-shell-command "))))
    (undefine-key *top-map* key)
    (define-key *top-map* key cmd)))
