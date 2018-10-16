
;;
;; So much to learn about org mode
;; Much (all) of this is coming from:
;; http://doc.norang.ca/org-mode.html#GettingStarted
;;
;; also this one:
;; https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html

(use-package org
  :init
  :defer t
  :bind (("C-c a" . org-agenda)
         ("<f12>" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link)
         ("C-c b" . org-iswitchb)
         )
  :mode ("\\.org\\'" . org-mode)
  :config
  
  (defvar personal-org-dir "~/Dropbox/org/"
    "Where I keep my personal org files")
  ;; (defvar work-org-dir "~/code/bcbst/"
  (defvar work-org-dir "~/code/org/"
    "Where I keep work crap")
  (setq org-agenda-files (list personal-org-dir
                          work-org-dir))

  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "SteelBlue4" :weight bold)
                ("NEXT" :foreground "magenta" :weight bold)
                ("DONE" :foreground "forest green" :weight bold)
                ("WAITING" :foreground "orange" :weight bold)
                ("HOLD" :foreground "MediumPurple4" :weight bold)
                ("CANCELLED" :foreground "forest green" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold)
                ("PHONE" :foreground "forest green" :weight bold))))  
  
  (setq org-use-fast-todo-selection t)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  (setq org-directory personal-org-dir)

  (defvar refile-org-file (concat personal-org-dir "refile.org"))
  (setq org-default-notes-file refile-org-file)
  (defvar diary-org-file (concat personal-org-dir "diary.org"))

  ;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings
  (setq org-capture-templates
        (quote (("t" "todo" entry (file refile-org-file)
                 "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "respond" entry (file refile-org-file)
                 "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
                ("n" "note" entry (file refile-org-file)
                 "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("j" "Journal" entry (file+olp+datetree diary-org-file)
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("m" "Meeting" entry (file refile-org-file)
                 "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                ("p" "Phone call" entry (file refile-org-file)
                 "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
                ("h" "Habit" entry (file refile-org-file)
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))  

  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)
  
  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
        (quote (("N" "Notes" tags "NOTE"
                 ((org-agenda-overriding-header "Notes")
                  (org-tags-match-list-sublevels t)))
                ("h" "Habits" tags-todo "STYLE=\"habit\""
                 ((org-agenda-overriding-header "Habits")
                  (org-agenda-sorting-strategy
                   '(todo-state-down effort-up category-keep))))
                (" " "Agenda"
                 ((agenda "" nil)
                  (tags "REFILE"
                        ((org-agenda-overriding-header "Tasks to Refile")
                         (org-tags-match-list-sublevels nil)))
                  (tags-todo "-CANCELLED/!"
                             ((org-agenda-overriding-header "Stuck Projects")
                              (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-HOLD-CANCELLED/!"
                             ((org-agenda-overriding-header "Projects")
                              (org-agenda-skip-function 'bh/skip-non-projects)
                              (org-tags-match-list-sublevels 'indented)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED/!NEXT"
                             ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                              (org-tags-match-list-sublevels t)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(todo-state-down effort-up category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-non-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED+WAITING|HOLD/!"
                             ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-non-tasks)
                              (org-tags-match-list-sublevels nil)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                  (tags "-REFILE/"
                        ((org-agenda-overriding-header "Tasks to Archive")
                         (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                         (org-tags-match-list-sublevels nil))))
                 nil))))


  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

  ;; Use full outline paths for refile targets - we file directly with IDO
  (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))
  
                                        ; Use IDO for both buffer and file completion and ido-everywhere to t
  (setq org-completion-use-ido t)
  (setq ido-everywhere t)
  (setq ido-max-directory-size 100000)
  (ido-mode (quote both))
                                        ; Use the current window when visiting files and buffers with ido
  (setq ido-default-file-method 'selected-window)
  (setq ido-default-buffer-method 'selected-window)
                                        ; Use the current window for indirect buffer display
  (setq org-indirect-buffer-display 'current-window)

  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets"
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))
  (setq org-refile-target-verify-function 'bh/verify-refile-target)


  ;; Remove empty LOGBOOK drawers on clock out
  (defun bh/remove-empty-drawer-on-clock-out ()
    (interactive)
    (save-excursion
      (beginning-of-line 0)
      (org-remove-empty-drawer-at (point))))

  (defun formatted-copy ()
    "Export region to HTML, and copy it to the clipboard."
    (interactive)
    (save-window-excursion
      (shell-command-on-region
       (point-min)
       (point-max)
       "pandoc -f org -t rtf ")) 
    )
  
  (defvar bh/hide-scheduled-and-waiting-next-tasks t)
  
  (defun bh/prepare-meeting-notes ()
    "Prepare meeting notes for email
   Take selected region and convert tabs to spaces, mark TODOs with leading >>>, and copy to kill ring for pasting"
    (interactive)
    (let (prefix)
      (save-excursion
        (save-restriction
          (narrow-to-region (region-beginning) (region-end))
          (untabify (point-min) (point-max))
          (goto-char (point-min))
          (while (re-search-forward "^\\( *-\\\) \\(TODO\\|DONE\\): " (point-max) t)
            (replace-match (concat (make-string (length (match-string 1)) ?>) " " (match-string 2) ": ")))
          (goto-char (point-min))
          (kill-ring-save (point-min) (point-max))))))  

  (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
  )

(use-package ox-clip
  :ensure t)

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


(global-auto-revert-mode t)

(provide 'module-org)

