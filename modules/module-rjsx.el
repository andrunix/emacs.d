(use-package rjsx-mode
  :init
  (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode)))

(add-hook 'js2-mode-hook (lambda () (setq js2-basic-offset 2)))

(provide 'module-rjsx)
