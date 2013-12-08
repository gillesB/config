(defmacro bind (&rest commands)
  "Convience macro which creates a lambda interactive command."
  `(lambda ()
     (interactive)
     ,@commands))

(require-package 'guide-key)
(require 'guide-key)
(setq guide-key/guide-key-sequence '("C-x" "C-c"))
(setq guide-key/recursive-key-sequence-flag t)
(guide-key-mode 1)

(global-set-key (kbd "M-o") 'helm-imenu) ;'ido-goto-symbol
(global-set-key (kbd "M-l") 'helm-buffers-list) ;'switch-to-buffer
(global-set-key (kbd "C-p") 'helm-projectile)

(after 'smex
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "C-x C-m") 'smex)
  (global-set-key (kbd "C-c C-m") 'smex))

(after 'evil
  (require-package 'key-chord)
  (key-chord-mode 1)
  (setq key-chord-two-keys-delay 0.5)
  (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
  (key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
  (define-key evil-normal-state-map (kbd "ZZ") 'evil-quit-all)

(after 'evil-leader
  (evil-leader/set-leader ",")
  (evil-leader/set-key
    "w" 'evil-write
    "e" (kbd "C-x C-e") ;;'eval-last-sexp
    "E" (kbd "C-M-x") ;;'eval-defun
    "c" (bind
          (evil-window-split)
          (eshell))
    "C" 'customize-group
    "b d" 'kill-this-buffer
    "v" (kbd "C-w v C-w l")
    "s" (kbd "C-w s C-w j")
    "g s" 'magit-status
    "g l" 'magit-log
    "g d" 'vc-diff
    "V" (bind (term "vim"))
    "h" help-map
    "h h" 'help-for-help-internal))

(after 'evil-matchit
  (define-key evil-normal-state-map "%" 'evilmi-jump-items))

  (after 'git-gutter+-autoloads
    (define-key evil-normal-state-map (kbd "[ c") 'git-gutter+-previous-hunk)
    (define-key evil-normal-state-map (kbd "] c") 'git-gutter+-next-hunk)
    (define-key evil-normal-state-map (kbd ", g a") 'git-gutter+-stage-hunks)
    (define-key evil-normal-state-map (kbd ", g r") 'git-gutter+-revert-hunks)
    (evil-ex-define-cmd "Gw" (lambda () (interactive) (git-gutter+-stage-whole-buffer))))


  (after 'smex
    (define-key evil-visual-state-map (kbd "SPC") 'smex)
    (define-key evil-normal-state-map (kbd "SPC") 'smex))
  (define-key evil-normal-state-map (kbd "M-t") 'helm-etags-select)
  (define-key evil-normal-state-map (kbd "M-y") 'helm-show-kill-ring)

  (define-key evil-normal-state-map "gw" nil)
  (define-key evil-motion-state-map "gw" 'evil-window-map)

  (define-key evil-normal-state-map (kbd "[ SPC") (lambda () (interactive) (evil-insert-newline-above) (forward-line)))
  (define-key evil-normal-state-map (kbd "] SPC") (lambda () (interactive) (evil-insert-newline-below) (forward-line -1)))
  (define-key evil-normal-state-map (kbd "[ b") 'previous-buffer)
  (define-key evil-normal-state-map (kbd "] b") 'next-buffer)

  (define-key evil-normal-state-map (kbd "C-p") nil)
  (define-key evil-normal-state-map (kbd "C-q") 'universal-argument)

  (define-key evil-motion-state-map "j" 'evil-next-visual-line)
  (define-key evil-motion-state-map "k" 'evil-previous-visual-line)
  (define-key evil-normal-state-map (kbd "0") 'evil-first-non-blank)
  (define-key evil-normal-state-map (kbd "-") 'evil-last-non-blank)
  (define-key evil-normal-state-map (kbd "Y") (kbd "y$"))
  
  ;; file management
  (define-key evil-normal-state-map "^" nil)
  (define-key evil-normal-state-map (kbd "^")
    (bind
     (sr-speedbar-open)
     (sr-speedbar-refresh)
     (sr-speedbar-select-window)))
  (define-key evil-normal-state-map (kbd "g x") 'browse-url-at-point)

  ;; emacs lisp
  (evil-define-key 'normal emacs-lisp-mode-map (kbd "K") (kbd ", h f RET"))

  ;; proper jump lists
  ;; (require-package 'jumpc)
  ;; (jumpc)
  ;; (define-key evil-normal-state-map (kbd "C-o") 'jumpc-jump-backward)
  ;; (define-key evil-normal-state-map (kbd "C-i") 'jumpc-jump-forward)

  (after 'company
    (define-key evil-insert-state-map (kbd "TAB") 'my-company-tab)
    (define-key evil-insert-state-map [tab] 'my-company-tab))

  (after 'multiple-cursors
    (define-key evil-emacs-state-map (kbd "C->") 'mc/mark-next-like-this)
    (define-key evil-emacs-state-map (kbd "C-<") 'mc/mark-previous-like-this)
    (define-key evil-visual-state-map (kbd "C->") 'mc/mark-all-like-this)
    (define-key evil-normal-state-map (kbd "C->") 'mc/mark-next-like-this)
    (define-key evil-normal-state-map (kbd "C-<") 'mc/mark-previous-like-this))

  (after 'magit
    (evil-add-hjkl-bindings magit-status-mode-map 'emacs
      "K" 'magit-discard-item
      "l" 'magit-key-mode-popup-logging
      "h" 'magit-toggle-diff-refine-hunk))

  )

;; minibuffer keymaps
;;    esc key
(define-key minibuffer-local-map [escape] 'my-minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'my-minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'my-minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'my-minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'my-minibuffer-keyboard-quit)
;;    other
(define-key minibuffer-local-map (kbd "C-w") 'backward-kill-word)
(define-key minibuffer-local-map (kbd "C-u") 'backward-kill-sentence)

(after 'comint
  (define-key comint-mode-map [up] 'comint-previous-input)
  (define-key comint-mode-map [down] 'comint-next-input))

(after 'auto-complete
  (define-key ac-completing-map "\t" 'ac-expand)
  (define-key ac-completing-map [tab] 'ac-expand)
  (define-key ac-completing-map (kbd "C-n") 'ac-next)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous))


(after 'company
  (define-key company-active-map "\t" 'my-company-tab)
  (define-key company-active-map [tab] 'my-company-tab)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))


;; mouse scrolling in terminal
(unless (display-graphic-p)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))


;; have no use for these default bindings
(global-unset-key (kbd "C-x m"))
(global-set-key (kbd "C-x C-c") (lambda () (interactive) (message "Thou shall not quit!")))
(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)


(provide 'init-bindings)
