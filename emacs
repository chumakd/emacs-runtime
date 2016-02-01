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
(use-package solarized-theme
  :config  (if (display-graphic-p)
               (load-theme 'solarized-dark t)))

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
  :init  (evil-mode 1)
  :bind  ("C-s" . evil-repeat-find-char-reverse) ; replace default ',' mapping
  )

;; unmap ',' to use it as a prefix
(define-key evil-normal-state-map ","   nil)

;; togglers
(define-key evil-normal-state-map ",tw" 'toggle-truncate-lines)

;; window handling
(define-key evil-normal-state-map ",w=" 'balance-windows)
(define-key evil-normal-state-map ",wf" 'evil-window-set-height)
(define-key evil-normal-state-map ",wn" 'evil-window-new)
(define-key evil-normal-state-map ",wp" 'evil-window-prev)
(define-key evil-normal-state-map ",ws" 'evil-window-split)
(define-key evil-normal-state-map ",wv" 'evil-window-vsplit)

;; window navigation
(define-key evil-normal-state-map ",h" 'evil-window-left)
(define-key evil-normal-state-map ",j" 'evil-window-down)
(define-key evil-normal-state-map ",k" 'evil-window-up)
(define-key evil-normal-state-map ",l" 'evil-window-right)

; magit ------------------------------------ {{{2
(use-package magit)

; powerline -------------------------------- {{{2
(use-package powerline
  :config  (if (display-graphic-p)
               (powerline-center-evil-theme)))

; rainbow-delimiters ----------------------- {{{2
;(use-package rainbow-delimiters
  ;:config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

; undo-tree -------------------------------- {{{2
(use-package undo-tree)

; web-mode --------------------------------- {{{2
(use-package web-mode)

; emacs auto-config ----------------------------------------------------- {{{1

