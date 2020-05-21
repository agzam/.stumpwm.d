(in-package #:stumpwm)

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

(defcommand media-app
  () ()
  (run-shell-command "gpmdp"))

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
