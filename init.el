(setq inhibit-startup-message t)


;; UI settings
(global-display-line-numbers-mode 1) ; Display line numbers

(scroll-bar-mode -1)        ; Disable scrollbar
(tool-bar-mode -1)          ; Disable toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room
(menu-bar-mode -1)          ; Disable menu bar

;; Enable visible bell
(setq visible-bell t)

;; Font
(set-face-attribute 'default nil :font "JetBrains Mono" :height 110)

;; Theme
(load-theme 'tango-dark)


;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; For trouble shooting
;; (use-package command-log-mode)

;; Enable which-key
(which-key-mode 1)
(which-key-setup-side-window-right-bottom)

;; ivy config
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Doom mode line settings

;; LSP settings
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

;; LSP UI setup
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

;; Sideline documentation
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-sideline-show-hover nil)

;; Company Mode
(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; lsp-treemacs
(use-package lsp-treemacs
  :after lsp)
;; lsp-ivy
(use-package lsp-ivy)

;; Header Breadcrumb

(require 'lsp-mode)
;; Bash LSP settings
;; ------------------
(add-hook 'sh-mode-hook 'lsp)
(setq lsp-bash-server '("bash-ls"))

;; C/C++ LSP settings
;; ------------------
(add-hook 'c-mode-common-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(setq lsp-clangd-executable "clangd")

;; Go LSP settings
;; ------------------
(add-hook 'go-mode-hook 'lsp)


;; JS/TS LSP settings
;; ------------------
;; (use-package typescript-mode
;;   :mode "\\.ts\\'"
;;   :hook (typescript-mode . lsp-deferred)
;;   :config
;;   (setq typescript-indent-level 2))
