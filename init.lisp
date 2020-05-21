(ql:quickload :arrows)
(ql:quickload :swank)

(in-package #:stumpwm)
(run-shell-command "~/.xinitrc")

(require :swank)
(swank-loader:init)
(unless swank::*servers*
  (swank:create-server :port 4005
                       :style swank:*communication-style*
                       :dont-close t))

(defvar ag/init-directory
  (directory-namestring
   (truename (merge-pathnames (user-homedir-pathname) ".stumpwm.d")))
  "A directory with initially loaded files.")

(defun ag/load (module)
  "Load a lisp module from ~/.stumpwm.d."
  (let ((file (merge-pathnames (concat module ".lisp") ag/init-directory)))
    (if (probe-file file)
        (load file)
        (format *error-output* "File '~a' doesn't exist." file))))

(set-prefix-key (kbd "s-SPC"))
(setf *mouse-focus-policy* :click)
(setf *frame-number-map* "123456789abcdefghijklmnopqrstuvwxyz")

;; which-key-mode is always on
;; can't use it until https://github.com/stumpwm/stumpwm/issues/784 fixed
;; (add-hook *key-press-hook* 'which-key-mode-key-press-hook)

(ag/load "funcs")
(ag/load "media")
(ag/load "visuals")
(ag/load "emacs")
(ag/load "keybindings")
