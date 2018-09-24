
;;---------------------------------------------------------------------
;; Init
;;---------------------------------------------------------------------

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.

(package-initialize)

(defvar current-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Powering up... Be patient, %s!" current-user)

;; always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100mb
(setq large-file-warning-threshold 100000000)

(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-screen t)

(message "Setting load paths...")

;;--------------------------------------------------------------
;; Variables and Load Paths
;;--------------------------------------------------------------
(defvar emacs-dir (file-name-directory "~/.emacs.d/init.el")
  "The root dir of the Emacs distribution.")

(defvar core-dir (expand-file-name "core" emacs-dir)
  "The home of core functionality.")

(defvar modules-dir (expand-file-name "modules" emacs-dir)
  "This directory houses all of the modules.")

(defvar persistent-dir (expand-file-name "persistent" emacs-dir)
  "This directory houses packages that are not yet available in ELPA (or MELPA).")

(unless (file-exists-p persistent-dir)
  (make-directory persistent-dir))

(defvar temporary-file-directory (expand-file-name "temp" emacs-dir)
  "This is where temporary files should be stored.")
(unless (file-exists-p temporary-file-directory)
  (make-directory temporary-file-directory))

;; This should go away. These things are probably on Melp by now. Review it.
(defvar lisp-dir (expand-file-name "lisp" emacs-dir)
  "This directory houses packages that I manually downloaded. Bad.")

(defun add-subfolders-to-load-path (parent-dir)
  "Add all level PARENT-DIR subdirs to the `load-path`."
  (dolist (f (directory-files parent-dir))
    (let ((name (expand-file-name f parent-dir)))
      (when (and (file-directory-p name)
                 (not (string-prefix-p "." f)))
        (add-to-list 'load-path name)
        (add-subfolders-to-load-path name)))))

(add-to-list 'load-path core-dir)
(add-to-list 'load-path modules-dir)
(add-to-list 'load-path persistent-dir)
(add-to-list 'load-path lisp-dir)

;;--------------------------------------------------------------
;; Core
;;--------------------------------------------------------------

(message "Loading core...")

(require 'core-bootstrap)
(require 'core-packages)
(require 'core-defuns)
(require 'core-ido)
(require 'core-ui)
(require 'core-paths)

;;--------------------------------------------------------------
;; Modules
;;--------------------------------------------------------------

(message "Loading modules...")

(require 'module-lang-css)
(require 'module-less)
(require 'module-org)
(require 'module-markdown)
(require 'module-projectile)
(require 'module-web)
(require 'module-web-beautify)
(require 'module-php)
;; (require 'module-sanityinc-tomorrow)
;; (require 'module-solarized)
(require 'module-leuven)
(require 'module-vue)
(require 'module-smart-mode-line)
;; (require 'module-rjsx)
(require 'module-rest)

(message "SML setup...")
(sml/setup)

(message "Ready for action, %s!" current-user)

