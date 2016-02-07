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

;; TAB indentation
(global-set-key (kbd "TAB") 'tab-to-tab-stop)
(setq-default tab-always-indent nil)  ; just insert a TAB, don't indent the line
(setq-default indent-tabs-mode  nil)  ; replace TABs with spaces
(setq-default tab-width 4)

(defun toggle-tabs ()
    (interactive)
    (setq indent-tabs-mode (if (eq indent-tabs-mode t) nil t))
    (setq tab-width (if (= tab-width 8) 4 8))
    (message "set tab-width=%d indent-tabs-mode=%s" tab-width indent-tabs-mode)
    (redraw-display)
    )

;; answer yes/no questions with y/n
(fset 'yes-or-no-p 'y-or-n-p)

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

;; disable blinking cursor
(blink-cursor-mode 0)

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
                    (evil-leader/set-key
                        ;; togglers
                        "tt" 'toggle-tabs
                        "tw" 'toggle-truncate-lines
                        "tl" 'whitespace-mode
                        "te" 'view-mode
                        "ts" 'ispell
                        "tg" 'toggle-color-theme

                        ;; edit config file
                        "ve" '(lambda () (interactive) (find-file "~/.emacs"))
                        "vs" '(lambda () (interactive) (load-file "~/.emacs"))

                        ;; window handling
                        "w=" 'balance-windows
                        "wf" 'evil-window-set-height
                        "wn" 'evil-window-new
                        "wp" 'evil-window-prev
                        "ws" 'evil-window-split
                        "wv" 'evil-window-vsplit
                        "cc" 'evil-window-delete

                        ;; window navigation
                        "h"  'evil-window-left
                        "j"  'evil-window-down
                        "k"  'evil-window-up
                        "l"  'evil-window-right

                        ;; window closing
                        "cj" '(lambda () (interactive)
                                  (evil-window-down 1) (evil-window-delete))
                        "ck" '(lambda () (interactive)
                                  (evil-window-up 1) (evil-window-delete))
                        "ch" '(lambda () (interactive)
                                  (evil-window-left 1) (evil-window-delete))
                        "cl" '(lambda () (interactive)
                                  (evil-window-right 1) (evil-window-delete))
                    )
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
  :config  (setq evilem-style 'at)
           (evilem-default-keybindings "C-\\"))

; evil-ediff {{{3
(use-package evil-ediff)

; evil-escape {{{3
(use-package evil-escape
  :config  (global-set-key (kbd "<escape>") 'evil-escape)
           (evil-escape-mode))

; evil-exchange {{{3
(use-package evil-exchange
  :config  ;(evil-exchange-install)
           ; experimental, if doesn't work use default init command above
           (evil-exchange-cx-install))

; evil-god-state {{{3
(use-package evil-god-state
  :config  ;(bind-key "SPC" 'god-local-mode            global-map)
           (bind-key "SPC" 'evil-execute-in-god-state evil-normal-state-map))

; evil-indent-plus {{{3
(use-package evil-indent-plus
  :config  (evil-indent-plus-default-bindings))

; evil-jumper {{{3
(use-package evil-jumper)

; evil-magit {{{3
(use-package evil-magit
  :config  (evil-define-key evil-magit-state magit-mode-map "?" 'evil-search-backward))

; evil-matchit {{{3
(use-package evil-matchit
  :config  (global-evil-matchit-mode 1))

; evil-mc {{{3
(use-package evil-mc
  :config  (global-evil-mc-mode 1))

; evil-nerd-commenter {{{3
(use-package evil-nerd-commenter
  :config  (bind-key "\\cc" 'evilnc-comment-or-uncomment-lines evil-normal-state-map)
           (bind-key "\\cy" 'evilnc-copy-and-comment-lines     evil-normal-state-map)
  )

; evil-org {{{3
(use-package evil-org)

; evil-rsi {{{3
(use-package evil-rsi
  :config  (evil-rsi-mode))

; evil-search-highlight-persist {{{3
(use-package evil-search-highlight-persist
  :config  (evil-leader/set-key "tn" 'evil-search-highlight-persist-remove-all)
           (global-evil-search-highlight-persist t))

; evil-surround {{{3
(use-package evil-surround
  :config  (global-evil-surround-mode 1))

; evil-textobj-column {{{3
(use-package evil-textobj-column
  :config  (bind-key "c" 'evil-textobj-column-word evil-inner-text-objects-map)
           (bind-key "C" 'evil-textobj-column-WORD evil-inner-text-objects-map)
  )

; evil-visualstar {{{3
(use-package evil-visualstar
  :config  (global-evil-visualstar-mode))

; neotree ---------------------------------- {{{2
(use-package neotree
  :config  (global-set-key [f8] 'neotree-toggle))

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

