(setq inhibit-startup-message t)
(setq make-backup-files nil)
(setq auto-save-list-file-name nil)
(setq auto-save-default nil)

(setq search-highlight t)
(setq query-replace-highlight t)
(setq mouse-sel-retain-highlight t)

(fringe-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(set-default-font "Deja Vu Sans Mono 9")

(setq split-width-threshold 150)
(setq split-height-threshold 9000)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package base16-theme
  :ensure t
  :init
  (setq base16-theme-256-color-source "base16-shell")
  :config
  (load-theme 'base16-default-dark t)
  (setq frame-background-mode 'dark))

(use-package cc-mode
  :config
  (setq c-default-style "stroustrup")
  (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode)))

(use-package dante
  :ensure t
  :after haskell-mode
  :commands 'dante-mode
  :init
  (add-hook 'haskell-mode-hook 'flycheck-mode)
  ;; OR:
  ;; (add-hook 'haskell-mode-hook 'flymake-mode)
  (add-hook 'haskell-mode-hook 'dante-mode))

(use-package discover-my-major
  :ensure t)

(use-package ein
  :ensure t
  :pin melpa-stable)

(use-package elpy
  :ensure t
  :pin melpa-stable
  :init
  (advice-add 'python-mode :before 'elpy-enable)
  :config
  (elpy-enable)
  (setq elpy-rpc-backend "jedi")
  (setenv "IPY_TEST_SIMPLE_PROMPT" "1")
  (setq python-shell-interpreter "ipython"
	python-shell-interpreter-args "-i --pdb --ipython-dir=~/.config/ipython")
  (delete `elpy-module-highlight-indentation elpy-modules))

(use-package fuel
  :ensure t
  :mode ("\\.factor\\'" . factor-mode)
  :interpreter ("factor" . factor-mode)
  :init
  (setq fuel-factor-root-dir "/usr/lib/factor"))

(use-package haskell-mode
  :ensure t
  :bind (:map haskell-mode-map
	      ("C-c C-c" . haskell-compile)
	      ("C-c h" . haskell-hoogle)
	      ("C-c C-l" . haskell-process-load-or-reload)
	      ("C-`" . haskell-interactive-bring)
	      ("C-c C-t" . haskell-process-do-type)
	      ("C-c C-i" . haskell-process-do-info)
	      ;;("C-c C-c" . haskell-process-cabal-build)
	      ("C-c C-k" . haskell-interactive-mode-clear)
	      ("C-c c" . haskell-process-cabal))
  :config
  (setq haskell-compile-cabal-build-command "stack build")
  (setq haskell-process-type 'stack-ghci)
  (setq haskell-process-args-stack-ghci '("--ghci-options=-ferror-spans -fshow-loaded-modules" "--no-build" "--no-load")))

(use-package haskell-interactive-mode)
(use-package haskell-process
  :config
  (setq haskell-process-suggest-remove-import-lines t)
  (setq haskell-process-auto-import-loaded-modules t)
  (setq haskell-process-log t))

(use-package helm
  :ensure t
  :bind (("M-x" . helm-M-x)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files)
	 :map helm-map
	 ("TAB" . helm-execute-persistent-action)
	 ("C-z" . helm-select-action))
  :config
  (setq helm-split-window-in-side-p t)
  (setq helm-mode-fuzzy-match t))

(use-package helm-mode
  :config
  (helm-mode 1))

(use-package ibuffer
  :bind (("C-x C-b" . ibuffer))
  :config
  (setq ibuffer-never-show-predicates (list (rx "*helm"))))

(use-package ibuffer-vc
  :ensure t)

(use-package julia-repl
  :ensure t
  :config
  (add-hook 'julia-mode-hook 'julia-repl-mode))

(use-package magit
  :ensure t
  :pin melpa-stable)

(use-package markdown-mode
  :ensure t)

(use-package ob-sagemath
  :ensure t)

(use-package org
  :ensure t
  :bind (("\C-cl" . org-store-link)
;	 ("\C-ca" . org-agenda)
	 ("\C-cc" . org-capture)
	 ("\C-cb" . org-iswitchb))
  :init
;  (setq org-log-done t)
;  (setq org-default-notes-file "~/org/notes.org")
  (setq org-capture-templates
	'(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
	   "* TODO %?\n  %i\n  %a")
	  ("u" "uri" entry
	   (file+headline "~/documents/bookmarks.org" "Some Default Headline for captures")
	   "*** %^{Title}\n\n    Source: %u, %c\n    %i")))
;  (setq org-agenda-files (list "~/org/todo.org"))
;  (setq org-refile-targets '(("~/org/maybe.org" :level . 1)))
;  (setq org-hide-emphasis-markers t)
  (setq browse-url-browser-function 'browse-url-generic
	browse-url-generic-program "firefox")
  :config
  (add-to-list 'org-file-apps '("\\.djvu\\'" . "zathura %s") t)
  (setcdr (assoc "\\.pdf\\'" org-file-apps) "zathura %s")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . nil)
;     (ipython . t)
     (python . t)
     (R . t)
     (sagemath . t)))
  (setq org-confirm-babel-evaluate nil)
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
  (add-hook 'org-mode-hook 'org-display-inline-images))

(use-package org-journal
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (projectile-global-mode)
  (setq projectile-completion-system 'helm))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package pyvenv
  :ensure t
  :config
  (setenv "WORKON_HOME" "~/miniconda3/envs"))

(use-package tidal
  :ensure t
  :config
  (setq tidal-interpreter "/usr/bin/stack")
  (setq tidal-interpreter-arguments '("ghci" "--ghci-options" "-XOverloadedStrings")))

(use-package tramp
  :config
  (setq tramp-default-method "ssh"))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (web-beautify magit web-mode tidal helm-projectile projectile ob-sagemath julia-repl j-mode helm use-package intero ess elpy ein discover-my-major base16-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
