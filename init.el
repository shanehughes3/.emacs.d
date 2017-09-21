(require 'package)

(add-to-list 'package-archives
         '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(when (require 'use-package nil 'noerror)
  (package-install 'use-package))

(require 'whitespace)

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
	(fill-column-indicator use-package helm web-mode tide)))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "nil" :slant normal :weight normal :height 150 :width normal)))))

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

;; mac key bindings
(when (eq system-type 'darwin)
  (setq mac-function-modifier 'control)
  (setq mac-command-modifier 'meta)
  (setq mac-right-option-modifier 'control)
  )

;; melpa
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/") t)
  )
;; run M-x package-refresh-contents
;; then M-x package-install
;; currently installed: web-mode tide
;;
;; to update: M-x package-list-packages [ret] U x

;; web-mode setup
;;
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

(add-hook 'local-write-file-hooks
      (lambda ()
        (delete-trailing-whitespace)
        nil))

;; helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-c h o") 'helm-occur))


;; 80-column vertical rule
(use-package fill-column-indicator
  :ensure t
  :init
  (setq fci-rule-color "#444444"))
(add-hook 'after-change-major-mode-hook
		  (lambda () (if (string= major-mode "web-mode")
						 (turn-off-fci-mode) (turn-on-fci-mode))))

