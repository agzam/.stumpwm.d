(in-package #:stumpwm)

(defcommand run-shell-command-and-pop (cmd)
    ((:shell "/bin/sh -c "))
  "Runs the comand and pops to the top menu. Useful for binding in interactive keymaps."
  (stumpwm::run-prog *shell-program* :args (list "-c" cmd) :wait nil)
  (pop-top-map))

(defun within-split-p (&rest windows)
  "Returns T if windows are on the same display and all are visible, i.e. in a split."
  (let* ((wins (flatten windows))
         (frames (mapcar 'window-head wins)))
    (and (apply 'eq frames)
         (every 'window-visible-p wins))))
