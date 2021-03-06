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
