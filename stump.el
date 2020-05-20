;; stump.el - Emacs helpers for StumpWM
;;
;; Copyright (c) 2020 Ag Ibragimov
;;
;;; Author: Ag Ibragimov <agzam.ibragimov@gmail.com>
;;
;;; License: MIT
;;

(defvar stump/previous-window-id
  "Last window that invoked `stump/edit-with-emacs'.")

(defvar stump/edit-with-emacs-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-c C-c") 'stump/finish-edit-with-emacs)
    (define-key map (kbd "C-c C-k") 'stump/cancel-edit-with-emacs)
    map))

(define-minor-mode stump/edit-with-emacs-mode
  "Minor mode enabled on buffers opened by StumpWM's edit-with-emacs"
  :init-value nil
  :lighter " editwithemacs"
  :keymap stump/edit-with-emacs-mode-map)

(defun run-stump-command (cmd)
  (call-process (executable-find "stumpish") nil 0 nil cmd))

(defun stump/edit-with-emacs (&optional window-id win-class dont-yank?)
  (let* ((buf-name (concat "*edit-with-emacs " win-class "*"))
         (buffer (get-buffer-create buf-name)))
    (setq stump/previous-window-id window-id)
    (with-current-buffer buffer
      (delete-region (point-min) (point-max))
      (unless dont-yank? (clipboard-yank))
      (deactivate-mark)
      (stump/edit-with-emacs-mode 1))
    (switch-to-buffer buffer))
  (run-hook-with-args 'stump/edit-with-emacs-hook buf-name window-id title))

(defun stump/finish-edit-with-emacs ()
  (interactive)
  (clipboard-kill-ring-save (point-min) (point-max))
  (kill-buffer)
  (run-stump-command
   (concat "finish-edit-with-emacs " stump/previous-window-id " y"))
  (setq stump/previous-window-id nil))

(defun stump/cancel-edit-with-emacs ()
  (interactive)
  (kill-buffer)
  (run-stump-command (concat "finish-edit-with-emacs " stump/previous-window-id))
  (setq stump/previous-window-id nil))

(provide 'stump)

;;; stump.el ends here
