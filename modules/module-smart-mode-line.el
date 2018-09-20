(use-package smart-mode-line
  :ensure t
  :config
  (progn
    (setq sml/theme 'light)
    (setq sml/name-width 40)
    (setq sml/mode-width 'full)
    (set-face-attribute 'mode-line nil
                        :box nil)
    (add-to-list 'sml/replacer-regexp-list '("^~/src/" ":src:") t)))

(provide 'module-smart-mode-line)
