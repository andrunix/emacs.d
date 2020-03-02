(use-package mu4e
  :load-path "/usr/share/emacs/site-lisp/mu4e/")

(setq user-mail-address "andrew@xoso.io"
      user-full-name "Andrew Pierce")

(setq mu4e-maildir "/home/andrew/Mail/andrew-xoso.io")
(setq mu4e-sent-folder "/Sent")

(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("mail.gandi.net" 465 nil nill))
      smtpmail-default-smtp-server "mail.gandi.net"
      smtpmail-smtp-server "mail.gandi.net"
      smtpmail-smtp-service 465
      smtpmail-debug-info t)

(provide 'module-mu4e)
