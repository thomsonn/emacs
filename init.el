
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)

;; Ensure the diminish package is installed.
(unless (package-installed-p 'diminish)
  (package-install 'diminish))

(require 'org)
(org-babel-load-file (expand-file-name "org/init.org" user-emacs-directory))
