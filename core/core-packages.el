
;; ibuffer
(global-set-key (kbd "C-x b") 'ibuffer)


;; neotree
(use-package neotree
  :bind (([f8] . neotree-toggle)))
;;  :config ())
;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))


;; ripgrep - lots to learn from the page on how to use
;; https://github.com/dajva/rg.el
(use-package rg
  :config (rg-enable-default-bindings (kbd "M-s")))

(provide 'core-packages)
