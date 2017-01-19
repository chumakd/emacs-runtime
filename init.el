;; -*- mode: emacs-lisp -*-
;; ---------------------------------------------------------------------- {{{1
;; vim: filetype=lisp  expandtab  shiftwidth=2  foldmethod=marker

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

;; tell use-package to install missing packages automatically
(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

; GUI ------------------------------------------------------------------- {{{1

;; color theme ----------------------------- {{{2
(use-package solarized-theme)

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

(if (display-graphic-p)
    (load-theme current-color-theme t)
    (if (string-match "^Solarized" (getenv "ITERM_PROFILE"))
        (load-theme current-color-theme t)
        (load-theme 'wombat t)))

;; font ------------------------------------ {{{2
(if (display-graphic-p)
    (when (eq system-type 'darwin)
          (set-face-attribute 'default nil :family "Input")
          (set-face-attribute 'default nil :height 170)))

;; interface ------------------------------- {{{2
(when (display-graphic-p)
      (tool-bar-mode -1)              ; disable toolbar
      (scroll-bar-mode -1)            ; disable scrollbars
      )

;; window size and position ---------------- {{{2
(when (display-graphic-p)
      (set-frame-position (selected-frame) 300 0)
      (add-to-list 'default-frame-alist '(width  . 80))
      (add-to-list 'default-frame-alist '(height . 38)))

; Options --------------------------------------------------------------- {{{1

;; disable welcome screen
(setq inhibit-splash-screen t)

;; default type for new buffers
(setq-default major-mode 'text-mode)

;; disable line wrapping
(setq-default truncate-lines t)

;; enable line numbers
(setq-default column-number-mode t)

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
(setq auto-save-file-name-transforms  '((".*" "~/.emacs.d/backup" t)))

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

;; map help-key to C-, and use C-h as backspace
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-,") 'help-command)

; Modes ----------------------------------------------------------------- {{{1

; auto-complete ---------------------------- {{{2
;(use-package auto-complete
  ;:config (ac-config-default))

; company ---------------------------------- {{{2
(use-package company
  :diminish ""
  :config (global-company-mode))

(use-package company-quickhelp
  :config (company-quickhelp-mode 1))

(use-package company-irony
  :config (add-to-list 'company-backends 'company-irony))

; editorconfig ----------------------------- {{{2
(use-package editorconfig
  :diminish ""
  :config (editorconfig-mode 1))

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
                        "tq" 'helm-resume

                        ;; edit config file
                        "ve" '(lambda () (interactive) (find-file "~/.emacs.d/init.el"))
                        "vs" '(lambda () (interactive) (load-file "~/.emacs.d/init.el"))

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

         ;; alternative help-command mapping
         (bind-key "\\h"  'help-command                   evil-normal-state-map)
         ;; replace default ',' key mapping, as it's used for evil-leader
         (bind-key "C-s"  'evil-repeat-find-char-reverse  evil-normal-state-map)
         ;; vim's ':qa!' equivalent
         (bind-key "Z A"  'kill-emacs                     evil-normal-state-map)

         ;; don't jump to next item on search, just highlight the current one
         (defadvice evil-search-word-forward
             (after advice-for-evil-search-word-forward activate)
             (evil-search-previous))
         (defadvice evil-search-word-backward
             (after advice-for-evil-search-word-backward activate)
             (evil-search-previous))
  )

; evil-anzu {{{3
(use-package evil-anzu)

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
  :diminish ""
  :config  (global-evil-mc-mode 1))

; evil-nerd-commenter {{{3
(use-package evil-nerd-commenter
  :config  (bind-key "\\cc" 'evilnc-comment-or-uncomment-lines evil-normal-state-map)
           (bind-key "\\cy" 'evilnc-copy-and-comment-lines     evil-normal-state-map)
  )

; evil-numbers {{{3
(use-package evil-numbers)

; evil-org {{{3
(use-package evil-org)

; evil-rsi {{{3
(use-package evil-rsi)
  ; disabled by default, cause it messes up with C-e in normal mode
  ;:config  (evil-rsi-mode))

; evil-search-highlight-persist {{{3
(use-package evil-search-highlight-persist
  :config  (evil-leader/set-key "tn" 'evil-search-highlight-persist-remove-all)
           (global-evil-search-highlight-persist t))

; evil-smartparens {{{3
(use-package evil-smartparens
  :config  (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

; evil-surround {{{3
(use-package evil-surround
  :config  (global-evil-surround-mode 1))

; evil-tabs {{{3
;; disabled, because it's still very raw
;(use-package evil-tabs
;  :config  (global-evil-tabs-mode t))

; evil-textobj-column {{{3
(use-package evil-textobj-column
  :config  (bind-key "c" 'evil-textobj-column-word evil-inner-text-objects-map)
           (bind-key "C" 'evil-textobj-column-WORD evil-inner-text-objects-map)
  )

; evil-visual-mark-mode {{{3
(use-package evil-visual-mark-mode)

; evil-visual-replace {{{3
(use-package evil-visual-replace)

; evil-visualstar {{{3
(use-package evil-visualstar
  :config  (global-evil-visualstar-mode))

; expand-region ---------------------------- {{{2
(use-package expand-region
  :config  (bind-key "+"  'er/expand-region  evil-normal-state-map))

; eyebrowse -------------------------------- {{{2
(use-package eyebrowse
  :config  (define-key evil-motion-state-map (kbd "gt") 'eyebrowse-next-window-config)
           (define-key evil-motion-state-map (kbd "gT") 'eyebrowse-prev-window-config)
           (evil-leader/set-key "wt" 'eyebrowse-create-window-config)
           (evil-leader/set-key "ct" 'eyebrowse-close-window-config)
           (setq eyebrowse-new-workspace t)
           (eyebrowse-mode t)
  )

; fill-column-indicator -------------------- {{{2
(use-package fill-column-indicator
  :config  (evil-leader/set-key "tc" 'fci-mode)
           (setq-default fill-column 80))

; flx-ido ---------------------------------- {{{2
(use-package flx-ido
  :config  (ido-mode 1)
           (ido-everywhere 1)
           (flx-ido-mode 1)
           (setq ido-enable-flex-matching t)  ; disable ido faces to see flx highlights.
           (setq ido-use-faces nil)
  )

; flycheck --------------------------------- {{{2
(use-package flycheck)

(use-package flycheck-bashate
  :config  (flycheck-bashate-setup))

(use-package flycheck-checkbashisms
  :config  (flycheck-checkbashisms-setup))

(use-package flycheck-color-mode-line
  :config  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))

(use-package flycheck-irony
  :config  (add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

; fzf -------------------------------------- {{{2
(use-package fzf
  :config  (evil-leader/set-key "ff" 'fzf))

; helm ------------------------------------- {{{2
(use-package helm
  :init    (require 'helm-config)
  :config  (setq helm-case-fold-search                  'smart
                 ;helm-split-window-default-side         'same
                 helm-mode-fuzzy-match                  t
                 helm-completion-in-region-fuzzy-match  t)

           ;; prevent helm from overriding existing ^h mappings
           ;; (e.g. if it's set to backspace)
           (define-key helm-map (kbd "C-h") nil)
           (bind-key "\\be" 'helm-mini  evil-normal-state-map)
           (bind-key "\\ul" 'helm-occur evil-normal-state-map)
           (bind-key "\\uf" 'helm-projectile-find-file evil-normal-state-map)

           (require 'helm-adaptive)
           (helm-adaptive-mode 1)

           (require 'helm-ring)
           (helm-push-mark-mode 1)

           ;; popup buffer-name or filename in grep/moccur/imenu-all etc...
           (require 'helm-utils)
           (helm-popup-tip-mode 1)

           ;(helm-mode 1)
  )

(use-package helm-flx
  :config  (helm-flx-mode +1))

(use-package helm-fuzzier
  :config  (helm-fuzzier-mode 1))

(use-package helm-ag
  :config  (setq helm-ag-insert-at-point 'word)
           (defalias 'Ag  'helm-ag)
           (defalias 'Ack 'Ag)
           (defalias 'Gg  'helm-grep-do-git-grep)
           (evil-leader/set-key "gg" 'Gg))

(use-package helm-cscope
  :diminish "h-cs"
  :config  (add-hook 'c-mode-common-hook 'helm-cscope-mode)
           (evil-define-key 'normal helm-cscope-mode-map
              (kbd "C-q s") 'helm-cscope-find-this-symbol
              (kbd "C-q g") 'helm-cscope-find-global-definition
              (kbd "C-q d") 'helm-cscope-find-called-function
              (kbd "C-q c") 'helm-cscope-find-calling-this-funtcion
              (kbd "C-q a") 'helm-cscope-find-assignments-to-this-symbol)
  )

(use-package helm-css-scss
  :config  (setq helm-css-scss-split-direction  'split-window-vertically)
           (setq helm-css-scss-split-with-multiple-windows  nil))

(use-package helm-describe-modes)
(use-package helm-flycheck)
(use-package helm-ls-git)
(use-package helm-make)
(use-package helm-mode-manager)

(use-package helm-projectile
  :config  (helm-projectile-on))

(use-package helm-swoop
  :config  (setq helm-swoop-split-direction 'split-window-vertically)
           (setq helm-swoop-use-line-number-face t))

(use-package helm-themes)

; highlight -------------------------------- {{{2
(use-package highlight)

(use-package highlight-indentation
  :config  (evil-leader/set-key "ti" 'highlight-indentation-mode))

; hl --------------------------------------- {{{2
(use-package hl-anything)
(use-package hl-todo)

; indent-guide ----------------------------- {{{2
(use-package indent-guide)

; info+ ------------------------------------ {{{2
(use-package info+)

; irony ------------------------------------ {{{2
(use-package irony
  :config  (add-hook 'c++-mode-hook  'irony-mode)
           (add-hook 'c-mode-hook    'irony-mode)
           (add-hook 'objc-mode-hook 'irony-mode))

(use-package irony-eldoc
  :config  (add-hook 'irony-mode-hook 'irony-eldoc))

; magit ------------------------------------ {{{2
(use-package magit
  :config (evil-leader/set-key "gs" 'magit-status))

; move-text -------------------------------- {{{2
(use-package move-text)

; neotree ---------------------------------- {{{2
(use-package neotree
  :config  (global-set-key [f8] 'neotree-toggle)
           (evil-define-key 'normal neotree-mode-map (kbd "q")   'neotree-hide)
           (evil-define-key 'normal neotree-mode-map (kbd "RET") 'neotree-enter)
           (evil-define-key 'normal neotree-mode-map (kbd "o")   'neotree-enter)
  )

; open-junk-file --------------------------- {{{2
(use-package open-junk-file)

; origami ---------------------------------- {{{2
(use-package origami
  :config (bind-key "zo" 'origami-open-node               evil-normal-state-map)
          (bind-key "zO" 'origami-open-node-recursively   evil-normal-state-map)
          (bind-key "zv" 'origami-show-node               evil-normal-state-map)
          (bind-key "zV" 'origami-show-only-node          evil-normal-state-map)
          (bind-key "zc" 'origami-close-node              evil-normal-state-map)
          (bind-key "zC" 'origami-close-node-recursively  evil-normal-state-map)
          (bind-key "za" 'origami-forward-toggle-node     evil-normal-state-map)
          (bind-key "zA" 'origami-recursively-toggle-node evil-normal-state-map)
          (bind-key "zR" 'origami-open-all-nodes          evil-normal-state-map)
          (bind-key "zM" 'origami-close-all-nodes         evil-normal-state-map)
          (bind-key "zj" 'origami-next-fold               evil-normal-state-map)
          (bind-key "zk" 'origami-previous-fold           evil-normal-state-map)
          (bind-key "zn" '(lambda () (interactive) (origami-mode 0)) evil-normal-state-map)
          (bind-key "zN" '(lambda () (interactive) (origami-mode 1)) evil-normal-state-map)
  )

; projectile ------------------------------- {{{2
(use-package projectile
  :config  (setq projectile-switch-project-action 'helm-projectile)
           (setq projectile-completion-system     'helm)
           (projectile-global-mode))

; rainbow-delimiters ----------------------- {{{2
(use-package rainbow-delimiters
  :config (add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
          (add-hook 'lisp-mode-hook       #'rainbow-delimiters-mode))

; relative-line-numbers -------------------- {{{2
(use-package relative-line-numbers
  :disabled t
  :config  (global-relative-line-numbers-mode))

(use-package linum-relative
  :diminish ""
  :config  (setq linum-relative-format "%3s ")
           (setq linum-relative-current-symbol "->")
           ;; prevent from showing up in minibuffer
           (add-hook 'minibuffer-setup-hook (lambda () (linum-mode 0)))
           (linum-relative-global-mode))

(use-package nlinum-relative
  :disabled t
  :config  (setq nlinum-relative-redisplay-delay 0)
           (setq nlinum-relative-current-symbol  "->")
           (nlinum-relative-setup-evil)
           (global-nlinum-relative-mode))

; spaceline -------------------------------- {{{2
(use-package spaceline
  :config  (require 'spaceline-config)
           (setq powerline-default-separator nil)
           (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
           (spaceline-spacemacs-theme)
           (spaceline-toggle-window-number-off)
           (spaceline-info-mode))

; undo-tree -------------------------------- {{{2
(use-package undo-tree
  :diminish "")

; vi-tilde-fringe -------------------------- {{{2
;; FIXME: investigate runtime error:
;;        "Symbol’s function definition is void: define-fringe-bitmap"
;(use-package vi-tilde-fringe
;  :config  (global-vi-tilde-fringe-mode))

; volatile-highlights ---------------------- {{{2
(use-package volatile-highlights
  :diminish ""
  :config  (vhl/define-extension  'evil 'evil-paste-after 'evil-paste-before
                                  'evil-paste-pop 'evil-move)
           (vhl/install-extension 'evil)
           (vhl/define-extension  'undo-tree 'undo-tree-yank 'undo-tree-move)
           (vhl/install-extension 'undo-tree)
           (volatile-highlights-mode t))

; web-mode --------------------------------- {{{2
(use-package web-mode)

; which-key -------------------------------- {{{2
(use-package which-key
  :diminish ""
  :config  (which-key-mode))

; winum ------------------------------------ {{{2
(use-package winum
  :config  (setq winum-auto-setup-mode-line nil)
           (winum-mode))

; ws-butler -------------------------------- {{{2
(use-package ws-butler
  :diminish ""
  :config  (setq require-final-newline 1)
           ;(add-hook 'prog-mode-hook #'ws-butler-mode)
           (ws-butler-global-mode))

; yasnippet -------------------------------- {{{2
(use-package yasnippet
  :diminish yas-minor-mode ""
  :config  (yas-reload-all)
           (add-hook 'prog-mode-hook #'yas-minor-mode))

; ZZZ diminish ----------------------------- {{{2
;; should be near the end so that any minor modes will already have been
;; loaded by the time they're to be converted to diminished modes.
(use-package diminish
  :config (diminish 'abbrev-mode)
          (diminish 'jiggle-mode))

; emacs auto-config ----------------------------------------------------- {{{1

