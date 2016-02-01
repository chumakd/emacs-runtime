;; ---------------------------------------------------------------------- {{{1
;; vim: filetype=lisp  expandtab foldmethod=marker

; Packages -------------------------------------------------------------- {{{1

;; repositories
(setq         package-archives  '(("gnu"   . "https://elpa.gnu.org/packages/")))
(add-to-list 'package-archives  '( "melpa" . "https://melpa.org/packages/"))
;(add-to-list 'package-archives  '( "marmalade" . "https://marmalade-repo.org/packages/"))
;; or use mepla stable versions
;(add-to-list 'package-archives  '( "melpa-stable" . "https://melpa.org/packages/"))

;; activate all the packages
(package-initialize)

;; install use-package
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

(setq use-package-always-ensure t)
(require 'use-package)

; GUI ------------------------------------------------------------------- {{{1

;; color theme
(defvar default-color-theme   'solarized-dark)
(defvar alternate-color-theme 'solarized-light)
(defvar current-color-theme    default-color-theme)

(defun  toggle-color-theme ()
    (interactive)
    (disable-theme current-color-theme)
    (load-theme    alternate-color-theme t)
    ;; swap current with alternate
    (setq current-color-theme
          (prog1 alternate-color-theme
                 (setq alternate-color-theme current-color-theme))))

(use-package solarized-theme
  :config  (if (display-graphic-p)
               (load-theme current-color-theme t)))

;; font
(if (display-graphic-p)
    (when (eq system-type 'darwin)
          (set-face-attribute 'default nil :family "Input")
          (set-face-attribute 'default nil :height 170)))

;; interface
(when (display-graphic-p)
      (tool-bar-mode -1)              ; disable toolbar
      (scroll-bar-mode -1)            ; disable scrollbars
      (setq inhibit-splash-screen t)  ; disable welcome screen
      )

;; window size and position
(when (display-graphic-p)
      (set-frame-position (selected-frame) 300 0)
      (add-to-list 'default-frame-alist '(width  . 80))
      (add-to-list 'default-frame-alist '(height . 38)))

; Options --------------------------------------------------------------- {{{1

;; disable line wrapping
(set-default 'truncate-lines t)

;; enable line numbers
(set-default 'column-number-mode t)

;; highlight matching parenthesis
(setq show-paren-delay 0)
(show-paren-mode 1)

;; disable menu in console
(if (not (display-graphic-p))
    (menu-bar-mode -1))

;; scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))  ;; one line at a time
;(setq mouse-wheel-progressive-speed nil)             ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                   ;; scroll window under mouse
(setq scroll-step 1)                                 ;; keyboard scroll one line at a time

;; always follow symlinks to version controlled files
(setq vc-follow-symlinks t)

; Key-binding ----------------------------------------------------------- {{{1

;; map help-key to C-? and use C-h as backspace
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-,") 'help-command)

; Modes ----------------------------------------------------------------- {{{1

; auto-complete ---------------------------- {{{2
(use-package auto-complete
  :config (ac-config-default))

; evil mode -------------------------------- {{{2
(use-package evil
  :init
         ;; key bindings using evil leader
         ;;   it should be initialized before evil mode
         (use-package evil-leader
           :init    (global-evil-leader-mode)
           :config  (evil-leader/set-leader ",")
                    ;; togglers
                    (evil-leader/set-key "tw" 'toggle-truncate-lines)
                    (evil-leader/set-key "tg" 'toggle-color-theme)
                    ;; window handling
                    (evil-leader/set-key "w=" 'balance-windows)
                    (evil-leader/set-key "wf" 'evil-window-set-height)
                    (evil-leader/set-key "wn" 'evil-window-new)
                    (evil-leader/set-key "wp" 'evil-window-prev)
                    (evil-leader/set-key "ws" 'evil-window-split)
                    (evil-leader/set-key "wv" 'evil-window-vsplit)
                    (evil-leader/set-key "cc" 'evil-window-delete)
                    ;; window navigation
                    (evil-leader/set-key "h"  'evil-window-left)
                    (evil-leader/set-key "j"  'evil-window-down)
                    (evil-leader/set-key "k"  'evil-window-up)
                    (evil-leader/set-key "l"  'evil-window-right)
           )

         ;; evil init
         (evil-mode 1)

         ;; replace default ',' key mapping, as it's used for evil-leader
         (bind-key "C-s" 'evil-repeat-find-char-reverse evil-normal-state-map)
  )

; magit ------------------------------------ {{{2
(use-package magit)

; powerline -------------------------------- {{{2
(use-package powerline
  :config  (if (display-graphic-p)
               (powerline-center-evil-theme)))

; rainbow-delimiters ----------------------- {{{2
(use-package rainbow-delimiters
  :config (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
          (add-hook 'lisp-mode-hook       #'rainbow-delimiters-mode))

; undo-tree -------------------------------- {{{2
(use-package undo-tree)

; web-mode --------------------------------- {{{2
(use-package web-mode)

; emacs auto-config ----------------------------------------------------- {{{1

