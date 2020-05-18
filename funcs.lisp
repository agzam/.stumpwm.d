(in-package #:stumpwm)

(defcommand run-shell-command-and-pop (cmd)
    ((:shell "/bin/sh -c "))
  "Runs the comand and pops to the top menu. Useful for binding in interactive keymaps."
  (stumpwm::run-prog *shell-program* :args (list "-c" cmd) :wait nil)
  (pop-top-map))
