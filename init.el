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
;; ---------------
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  :ensure t
  ;; Optional: Set the host to be non-blocking for better performance
  (setq lsp-enable-text-document-did-change t) ; More frequent updates
  (setq lsp-idle-delay 0.5) ; Lower delay for less lag
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :hook (
         (ruby-mode . lsp-deferred)        ; For Ruby (using ruby-lsp)
	 (c-mode . lsp-deferred)           ; For C (using clangd)
         (c++-mode . lsp-deferred)         ; For C++ (using clangd)
         (js-mode . lsp-deferred)          ; For JavaScript (using typescript-language-server, eslint_d, etc.)
         (typescript-mode . lsp-deferred)  ; For TypeScript
	 ;;(go-mode . lsp-deferred)          ; For Go (using gopls)
	 ;;(python-mode . lsp-deferred)      ; For Python (using pylsp, pyright, etc.)
         ;;(rust-mode . lsp-deferred)        ; For Rust (using rust-analyzer)
         )
  :config
  (lsp-enable-which-key-integration t))

;; LSP UI setup
(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

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

;; Ruby LSP settings
;;-------------------
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-enable-text-document-did-change t)
  (setq lsp-idle-delay 0.5)
  :hook ((ruby-mode . lsp-deferred))
  :custom
  (lsp-ruby-lsp-use-bundler t) ;; Set to t if you use bundler to run ruby-lsp
  ;; If ruby-lsp isn't found specify the command:
  ;; (lsp-language-id-configuration '(("ruby" . (("ruby-lsp" . ("bundle" "exec" "ruby-lsp"))))))
  ;; For a version manager like rbenv:
  ;; (lsp-language-id-configuration '(("ruby" . (("ruby-lsp" . ("~/.rbenv/shims/ruby-lsp"))))))
  )

;; JS/TS LSP settings
;; ------------------
(use-package typescript-mode
   :mode "\\.ts\\'"
   :hook (typescript-mode . lsp-deferred)
   :config
   (setq typescript-indent-level 2)
)
;;Other settings
