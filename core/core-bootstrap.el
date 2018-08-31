(require 'package)

(setq package-enable-at-startup nil)

(if (eq system-type 'windows-nt)
    (require 'core-windows)
  (require 'core-nix))


;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'delight)
  (package-install 'bind-key))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'core-bootstrap)
