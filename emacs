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

;; perform yes-or-no prompts using the echo area and keyboard input.
(setq use-dialog-box nil)

;; backups location
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))

;; weeks should begin on Monday
(setq calendar-week-start-day 1)

;; set PATH
(setenv "PATH" (concat "/opt/local/bin:" (getenv "PATH")))
(setq exec-path (cons "/opt/local/bin" exec-path))

;; highlight marked region
(transient-mark-mode t)

;; enable incremental minibuffer completion
(icomplete-mode t)

; Key-binding ----------------------------------------------------------- {{{1

;; map help-key to C-? and use C-h as backspace
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-,") 'help-command)

; Modes ----------------------------------------------------------------- {{{1

; auto-complete ---------------------------- {{{2
(use-package auto-complete
  :config (ac-config-default))

; evil mode -------------------------------- {{{2

; evil {{{3
(use-package evil
  :init
         ;; key bindings using evil leader
         ;;   it should be initialized before evil mode
         (use-package evil-leader
           :init    (global-evil-leader-mode)
           :config  (evil-leader/set-leader ",")
                    ;; togglers
                    (evil-leader/set-key "tw" 'toggle-truncate-lines)
                    (evil-leader/set-key "tl" 'whitespace-mode)
                    (evil-leader/set-key "te" 'view-mode)
                    (evil-leader/set-key "ts" 'ispell)
                    (evil-leader/set-key "tg" 'toggle-color-theme)
                    ;; edit config file
                    (evil-leader/set-key "ve" '(lambda () (interactive)
                                                   (find-file "~/.emacs")))
                    (evil-leader/set-key "vs" '(lambda () (interactive)
                                                   (load-file "~/.emacs")))
                    ;; window handling
                    (evil-leader/set-key "w=" 'balance-windows)
                    (evil-leader/set-key "wf" 'evil-window-set-height)
                    (evil-leader/set-key "wn" 'evil-window-new)
                    (evil-leader/set-key "wp" 'evil-window-prev)
                    (evil-leader/set-key "ws" 'evil-window-split)
                    (evil-leader/set-key "wv" 'evil-window-vsplit)
                    (evil-leader/set-key "cc" 'evil-window-delete)
                    ;; window closing
                    (evil-leader/set-key "cj" '(lambda () (interactive)
                                                 (evil-window-down 1) (evil-window-delete)))
                    (evil-leader/set-key "ck" '(lambda () (interactive)
                                                 (evil-window-up 1) (evil-window-delete)))
                    (evil-leader/set-key "ch" '(lambda () (interactive)
                                                 (evil-window-left 1) (evil-window-delete)))
                    (evil-leader/set-key "cl" '(lambda () (interactive)
                                                 (evil-window-right 1) (evil-window-delete)))
                    ;; window navigation
                    (evil-leader/set-key "h"  'evil-window-left)
                    (evil-leader/set-key "j"  'evil-window-down)
                    (evil-leader/set-key "k"  'evil-window-up)
                    (evil-leader/set-key "l"  'evil-window-right)
           )
  :config
         (evil-mode 1)
         ;(setq evil-intercept-esc 'always)

         ;; replace default ',' key mapping, as it's used for evil-leader
         (bind-key "C-s"  'evil-repeat-find-char-reverse  evil-normal-state-map)
         ;; vim's ':qa!' equivalent
         (bind-key "Z A"  'kill-emacs                     evil-normal-state-map)
  )

; evil-args {{{3
(use-package evil-args
  :config  (bind-key "a" 'evil-inner-arg evil-inner-text-objects-map)
           (bind-key "a" 'evil-outer-arg evil-outer-text-objects-map))

; evil-commentary {{{3
(use-package evil-commentary
  :config  (evil-commentary-mode))

; evil-easymotion {{{3
(use-package evil-easymotion
  :config  (evilem-default-keybindings "SPC"))

; evil-ediff {{{3
(use-package evil-ediff)

; evil-escape {{{3
(use-package evil-escape
  :config  (global-set-key (kbd "<escape>") 'evil-escape)
           (evil-escape-mode))

; magit ------------------------------------ {{{2
(use-package magit)

; powerline -------------------------------- {{{2
(use-package powerline-evil
  :config  (powerline-evil-vim-theme))

; rainbow-delimiters ----------------------- {{{2
(use-package rainbow-delimiters
  :config (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
          (add-hook 'lisp-mode-hook       #'rainbow-delimiters-mode))

; undo-tree -------------------------------- {{{2
(use-package undo-tree)

; web-mode --------------------------------- {{{2
(use-package web-mode)

; emacs auto-config ----------------------------------------------------- {{{1

