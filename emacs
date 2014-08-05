;; vim: filetype=lisp

;; GUD mode (GDB-UI)
;(setq gdb-use-separate-io-buffer t)

;; Vim emulation
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; Color theme
(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)
(setq color-theme-is-global t)
;(eval-after-load "color-theme"
  ;'(progn
     ;(color-theme-initialize)
     ;(color-theme-solarized-dark)))

;; Solarized color theme
(add-to-list 'load-path "~/.emacs.d/emacs-color-theme-solarized")
(require 'color-theme-solarized)
(setq solarized-termcolors 256)
(color-theme-solarized-dark)
(if (>= emacs-major-version 24)
    (progn (add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
           (load-theme 'solarized-dark t)))

;; magit - a Git interface
(add-to-list 'load-path "~/.emacs.d/magit")
;(require 'magit)

;; Org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
;(require 'org-mode)

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
 '(column-number-mode t)
 '(custom-safe-themes (quote ("1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(font-use-system-font t)
 '(safe-local-variable-values (quote ((scroll-step . 1) (c-indentation-style . "K&R"))))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
