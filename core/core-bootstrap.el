(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives
      '(("melpa"        . "http://melpa.org/packages/")
      ("marmalade" . "http://marmalade-repo.org/packages/")
        ("org"          . "http://elpa.gnu.org/packages/")))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'delight)
  (package-install 'bind-key))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'core-bootstrap)
