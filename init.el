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
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-initialize))

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

;; (add-hook 'before-save-hook 'whitespace-cleanup)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)
(setq locate-command "mdfind")
(setq ns-pop-up-frames nil)
;; Some mac-bindings interfere with Emacs bindings.
(when (boundp 'mac-pass-command-to-system)
      (setq mac-pass-command-to-system nil))

;; (defun toggle-fullscreen (&optional f)
;;   (interactive)
;;   (let ((current-value (frame-parameter nil 'fullscreen)))
;;     (set-frame-parameter nil 'fullscreen
;;       (if (equal 'fullboth current-value)
;; 	(if (boundp 'old-fullscreen) old-fullscreen nil)
;; 	(progn (setq old-fullscreen current-value)
;; 	  'fullboth)))))
;; (global-set-key [f12] 'toggle-frame-fullscreen)

(push ".ibc" completion-ignored-extensions) ;; idris bytecode
(push ".aux" completion-ignored-extensions) ;; latex
(setq counsel-find-file-ignore-regexp "\\.ibc\\'")
(setq counsel-find-file-ignore-regexp "\\.aux\\'")

(setq nobreak-char-display t)
(setq dired-use-ls-dired nil)
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
(setq visible-bell nil)              ; turn off bip warnings
(setq ring-bell-function 'ignore)    ; Annoying sounds
(auto-compression-mode 1)            ; browse tar archives
(put 'upcase-region 'disabled nil)   ; enable ``upcase-region''
(put 'set-goal-column 'disabled nil) ; enable column positioning
(setq column-number-mode t)          ; show column number
(setq case-fold-search t)            ; make search ignore case
(fset 'yes-or-no-p 'y-or-n-p)        ; short-hand yes/no selection
(ido-mode 1)                         ; interactive DO mode (better file opening and buffer switching)

;; (setq default-tab-width 2)
;; (setq-default c-basic-offset 2)
;; (defvaralias 'c-basic-offset 'tab-width)
;; (setq-default indent-tabs-mode t)    ; tabs over spaces
(setq-default c-basic-offset 2
							tab-width 2
							indent-tabs-mode t)
(delete-selection-mode +1)           ; type over a selected region, instead of deleting before typing.
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ; start full screen
(global-auto-revert-mode t)          ; automatically reload buffers when file has changed
(global-hl-line-mode t)              ; line highlight
;; (global-linum-mode t)                ; enable line numbers globally
(global-subword-mode t)              ; enable subword mode globally
(global-unset-key (kbd "<M-drag-mouse-1>"))   ; was mouse-set-secondary
(global-unset-key (kbd "<M-down-mouse-1>"))   ; was mouse-drag-secondary
(global-unset-key (kbd "<M-mouse-1>"))        ; was mouse-start-secondary
(global-unset-key (kbd "<M-mouse-2>"))        ; was mouse-yank-secondary
(global-unset-key (kbd "<M-mouse-3>"))        ; was mouse-secondary-save-then-kill

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))) ; set backup directory
(setq default-directory "~/Documents/")        ; set default directory to be documents

(use-package ivy
  :ensure t
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
  (custom-set-faces
   '(ivy-current-match
     ((((class color) (background light))
       :background "red" :foreground "white")
      (((class color) (background dark))
       :background "#610000" :foreground "#8a2720"))))
  )

(use-package swiper
  :demand
  :config
  )

(use-package counsel
  :demand
  :defer t
  :bind*
  (
   ( "C-s" . counsel-grep-or-swiper)
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

(use-package avy
  :demand
  :bind* (("C-,"     . avy-pop-mark)
	  ("M-j"     . avy-goto-char)
	  ("M-k"     . avy-goto-word-1)
	  ("M-g n"   . avy-resume)
	  ("M-g w"   . avy-goto-word-1)
	  ("M-g f"   . avy-goto-line)
	  ("M-g l c" . avy-copy-line)
	  ("M-g l m" . avy-move-line)
	  ("M-g r c" . avy-copy-region)
	  ("M-g r m" . avy-move-region)
	  ("M-g p"   . avy-goto-paren)
	  ("M-g c"   . avy-goto-conditional)
	  ("M-g M-g" . avy-goto-line))
  :config
  (defun avy-goto-paren ()
    (interactive)
    (avy-jump "\\s(" nil 'pre))
  (defun avy-goto-conditional ()
    (interactive)
    (avy-jump "\\s(\\(if\\|cond\\|when\\|unless\\)\\b" nil 'pre))
  (setq avy-timeout-seconds 0.3)
  (setq avy-all-windows 'all-frames)
  (defun avy-action-copy-and-yank (pt)
    "Copy and yank sexp starting on PT."
    (avy-action-copy pt)
    (yank))
  (defun avy-action-kill-and-yank (pt)
    "Kill and yank sexp starting on PT."
    (avy-action-kill-stay pt)
    (yank))
  (setq avy-dispatch-alist
	'((?w . avy-action-copy)
	  (?k . avy-action-kill-move)
	  (?u . avy-action-kill-stay)
	  (?m . avy-action-mark)
	  (?n . avy-action-copy)
	  (?y . avy-action-copy-and-yank)
	  (?Y . avy-action-kill-and-yank)))
  ;; (setq avy-keys
  ;;       '(?c ?a ?s ?d ?e ?f ?h ?w ?y ?j ?k ?l ?n ?m ?v ?r ?u ?p))
  )

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  ;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this-symbol)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-æ") 'mc/mark-next-like-this-word)
  (global-set-key (kbd "C-ø") 'mc/unmark-next-like-this)
)

(use-package ace-window
  :bind* ("C-x o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?j ?k ?l))
  (setq aw-scope 'global)
  (defun aw-switch-buffer (window)
    "Swift buffer in WINDOW."
    (select-window window)
    (ivy-switch-buffer))
  (setq aw-dispatch-alist
     '((?x aw-delete-window " Ace - Delete Window")
       (?m aw-swap-window " Ace - Swap Window")
       (?n aw-flip-window)
       (?c aw-split-window-fair " Ace - Split Fair Window")
       (?v aw-split-window-vert " Ace - Split Vert Window")
       (?h aw-split-window-horz " Ace - Split Horz Window")
       (?i delete-other-windows " Ace - Maximize Window")
       (?b aw-switch-buffer " Ace - Switch Buffer")
       (?o delete-other-windows))))

(setq-default fill-column 100)
(setq-default word-wrap t)

(use-package all-the-icons) ; 'M-x all-the-icons-install-fonts' to install resource fonts
(use-package doom-themes
  :init
  (setq doom-solarized-dark-brighter-comments t)
  (load-theme 'doom-solarized-dark t)
  (doom-themes-neotree-config)
  (set-face-attribute 'region nil :background "#8a2720")
)


;; (use-package dracula-theme
;;   :ensure t
;;   :init
;;   ;; (load-theme 'dracula t)
;; )
(set-face-attribute 'hl-line nil :inherit nil :background "#610000") ; set hightline line color to red-ish
(set-cursor-color "#FF0000")         ; set cursor color to red

(use-package company
  :config
  (setq company-idle-delay 0.0
	company-echo-delay 0
	company-dabbrev-downcase nil
	company-minimum-prefix-length 1
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
  (add-to-list 'popwin:special-display-config `("*Compile-Log*" :width 0.5 :noselect t :position right))
  (add-to-list 'popwin:special-display-config `("*Remember*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*ansi-term*" :height 0.5 :position top))
  (add-to-list 'popwin:special-display-config `("*All*" :height 0.5))
  (add-to-list 'popwin:special-display-config `("*Go Test*" :height 0.3))
  (add-to-list 'popwin:special-display-config `("*Slack -" :regexp t :height 0.5 :position bottom))
  (add-to-list 'popwin:special-display-config `(flycheck-error-list-mode :height 0.2 :regexp t :position bottom :stick t))
  (add-to-list 'popwin:special-display-config `("*compilation*" :width 0.5 :position right))
  (add-to-list 'popwin:special-display-config `(magit-mode :width 0.5 :position right))
  (popwin-mode 1))

(add-hook 'text-mode-hook 'flyspell-mode)
(setq flyspell-issue-message-flag nil)

(use-package undo-tree
  :bind (("C-x u" . undo-tree-visualize)
	 ("C--" . undo)
	 ("C-+" . redo))
  :config
  (setq undo-tree-visualizer-diff 1)
  (global-undo-tree-mode)
	;; Prevent undo tree files from polluting your git repo
	(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
	)

(use-package smartparens
  :config (show-paren-mode 1)
	(setq show-paren-style 'expression)
)

(use-package yasnippet
  :ensure t
  :init
  (yas-global-mode 1)
  :config
  (add-to-list 'yas-snippet-dirs (locate-user-emacs-file "snippets")))

(use-package pdf-tools
  :ensure t
  :mode ("\\.pdf\\'" . pdf-tools-install)
  :bind (("C-c C-g" . pdf-sync-forward-search)
				 ("C-s" . 'isearch-forward)
	 )
  :defer t
  :config
	(local-set-key (kbd "M-g g") ''pdf-view-goto-page)
  (setq mouse-wheel-follow-mouse t)
	(setq pdf-view-use-scaling t)
  (setq pdf-view-resize-factor 1.2)
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  (defun bms/pdf-midnite-green ()
    "Set pdf-view-midnight-colors to green on black."
    (interactive)
    (setq pdf-view-midnight-colors '("#00B800" . "#000000" )) ; green 
    (pdf-view-midnight-minor-mode)
    )
  (defun bms/pdf-midnite-amber ()
    "Set pdf-view-midnight-colors to amber on dark slate blue."
    (interactive)
    (setq pdf-view-midnight-colors '("#ff9900" . "#0a0a12" )) ; amber
    (pdf-view-midnight-minor-mode)
    )
  (add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)
				  (pdf-view-fit-page-to-window)
				  (pdf-view-set-slice-from-bounding-box)))
  ;; (add-hook 'pdf-view-mode-hook (lambda ()
  ;; 				  (bms/pdf-midnite-amber))) ; automatically turns on midnight-mode for pdfs
  )

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
	      ("C-q" . ales/fill-paragraph)
	      ("<C-return>" . run-latex))
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq-default TeX-master nil)
  (setq TeX-electric-sub-and-superscript t)
  (setq sentence-end-double-space nil)
  ;; (custom-set-variables '(LaTeX-command "latex -synctex=1 -shell-escape"))
  (custom-set-variables '(TeX-command-extra-options "-synctex=1 -shell-escape"))
  (add-hook 'LaTeX-mode-hook
	    (lambda ()
	      (company-mode)
	      ;; (visual-line-mode)
	      (flyspell-mode)
	      ;; (smartparens-mode)
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

;; (use-package auctex-latexmk ;Use latexmk
;;   :ensure t
;;   :config
;;   (auctex-latexmk-setup)
;;   (setq auctex-latexmk-inherit-TeX-PDF-mode t))

(defcustom TeX-texify-Show nil "Start view-command at end of TeX-texify?" :type 'boolean :group 'TeX-command)
(defcustom TeX-texify-max-runs-same-command 5 "Maximal run number of the same command" :type 'integer :group 'TeX-command)

(defun TeX-texify-sentinel (&optional proc sentinel)
  "Non-interactive! Call the standard-sentinel of the current LaTeX-process.
If there is still something left do do start the next latex-command."
  (set-buffer (process-buffer proc))
  (funcall TeX-texify-sentinel proc sentinel)
  (let ((case-fold-search nil))
    (when (string-match "\\(finished\\|exited\\)" sentinel)
      (set-buffer TeX-command-buffer)
      (unless (plist-get TeX-error-report-switches (intern (TeX-master-file)))
        (TeX-texify)))))

(defun TeX-texify ()
  "Get everything done."
  (interactive)
  (let ((nextCmd (TeX-command-default (TeX-master-file)))
        proc)
    (if (and (null TeX-texify-Show)
             (equal nextCmd TeX-command-Show))
        (when  (called-interactively-p 'any)
          (message "TeX-texify: Nothing to be done."))
      (TeX-command nextCmd 'TeX-master-file)
      (when (or (called-interactively-p 'any)
                (null (boundp 'TeX-texify-count-same-command))
                (null (boundp 'TeX-texify-last-command))
                (null (equal nextCmd TeX-texify-last-command)))
        (mapc 'make-local-variable '(TeX-texify-sentinel TeX-texify-count-same-command TeX-texify-last-command))
        (setq TeX-texify-count-same-command 1))
      (if (>= TeX-texify-count-same-command TeX-texify-max-runs-same-command)
          (message "TeX-texify: Did %S already %d times. Don't want to do it anymore." TeX-texify-last-command TeX-texify-count-same-command)
        (setq TeX-texify-count-same-command (1+ TeX-texify-count-same-command))
        (setq TeX-texify-last-command nextCmd)
        (and (null (equal nextCmd TeX-command-Show))
             (setq proc (get-buffer-process (current-buffer)))
             (setq TeX-texify-sentinel (process-sentinel proc))
             (set-process-sentinel proc 'TeX-texify-sentinel))))))

(provide 'TeX-texify)

(use-package reftex
  :defer t
  :config
  (setq reftex-cite-prompt-optional-args t)); Prompt for empty optional arguments in cite

(use-package biblio
  :ensure t )

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

(use-package proof-general
  :ensure t
  ;; :mode ("\\.v\\'" . coq-mode)
  ;; :bind (("M-n" . 'proof-assert-next-command-interactive))
  :config
  ;; remove splash screen
  (setq proof-splash-enable nil)
  ;; (setq max-specpdl-size 13000)
  ;; window-mode setup
  (setq proof-three-window-mode-policy 'hybrid)
  ;; fly past comments when stepping forwads/backwards in proof
  (setq proof-script-fly-past-comments t)
  ;; compile dependencies before Require
  (setq coq-compile-before-require t)
  ;; Remove the colour
  ;; (setq proof-colour-locked nil)
  ;; 
  (defun my/coq-mode-setup ()
    ;; forward and backward shortcuts
    (define-key coq-mode-map (kbd "M-n") #'proof-assert-next-command-interactive)
    (define-key coq-mode-map (kbd "M-p") #'proof-undo-last-successful-command)
    (define-key coq-mode-map (kbd "C-x p") #'proof-three-window-toggle)
    )
  (add-hook 'coq-mode-hook #'my/coq-mode-setup)
  
  )

(use-package company-coq
  :ensure t
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
  ;; (setq company-coq-live-on-the-edge t)
  )

;; (use-package haskell-interactive-mode
;;   :ensure t)
;; (use-package haskell-process
;;   :ensure t)
(use-package haskell-mode
  :ensure t
  :config
  (defun my/haskell-mode-setup ()
    (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))
  (add-hook 'haskell-mode-hook #'my/haskell-mode-setup)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (custom-set-variables
   '(haskell-process-suggest-remove-import-lines t)
   '(haskell-process-suggest-hoogle-imports t)
   '(haskell-process-log t))
)

(use-package idris-mode
  :mode (("\\.idr$" . idris-mode)
	 ("\\.lidr$" . idris-mode))
  :ensure t
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

(use-package elisp-slime-nav
  :ensure t
  :config 
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook 'elisp-slime-nav-mode))
)

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

(use-package tuareg
  :ensure t
  :config)

(use-package go-mode
  :ensure t
  :init
  (add-hook 'go-mode-hook
	    (lambda ()
	      (set (make-local-variable 'compile-command) 
		   "go test" 
		   ;; (concat "go run " buffer-file-name)
		   ;; (concat "go build " (concat (buffer-file-name (concat " && go test " buffer-file-name))))
		   )))
  ;;          "go build -v && go test -v "
  )

(use-package langtool
  :ensure t
  :init
  (setq langtool-language-tool-jar "/Users/set/Downloads/LanguageTool-4.9.1/languagetool-commandline.jar")
  (setq langtool-default-language "en-US")
  :config)

(use-package rust-mode
  :ensure t
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
)
(use-package cargo
  :ensure t

)

(add-to-list 'auto-mode-alist '("\\.zwo\\'" . nxml-mode))

(setq python-shell-interpreter "python3")

(defun whack-whitespace-after ()
  "Delete all white space from point to the next word.  With prefix ARG
    delete across newlines as well.  The only danger in this is that you
    don't have to actually be at the end of a word to make it work.  It
    skips over to the next whitespace and then whacks it all to the next
    word."
  (interactive)
  (let ((regexp (if 1 "[ \t\n]+" "[ \t]+")))
    (re-search-forward regexp nil t)
    (replace-match "" nil nil)))

(defun kill-whitespace ()
  "Kill the whitespace between two non-whitespace characters"
  (interactive "*")
  (save-excursion
    (save-restriction
      (save-match-data
	(progn
	  (re-search-backward "[^ \t\r\n]" nil t)
	  (re-search-forward "[ \t\r\n]+" nil t)
	  (replace-match "" nil nil))))))

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

(use-package edit-server
  :ensure t)
(edit-server-start)

(global-set-key (kbd "M-j")
		(lambda ()
		  (interactive)
		  (join-line -1)))

;; (global-set-key (kbd "C-S-down") 'move-line-down)
;; (global-set-key (kbd "C-S-up") 'move-line-up)

(global-set-key (kbd "C-q") 'fill-paragraph)
(global-set-key (kbd "C-S-D") 'delete-pair)
;; (global-set-key (kbd "C-S-down") 'move-line-down)
;; (global-set-key (kbd "C-S-up") 'move-line-up)
(global-set-key (kbd "C-x y") 'string-insert-rectangle)

(setq compilation-read-command nil)

(global-set-key (kbd "M-!") 'ispell-word)

(global-set-key (kbd "C-c m") 'compile)
(global-set-key (kbd "M-*") 'pop-tag-mark)
(global-set-key (kbd "M-l") 'whack-whitespace-after)
(global-set-key (kbd "<C-M-backspace>") 'kill-whitespace)
(global-set-key (kbd "C-c C-y") 'string-insert-rectangle)

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
(setq org-html-validation-link nil)
(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-src-preserve-indentation nil
      org-edit-src-content-indentation 0)
(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '(" %a <%d/%m-%Y>" . "<%d.%m.%Y %a %H:%M>"))

(defun my-org-mode-customizations ()
  "My custom keybindings and configurations for Org mode."
  (local-set-key (kbd "C-c C-j") 'org-insert-item)
  (local-set-key (kbd "C-c a") 'org-agenda)
)

(add-hook 'org-mode-hook 'my-org-mode-customizations)

;; TODO keywords.
(setq org-todo-keywords
  '((sequence "TODO(t)" "PROG(p)" "DONE(d)")))

;; Show the daily agenda by default.
(setq org-agenda-span 'day)

;; Hide tasks that are scheduled in the future.
;; (setq org-agenda-todo-ignore-scheduled 'future)

;; Use "second" instead of "day" for time comparison.
;; It hides tasks with a scheduled time like "<2020-11-15 Sun 11:30>"
(setq org-agenda-todo-ignore-time-comparison-use-seconds t)

;; Hide the deadline prewarning prior to scheduled date.
(setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)

;; Customized view for the daily workflow. (Command: "C-c a n")
(setq org-agenda-custom-commands
  '(("n" "Agenda / PROG / DONE"
     ((agenda "" nil)
      (todo "PROG" nil)
      (todo "TODO" nil)
     nil))))

(setq org-agenda-files '("~/Documents/tasks.org"))

(define-minor-mode dblp-mode
  "Provide shortcuts for quering dblp."
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "M-s d") 'biblio-dblp-lookup)
            map)
  )
(provide dblp-mode)
(add-hook 'bibtex-mode-hook 'dblp-mode)

;; (defun test-on-message (data)
;; 		"On message callback with DATA."
;; 		(message "[DATA] %s" data))

;; (use-package grammarly
;; 	:ensure t
;; 	:config
;; 	(add-to-list 'grammarly-on-message-function-list 'test-on-message)
;;  )

;; (grammarly-check-text "Hello World")

(use-package flycheck-grammarly
	:ensure t
	:config
	(with-eval-after-load 'flycheck
		(flycheck-grammarly-setup))
	(custom-set-variables
	 '(flycheck-checker-error-threshold 1000)
	 '(flycheck-grammarly-check-time 1.0)
	 )
	)

(use-package flymake-grammarly
	:ensure t
	:config
	(add-hook 'flymake-mode-hook 'flymake-grammarly-load)

	(define-key flymake-mode-map (kbd "M-n") 'flymake-goto-next-error)
	(define-key flymake-mode-map (kbd "M-p") 'flymake-goto-prev-error)


	(custom-set-variables
	 '(flymake-start-on-save-buffer nil)
	 '(flycheck-grammarly-check-time 20.0)
	 '(flymake-no-changes-timeout 20.0)
	 )
	)

(defconst send-to-osx-grammarly-script-dir
  (concat (file-name-directory load-file-name) "~/Documents/send-to-osx-grammarly/scripts/")
  "Script path for package `send-to-osx-grammarly'.")

(defun send-to-osx-grammarly--call (script)
  "Call SCRIPT from script directory."
  (call-process-shell-command (format "osascript %s%s" send-to-osx-grammarly-script-dir script)))

;;;###autoload
(defun send-to-osx-grammarly-push ()
  "Save region to a tempfile and run Grammarly on it."
  (interactive)
  (kill-region (region-beginning) (region-end))
  (send-to-osx-grammarly--call "push.scpt"))

;;;###autoload
(defun send-to-osx-grammarly-pull()
  "Save region to a tempfile and run Grammarly on it."
  (interactive)
  (send-to-osx-grammarly--call "pull.scpt")
  (yank))

(define-key global-map (kbd "C-c h") #'send-to-osx-grammarly-push)
(define-key global-map (kbd "C-c l") #'send-to-osx-grammarly-pull)

;; (use-package lsp-grammarly
;;   :ensure t
;;   :hook (text-mode . (lambda ()
;;                        (require 'lsp-grammarly)
;;                        (lsp))))  ; or lsp-deferred
;; (use-package lsp-ltex
;;   :ensure t
;;   :hook (text-mode . (lambda ()
;;                        (require 'lsp-ltex)
;;                        (lsp)))  ; or lsp-deferred
;;   :init
;;   (setq lsp-ltex-version "16.0.0"))  ; make sure you have set this, see below

(use-package flycheck
  :ensure t
  :mode ("\\.tex\\'" . flycheck-mode)
	)

(flycheck-define-checker tex-textidote
  "A LaTeX grammar/spelling checker using textidote.
  See https://github.com/sylvainhalle/textidote"
  :modes (latex-mode plain-tex-mode)
  :command ("java" "-jar" (eval (expand-file-name "/opt/homebrew/Cellar/textidote/0.8.3/libexec/textidote.jar"))
            "--read-all"
            "--output" "singleline"
            "--no-color"
            "--check"   (eval (if ispell-current-dictionary (substring ispell-current-dictionary 0 2) "en"))
            ;; Try to honor local aspell dictionary and replacements if they exist
            "--dict"    (eval (expand-file-name "~/.emacs.d/textidote-dict.txt"))
            ;; "--dict"    (eval (expand-file-name "~/.aspell.en.pws"))
            "--replace" (eval (expand-file-name "~/.aspell.en.prepl"))
            ;; Using source ensures that a single temporary file in a different dir is created
            ;; such that textidote won't process other files. This serves as a hacky workaround for
            ;; https://github.com/sylvainhalle/textidote/issues/200.
            source)
  :error-patterns ((warning line-start (file-name)
                            "(L" line "C" column "-" (or (seq "L" end-line "C" end-column) "?") "): "
                            (message (one-or-more (not "\""))) (one-or-more not-newline) line-end)))
(add-to-list 'flycheck-checkers 'tex-textidote)

(use-package lsp-mode
  :ensure t
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
	:config
	(setq lsp-diagnostics-provider :none)
)

(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package dap-mode :after lsp-mode
	:config (dap-auto-configure-mode)
	:bind (("C-c d m" . dap-java-run-test-method)
				 ("C-c d c" . dap-java-run-test-class)
				 ("C-c d l" . dap-java-run-last-test)
				 )
)
(use-package dap-java
	:ensure nil
	)
(use-package hydra)

(use-package lsp-treemacs)

(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

(use-package lsp-java
	:config (add-hook 'java-mode-hook 'lsp)
	:bind (("M-æ g i"     . lsp-find-implementation)
				 ("M-æ g r"     . lsp-find-references)
				 )
)

(use-package counsel-etags
  :ensure t
  :bind (("C-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
        (lambda ()
          (add-hook 'after-save-hook
            'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (push "build" counsel-etags-ignore-directories))

;; ** recursive directory tree comparison: M-x ztree-diff
(use-package ztree
  :ensure t
	:config
	(setq ztree-diff-additional-options '("-w -u"))

) ; needs GNU diff utility
