;; vim: filetype=lisp

;; Vim emulation
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; GUD mode (GDB-UI)
;(setq gdb-use-separate-io-buffer t)

;; Color theme
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
(color-theme-hober)

;; example of how to create a key binding
;(global-set-key (kbd "C-c %") 'query-replace-regexp)

;; example of how to create an alias which could be use with M-x
;; in this example it would be M-x qrr
;(defalias 'qrr 'query-replace-regexp)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((scroll-step . 1) (c-indentation-style . "K&R")))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
