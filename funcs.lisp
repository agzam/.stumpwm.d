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

(defcommand run-and-float (cmd params) ((:string) (:string))
  "Runs shell command and immediately floats the resulting window"
  (run-shell-command (concat cmd " " params))
  (sleep 0.5)
  (let ((win (car (act-on-matching-windows
                      (w)
                      (string-equal (slot-value w 'res) cmd)
                      w))))
    (float-window win (current-group))))

(ql:quickload :closer-mop)

(defun get-all-slot-vals (obj)
  "Returns all slot values for a given CLOS Object"
  (mapcar #'closer-mop:slot-definition-name (closer-mop:class-slots (class-of obj))))
