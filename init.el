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

(package-initialize)

(when (require 'use-package nil 'noerror)
  (package-install 'use-package))

(require 'whitespace)
(setq-default whitespace-style '(face indentation::tab indentation::space tab trailing))
(setq-default whitespace-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
	(ess markdown-mode json-mode all-the-icons neotree sublimity exec-path-from-shell flycheck fill-column-indicator use-package helm web-mode tide)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "nil" :slant normal :weight normal :height 130 :width normal)))))

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

;;; remove trailing whitespace on save
(add-hook 'local-write-file-hooks
      (lambda ()
        (delete-trailing-whitespace)
        nil))

;;; mac key bindings
(when (eq system-type 'darwin)
  (setq mac-function-modifier 'control)
  (setq mac-command-modifier 'meta)
  (setq mac-right-option-modifier 'control)
  )

;;; melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/") t)
  )

;;;;;;;;;;;;
;;; packages

;;; web-mode & setup
(use-package web-mode
  :ensure t)

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
(add-to-list 'auto-mode-alist '("\\.ts\\'" . web-mode))

(add-hook 'web-mode-hook
      (lambda ()
        ;; short circuit js mode and just do everything in jsx-mode
        (if (equal web-mode-content-type "javascript")
            (web-mode-set-content-type "jsx")
          (message "now set to: %s" web-mode-content-type))))

(defun custom-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-enable-auto-quoting nil)
  (setq-default indent-tabs-mode t)
  (web-mode-use-tabs)
  (setq-default tab-width 4)
)
(add-hook 'web-mode-hook  'custom-web-mode-hook)

(use-package json-mode
  :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

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
(use-package fill-column-indicator
  :ensure t
  :init
  (setq fci-rule-color "#444444"))
;; enable on all modes except web-mode (due to bug:
;; https://github.com/alpaker/Fill-Column-Indicator/issues/46 )
(add-hook 'after-change-major-mode-hook
		  (lambda () (if (string= major-mode "web-mode")
						 (turn-off-fci-mode) (turn-on-fci-mode))))

;;; eslint (WIP)
(use-package flycheck
  :init
  :ensure t)
(use-package exec-path-from-shell
  :ensure t)
(add-hook 'after-init-hook #'global-flycheck-mode)
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
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))



;;;;;;;;;;;;;;;;
;;; other config
(setq-default c-default-style "linux")

(provide 'init)
;;; init.el ends here
