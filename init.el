(defun find-config ()
  "Edit init.org"
  (interactive)
  (find-file (concat user-emacs-directory "init.org")))

(defun load-init ()
  "Run tangle, load and byte-compile init.org"
  (interactive)
  (find-file (concat user-emacs-directory "init.org"))
  (org-babel-tangle)
  (load-file (concat user-emacs-directory "init.el"))
  (byte-compile-file (concat user-emacs-directory "init.el")))

(require 'package)

(unless (assoc-default "melpa" package-archives)
  (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
  (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t))
(setq package-enable-at-startup nil)

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)

(setq use-package-always-ensure t)

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(setq-default
 display-time 1
 display-time-24hr-format t
 display-time-day-and-date nil
 display-time-default-load-average nil)
(display-time-mode)

(setq select-enable-clipboard t
      select-enable-primary t)

(add-hook 'before-save-hook 'whitespace-cleanup)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq locate-command "mdfind")
(setq ns-pop-up-frames nil)
;; Some mac-bindings interfere with Emacs bindings.
(when (boundp 'mac-pass-command-to-system)
      (setq mac-pass-command-to-system nil))

(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
      (if (equal 'fullboth current-value)
        (if (boundp 'old-fullscreen) old-fullscreen nil)
        (progn (setq old-fullscreen current-value)
          'fullboth)))))
(global-set-key [f12] 'toggle-frame-fullscreen)

(push ".ibc" completion-ignored-extensions) ;; idris bytecode
(push ".aux" completion-ignored-extensions) ;; latex
(setq counsel-find-file-ignore-regexp "\\.ibc\\'")
(setq counsel-find-file-ignore-regexp "\\.aux\\'")

(setq frame-title-format '("" "%b @ %f"))        ; window title
(setq inhibit-startup-message t)     ; dont show the GNU splash screen
(transient-mark-mode t)              ; show selection from mark
(if (display-graphic-p)
    (progn
      (tool-bar-mode -1)             ; disable toolbar
      (menu-bar-mode -1)             ; disable menu bar
      (scroll-bar-mode -1)))         ; disable scroll bar
(blink-cursor-mode 0)                ; disable blinking cursor

(mouse-avoidance-mode 'jump)         ; jump mouse away when typing
(setq visible-bell nil)                ; turn off bip warnings
(auto-compression-mode 1)            ; browse tar archives
(put 'upcase-region 'disabled nil)   ; enable ``upcase-region''
(put 'set-goal-column 'disabled nil) ; enable column positioning
(setq column-number-mode t)          ; show column number
(setq case-fold-search t)            ; make search ignore case
(global-linum-mode 0)                ; global line numbers
(fset 'yes-or-no-p 'y-or-n-p)        ; short-hand yes/no selection
(ido-mode 1)                         ; interactive DO mode (better file opening and buffer switching)
(setq-default indent-tabs-mode nil)  ; tabs over spaces
(delete-selection-mode +1)           ; type over a selected region, instead of deleting before typing.
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ; start full screen
(global-auto-revert-mode t)          ; automatically reload buffers when file has changed

(global-unset-key (kbd "<M-drag-mouse-1>"))   ; was mouse-set-secondary
(global-unset-key (kbd "<M-down-mouse-1>"))   ; was mouse-drag-secondary
(global-unset-key (kbd "<M-mouse-1>"))        ; was mouse-start-secondary
(global-unset-key (kbd "<M-mouse-2>"))        ; was mouse-yank-secondary
(global-unset-key (kbd "<M-mouse-3>"))        ; was mouse-secondary-save-then-kill

(setq default-directory "~/Documents/")        ; set default directory to be documents

(global-hl-line-mode +1)

(use-package ivy
  :demand
  :config
  (setq ivy-use-virtual-buffers t)
  (setq ivy-height 12)
  (setq ivy-count-format "%d/%d | ")
  (setq ivy-extra-directories nil)
  (setq ivy-display-style 'fancy)
  (setq magit-completing-read-function 'ivy-completing-read)

  (defun save-ivy-views ()
    "Save all current Ivy views to file."
    (interactive)
    (with-temp-file "~/.emacs.d/ivy-views"
    (prin1 ivy-views (current-buffer))
    (message "saving ivy-views to ~/.emacs.d/ivy-views")))

  (defun load-ivy-views ()
    "Load all stored Ivy views."
    (interactive)
    (if (file-exists-p "~/.emacs.d/ivy-views")
        (setq ivy-views
          (with-temp-buffer
            (insert-file-contents "~/.emacs.d/ivy-views")
            (read (current-buffer)))))
    (message "load ivy-views"))
  (load-ivy-views)
)

(use-package swiper
  :demand
  :config
  )

(use-package counsel
  :demand
  :defer t
  :bind*
  (( "C-s" . counsel-grep-or-swiper)
   ( "M-g g" . counsel-rg)
   ( "M-i" . counsel-imenu)
   ( "M-x" . counsel-M-x)
   ( "C-x C-f" . counsel-find-file)
   ( "<f1> f" . counsel-describe-function)
   ( "<f1> v" . counsel-describe-variable)
   ( "<f1> l" . counsel-load-library)
   ( "<f2> i" . counsel-info-lookup-symbol)
   ( "<f2> u" . counsel-unicode-char)
   ( "C-h b" . counsel-descbinds)
   ( "C-c g" . counsel-git)
   ( "C-c j" . counsel-git-grep)
   ( "C-c k" . counsel-ag)
   ( "C-x l" . locate-counsel)
   ( "C-r" . ivy-resume)
   ( "C-c v" . ivy-push-view)
   ( "C-c V" . ivy-pop-view)
   ( "C-c w" . ivy-switch-view)
   ( "C-x b" . ivy-switch-buffer)
   ( "C-c g" . counsel-git)
   ( "C-c j" . counsel-git-grep)
   ("M-y" . counsel-yank-pop)
   :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)
   ))

(use-package all-the-icons) ; 'M-x all-the-icons-install-fonts' to install resource fonts
(use-package doom-themes
  :init
  (load-theme 'doom-vibrant t)
  (doom-themes-neotree-config))
(set-cursor-color "#FF0000")         ; Set cursor color to red
(set-face-attribute 'hl-line nil :inherit nil :background "#6A0000")

(use-package company
  :config
  (setq company-idle-delay 0
        company-echo-delay 0
        company-dabbrev-downcase nil
        company-minimum-prefix-length 3
        ompany-tooltip-limit 20
        company-selection-wrap-around t
        company-transformers '(company-sort-by-occurrence
                               company-sort-by-backend-importance))
  (define-key company-mode-map (kbd "C-M-i") 'company-indent-or-complete-common)
  (global-company-mode))

(use-package neotree
  :ensure t
  :config
  (setq neo-smart-open t)
  (global-set-key [f8] 'neotree-toggle))

(use-package popwin
  :config
  (global-set-key (kbd "C-z") popwin:keymap)
  (add-to-list 'popwin:special-display-config `("*Swoop*" :height 0.5 :position bottom))
  (add-to-list 'popwin:special-display-config `("*\.\* output*" :height 0.5 :noselect t :position bottom))
  ;; (add-to-list 'popwin:special-display-config `(".pdf" :regexp t :width 0.5 :noselect t :position right :stick t))
  (add-to-list 'popwin:special-display-config `("*Warnings*" :height 0.5 :noselect t))
  (add-to-list 'popwin:special-display-config `("*TeX Help*" :height 0.5 :noselect t))
  (add-to-list 'popwin:special-display-config `("*ENSIME Welcome*" :height 0.5 :noselect t))
  (add-to-list 'popwin:special-display-config `("*Procces List*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*Messages*" :height 0.5 :noselect t))
  (add-to-list 'popwin:special-display-config `("*Help*" :height 0.5 :noselect nil))
  (add-to-list 'popwin:special-display-config `("*Backtrace*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*Compile-Log*" :height 0.5 :noselect t))
  (add-to-list 'popwin:special-display-config `("*Remember*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*ansi-term*" :height 0.5 :position top))
  (add-to-list 'popwin:special-display-config `("*All*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*Go Test*" :height 0.3))
  (add-to-list 'popwin:special-display-config `("*Slack -" :regexp t :height 0.5 :position bottom))
  (add-to-list 'popwin:special-display-config `(flycheck-error-list-mode :height 0.5 :regexp t :position bottom))
  (add-to-list 'popwin:special-display-config `("*compilation*" :width 0.5 :position right))
  (popwin-mode 1))

(add-hook 'text-mode-hook 'flyspell-mode)
(setq flyspell-issue-message-flag nil)

(use-package undo-tree
  :bind (("C-x u" . undo-tree-visualize)
         ("C--" . undo)
         ("C-+" . redo))
  :config
  (setq undo-tree-visualizer-diff 1)
  (global-undo-tree-mode))

(use-package smartparens
  :config (show-paren-mode 1))

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs (locate-user-emacs-file "snippets")))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-tools-install)
  :bind ("C-c C-g" . pdf-sync-forward-search)
  :defer t
  :config
  (setq mouse-wheel-follow-mouse t)
  (setq pdf-view-resize-factor 0.5))

(defun run-latex ()
  (interactive)
  (let ((process (TeX-active-process))) (if process (delete-process process)))
  (let ((TeX-save-query nil)) (TeX-save-document ""))
  (TeX-command-menu "LaTeX"))

(use-package tex
  :ensure auctex
  :mode ("\\.tex\\'" . latex-mode)
  ;; :diminish reftex-mode
  :bind (:map TeX-mode-map
        ("M-q" . ales/fill-paragraph)
        ("<C-return>" . run-latex))
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq-default TeX-master nil)
  (setq TeX-electric-sub-and-superscript t)
  (setq sentence-end-double-space nil)
  (custom-set-variables '(LaTeX-command "latex -synctex=1"))

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              ;; (local-set-key (kbd "<C-return>") (lambda () (Tex-command-menu "LaTeX")))
              (company-mode)
              (visual-line-mode)
              (flyspell-mode)
              (smartparens-mode)
              (turn-on-reftex)
              (setq reftex-plug-into-AUCTeX t)
              (reftex-isearch-minor-mode)
              (setq TeX-PDF-mode t)
              (setq TeX-source-correlate-method 'synctex)
              (setq TeX-source-correlate-start-server t)))
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (add-hook 'kill-buffer-hook 'TeX-clean nil 'make-it-local)))

  ;; Update PDF buffers after successful LaTeX runs
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  ;; to use pdfview with auctex
  (add-hook 'LaTeX-mode-hook 'pdf-tools-install)
  ;; to use pdfview with auctex
  (setq TeX-view-program-selection '((output-pdf "pdf-tools"))
        TeX-source-correlate-start-server t)
  (setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))

  (defun ales/fill-paragraph (&optional P)
    "When called with prefix argument call `fill-paragraph'.
       Otherwise split the current paragraph into one sentence per line."
    (interactive "P")
    (if (not P)
        (save-excursion
          (let ((fill-column 12345678)) ;; relies on dynamic binding
            (fill-paragraph) ;; this will not work correctly if the paragraph is
            ;; longer than 12345678 characters (in which case the
            ;; file must be at least 12MB long. This is unlikely.)
            (let ((end (save-excursion
                         (forward-paragraph 1)
                         (backward-sentence)
                         (point-marker))))  ;; remember where to stop
              (beginning-of-line)
              (while (progn (forward-sentence)
                            (<= (point) (marker-position end)))
                (just-one-space) ;; leaves only one space, point is after it
                (delete-char -1) ;; delete the space
                (newline)        ;; and insert a newline
                (LaTeX-indent-line) ;; TODO: fix-this
                ))))
      ;; otherwise do ordinary fill paragraph
      (fill-paragraph P)))
)

(use-package reftex
  :defer t
  :config
  (setq reftex-cite-prompt-optional-args t)); Prompt for empty optional arguments in cite

(use-package magit
  :ensure t
  :config
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))
  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)
  (setq magit-refresh-status-buffer nil)
  (setq vc-handled-backends nil)
  :bind (("C-x g" . magit-status)
         ("C-c g b" . magit-branch-and-checkout)
         ("C-c g c" . magit-checkout)
         ("C-c g l" . magit-log-all)))

(use-package proof-site
  :ensure f
  :mode ("\\.v\\'" . coq-mode)
  ;; location of Proof General installation
  :load-path "~/.emacs.d/PG/generic/"
  :config
  ;; remove splash screen
  (setq proof-splash-seen t)
  ;; window-mode setup
  (setq proof-three-window-mode-policy 'hybrid)
  ;; fly past comments when stepping forwads/backwards in proof
  (setq proof-script-fly-past-comments t)
  ;; compile dependencies before Require
  (setq coq-compile-before-require t)
  (defun my/coq-mode-setup ()
    ;; forward and backward shortcuts
    (define-key coq-mode-map (kbd "M-n") #'proof-assert-next-command-interactive)
    (define-key coq-mode-map (kbd "M-p") #'proof-undo-last-successful-command))
  (add-hook 'coq-mode-hook #'my/coq-mode-setup))

(use-package company-coq
  :defer t
  :init
  (add-hook 'coq-mode-hook 'company-coq-mode)
  ;; (add-hook 'coq-mode-hook (lambda ()
  ;;                            (setq-local prettify-symbols-alist
  ;;                                       ; also prettify "Proof." and "Qed."
  ;;                                        '(("Proof." . ?∵) ("Qed." . ?■)))))
  :config
  ;; disable company-coqgreeting
  (setq company-coq-disabled-features '(hello))
  ;; enable features features like autocompletion of externally
  ;; defined symbols, tactics, notations etc.
  (setq company-coq-live-on-the-edge t))

(use-package haskell-mode)

(use-package idris-mode
  :mode (("\\.idr$" . idris-mode)
         ("\\.lidr$" . idris-mode))
  :defer t
  :config
  (let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
   (setenv "PATH" (concat my-cabal-path path-separator (getenv "PATH")))
   (add-to-list 'exec-path my-cabal-path))
  (defun my-idris-mode-hook ()
  (add-to-list 'display-buffer-alist
               '(".*". (display-buffer-reuse-window . ((reusable-frames . t)))))
  (setq idris-stay-in-current-window-on-compiler-error t)
  (setq idris-prover-restore-window-configuration t)

;;; (add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*idris-repl*")
;;; (add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*idris-notes*")
;;; (add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*idris-info*")
;;; (add-to-list 'frames-only-mode-kill-frame-when-buffer-killed-buffer-list "*idris-holes*")
)


(add-hook 'idris-mode-hook #'my-idris-mode-hook))

(use-package sml-mode
  :mode "\\.sml\\'"
  :interpreter "sml")

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/local/bin/sbcl")
  (setq slime-contribs '(slime-fancy)))

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.txt\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command "multimarkdown")
  :config
  (add-hook 'markdown-mode-hook 'flyspell-mode))

(defun whack-whitespace ()
  "Delete all white space from point to the next word.  With prefix ARG
    delete across newlines as well.  The only danger in this is that you
    don't have to actually be at the end of a word to make it work.  It
    skips over to the next whitespace and then whacks it all to the next
    word."
  (interactive)
  (let ((regexp (if 1 "[ \t\n]+" "[ \t]+")))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))

(defun move-line-down ()
  "Move current line a line down."
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  "Move current line a line up."
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(global-set-key (kbd "M-j")
                (lambda ()
                  (interactive)
                  (join-line -1)))

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

(setq compilation-read-command nil)
(global-set-key (kbd "C-c m") 'compile)

(global-set-key (kbd "M-l") 'whack-whitespace)

(global-set-key [remap goto-line] 'goto-line-with-feedback)
(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (linum-mode -1)))

(require 'ansi-color)
(defun endless/colorize-compilation ()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(add-hook 'compilation-filter-hook
          #'endless/colorize-compilation)

(defun no-junk-please-were-unixish ()
  (let ((coding-str (symbol-name buffer-file-coding-system)))
    (when (string-match "-\\(?:dos\\|mac\\)$" coding-str)
      (set-buffer-file-coding-system 'unix))))

(add-hook 'find-file-hooks 'no-junk-please-were-unixish)

;; fontify code in code blocks
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)
