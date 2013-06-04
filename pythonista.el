;;; pythonista.el --- Preconfigured Python modes for Pythonista

;; Copyright (C) 2013 Takafumi Arakaki

;; Author: Takafumi Arakaki <aka.tkf at gmail.com>
;; Package-Requires: ((jedi "0.1.2"))
;; Version: 0.1.0

;; This file is NOT part of GNU Emacs.

;; pythonista.el is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; pythonista.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with pythonista.el.
;; If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(eval-when-compile (require 'python)
                   (require 'jedi nil t)
                   (require 'ein-notebooklist nil t)
                   (require 'ein-connect nil t)
                   (require 'ein-console nil t)
                   (require 'ein-junk nil t)
                   (require 'ein-ac nil t))


(defmacro pyt--eval-after-load (file-or-files &rest form)
  "Execute FORM when all the files in FILE-OR-FILES are loaded.
FORM is checked at compile time."
  (declare (debug (form form &rest form))
           (indent 1))
  (when (stringp file-or-files)
    (setq file-or-files (list file-or-files)))
  (let ((code `(progn ,@form)))
    (mapc (lambda (file)
            (setq code `(eval-after-load ',file ',code)))
          file-or-files)
    code))

(defvar pyt--run-once-used-keys nil)

(defmacro pyt--run-once (key &rest body)
  (declare (indent defun))
  (assert (symbolp (eval key)) nil "Key must be a symbol")
  `(unless (member ,key pyt--run-once-used-keys)
     (add-to-list 'pyt--run-once-used-keys ,key)
     ,@body))



;;; python

(let ((ipy (concat "python " (executable-find "ipython"))))
  (when ipy
    (setq python-shell-interpreter ipy
          python-shell-interpreter-args ""
          python-shell-prompt-regexp "In \\[[0-9]+\\]: "
          python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
          ;; IPython (>= 0.11)
          python-shell-completion-setup-code
          nil
          python-shell-completion-module-string-code "\
__import__('IPython.core.completerlib')\
.core.completerlib.module_completion('''%s''')\n"
          python-shell-completion-string-code
          "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")))

(add-to-list 'auto-mode-alist '("wscript\\'" . python-mode))



;;; smartrep
(pyt--eval-after-load (smartrep python)
  (smartrep-define-key
      python-mode-map
      "C-c"
    '(("C-p" . beginning-of-defun)
      ("C-n" . end-of-defun)
      (">"   . python-indent-shift-right)
      ("<"   . python-indent-shift-left))))



;;; Jedi
(add-hook 'python-mode-hook 'jedi:setup)



;;; EIN
(setq ein:use-auto-complete-superpack t
      ein:use-smartrep t)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)



;;; Ropemacs
(declare-function pymacs-load "pymacs")
(declare-function ropemacs-mode "ropemacs")

(defvar pythonista-ropemacs-load-hook nil)

(defun pyt--ropemacs-setup ()
  ;; Set `use-file-dialog' nil to prevent GUI pop-up.
  ;; I don't know if it is good for other mode, so make it buffer local.
  (set (make-local-variable 'use-file-dialog) nil)

  (pyt--run-once 'ropemacs-setup
    (require 'pymacs)
    (pymacs-load "ropemacs" "rope-")
    (run-hooks 'pythonista-ropemacs-load-hook)

    ;; The hook function (`ropemacs-mode') to enable ropemacs-mode is
    ;; just added to `python-mode-hook', so it won't be called this
    ;; time.  That's why I'm calling this manually here:
    (ropemacs-mode t)))

(add-hook 'python-mode-hook 'pyt--ropemacs-setup)

(provide 'pythonista)

;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:

;;; pythonista.el ends here
