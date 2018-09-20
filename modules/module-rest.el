(use-package restclient
  :ensure t
  :bind (("C-c r" . restclient-http-send-current))
  :config
  (remove-hook 'restclient-mode-hook 'restclient-outline-mode))

(provide 'module-rest)
