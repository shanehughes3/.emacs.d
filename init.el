;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;; Code:
;;; (this makes flycheck be quiet in this file)

;;;;;;;;;;;;;;;
;;; basic setup

(require 'package)

(add-to-list 'package-archives
         '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(setq load-prefer-newer t)
(package-initialize)

(when (require 'use-package nil 'noerror)
  (package-install 'use-package))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(git-gutter:added-sign "++")
 '(git-gutter:deleted-sign "--")
 '(git-gutter:modified-sign "==")
 '(git-gutter:update-interval 2)
 '(inhibit-startup-screen t)
 '(neo-vc-integration (quote (face)))
 '(package-selected-packages
   (quote
    (diff-hl-mode git-gutter auto-compile js2-mode ess markdown-mode json-mode all-the-icons neotree sublimity exec-path-from-shell flycheck fill-column-indicator use-package helm web-mode tide)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "nil" :slant normal :weight normal :height 130 :width normal))))
 '(font-lock-builtin-face ((t (:foreground "#cc33ff"))))
 '(font-lock-comment-face ((t (:foreground "#777777"))))
 '(font-lock-constant-face ((t (:foreground "#33e6e6"))))
 '(font-lock-function-name-face ((t (:foreground "#d34747"))))
 '(font-lock-keyword-face ((t (:foreground "#e68a00"))))
 '(font-lock-string-face ((t (:foreground "LimeGreen")))))

;;(add-to-list 'default-frame-alist '(font . "Ubuntu Mono"))
;;(set-face-attribute 'default t :font "Ubuntu Mono")
;;(set-face-attribute 'default nil :font "Ubuntu Mono")
;;(set-face-attribute 'default nil :height 160)
;;(set-face-attribute 'default t :height 160)
;;(set-frame-font "Ubuntu Mono" nil t)
;;(tool-bar-mode 0)
(column-number-mode 1)

(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default line-spacing 5)
(global-linum-mode 1)
(if window-system
	(tool-bar-mode -1))
(setq-default c-basic-offset 8 tab-width 8 indent-tabs-mode nil)

;;; remove trailing whitespace on save
(add-hook 'local-write-file-hooks
      (lambda ()
        (delete-trailing-whitespace)
        nil))

;;; mac key bindings
(when (eq system-type 'darwin)
  (setq-default mac-function-modifier 'control)
  (setq-default mac-command-modifier 'meta)
  (setq-default mac-right-option-modifier 'control)
  )

;; show man page on f1
(global-set-key [(f1)] (lambda()
                         (interactive)
                         (manual-entry (current-word))))

;;; melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/") t)
  )

;;;;;;;;;;;;;;;;
;;; other config
(setq-default c-default-style "linux")

;;;;;;;;;;;;
;;; packages

(require 'whitespace)
(setq-default whitespace-style '(face tabs tabs-mark trailing lines))
(setq-default whitespace-line-column 78)
(setq-default whitespace-mode 1)

;;; web-mode & setup
(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.s?css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode)))

;; (add-hook 'web-mode-hook
;;       (lambda ()
;;         ;; short circuit js mode and just do everything in jsx-mode
;;         (if (equal web-mode-content-type "javascript")
;;  n           (web-mode-set-content-type "jsx")
;;           (message "now set to: %s" web-mode-content-type))))

(defun custom-web-mode-hook ()
  "Hooks for Web mode."
  (setq-default web-mode-enable-auto-quoting nil)
  (setq-default indent-tabs-mode t)
  (web-mode-use-tabs)
  (setq tab-width 4)
  (setq web-mode-code-indent-offset 4)
  (setq c-basic-offset 4)
  (set-face-attribute 'web-mode-variable-name-face nil :foreground "#c678dd"))
(add-hook 'web-mode-hook 'custom-web-mode-hook)

(use-package json-mode
  :ensure t)

;; (use-package js2-mode
;;   :ensure t
;;   :mode ("\\.js\\'" . js2-mode)
;;   :config
;;   (setq-default js2-basic-offset 4)
;;   (setq-default indent-tabs-mode t))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq-default markdown-command "multimarkdown"))

;;; R engine
(use-package ess
  :ensure t)

;;; helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-c h o") 'helm-occur))


(use-package org
  :ensure t
  :mode (("\\.org$" . org-mode)))

;;; 80-column vertical rule
;; (use-package fill-column-indicator
;;   :ensure t
;;   :init
;;   (setq-default fci-rule-color "#444444")
;;   (setq-default fci-rule-column 80))
;; ;; enable on all modes except web-mode (due to bug:
;; ;; https://github.com/alpaker/Fill-Column-Indicator/issues/46 )
;; (add-hook 'after-change-major-mode-hook
;; 		  (lambda () (if (string= major-mode "web-mode")
;; 						 (turn-off-fci-mode) (turn-on-fci-mode))))

;;; eslint (WIP)
(use-package flycheck
  :init
  :ensure t
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (setq-default flycheck-disabled-checkers '(javascript-jshint)))
(use-package exec-path-from-shell
  :ensure t)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

;; (setq-default flycheck-disabled-checkers
;; 			  (append flycheck-disabled-checkers
;; 					  '(javascript-jshint)))
;; (flycheck-add-mode flycheck-temp-prefix ".flycheck")
;; (setq-default flycheck-disabled-checkers
;; 			  (append flycheck-disabled-checkers
;; 					  '(json-jsonlist)))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;; smooth scrolling
(use-package sublimity
  :ensure t
  :config (require 'sublimity)
  (require 'sublimity-scroll)
  (sublimity-mode 1)
  (setq-default sublimity-auto-hscroll-mode 1))

;;; directory tree and associated fonts/icons
(use-package all-the-icons
  :ensure t) ;;; you must run all-the-icons-install-fonts for this to work!
(use-package neotree
  :ensure t
  :config (require 'neotree)
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (custom-set-variables
   '(neo-vc-integration (quote (face)))))

;; git change info
;; (use-package git-gutter
;;   :ensure t
;;   :config
;;   (global-git-gutter-mode +1)
;;   (git-gutter:linum-setup)
;;   (custom-set-variables
;;    '(git-gutter:update-interval 2)
;;    '(git-gutter:added-sign "++")
;;    '(git-gutter:deleted-sign "--")
;;    '(git-gutter:modified-sign "==")))
;; (use-package diff-hl-mode
;;   :ensure t)

(use-package auto-compile
  :ensure t
  :config
  (auto-compile-on-load-mode)
  (auto-compile-on-save-mode))


;;;;;;;;;;;;;;;
;;; keybindings

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (forward-line 1)
  (yank)
)
(global-set-key (kbd "s-d") 'duplicate-line)

(provide 'init)
;;; init.el ends here
