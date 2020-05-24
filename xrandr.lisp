(in-package #:stumpwm)

(import 'arrows:->>)

(defun xrandr/get-connected-display-names ()
  (->>
   (run-shell-command "xrandr | grep ' connected '" t)
   (split-string)
   (mapcar (lambda (x) (ppcre:scan-to-strings "[^ ]*" x)))))

(defun xrandr/define-xranrd-keys ()
  "Binds s-C-n for every different xrandr mode"
  (let* ((fmt (lambda (s) (apply 'format nil s (xrandr/get-connected-display-names))))
         (xrandr-modes
           `((laptop . ,(funcall fmt "xrandr --output ~a --auto --output ~a --off"))
             (external-home . ,(funcall fmt "xrandr --output ~a --off --output ~a --auto") )
             (laptop+external-home . ,(funcall fmt "xrandr --output ~a --auto --output ~a --right-of ~0@*~a --auto --primary")))))
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
        (define-key *top-map* key cmd)))))

(xrandr/define-xranrd-keys)
