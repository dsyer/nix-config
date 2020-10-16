
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;(add-to-list 'package-archives
;             '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives
;             '("marmalade" . "https://marmalade-repo.org/packages/") t)

(setq load-path (cons (expand-file-name "~/bin/elisp") load-path))

(jdecomp-mode 1)
(customize-set-variable 'jdecomp-decompiler-paths
                        '((cfr . "~/bin/cfr_0.150.jar")))
;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
   (cons '("\\.md" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
   (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist
   (cons '("\\.mdt" . markdown-mode) auto-mode-alist))

(setq backup-directory-alist `(("." . "~/.emacs-saves")))

(add-hook 'nxml-mode-hook '(lambda () 
  (setq 
   indent-tabs-mode t
   nxml-child-indent 4
   nxml-attribute-indent 4
   tab-width 4)
))

(add-hook 'sgml-mode-hook '(lambda () 
  (setq indent-tabs-mode t)(setq-default tab-width 4)
))

(add-hook 'ruby-mode-hook '(lambda ()
  (load-library "rvm")
  ))

(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
      (jump-to-register '_) 
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
(define-key global-map (kbd "C-S-x") 'toggle-maximize-buffer)

(defun open-in-browser()
"open buffer in browser, unless it is not a file. Then fail silently (ouch)."
  (interactive)
  (if (buffer-file-name)
      (let ((filename (buffer-file-name)))
        (shell-command (concat (executable-find browse-url-chromium-program) " file:" filename)))))

(setq auto-mode-alist (append auto-mode-alist
'(("\\.rake$" . ruby-mode)
("\\.gemspec$" . ruby-mode)
("\\.ru$" . ruby-mode)
("\\.god$" . ruby-mode)
("Rakefile$" . ruby-mode)
("Gemfile$" . ruby-mode)
("capfile$" . ruby-mode)
("Capfile$" . ruby-mode))))

(defvar fill-column 90)
(defun unfill-paragraph () 
  (interactive)
  (let ((fill-column (point-max)))
  (fill-paragraph nil)))
(defun toggle-fill-paragraph () 
  (interactive)
  (if (> fill-column 90) (set-fill-column 90) (set-fill-column (point-max)))
  (fill-paragraph nil))
; (define-key global-map "\M-q" 'fill-paragraph)
(define-key global-map "\C-\M-q" 'toggle-fill-paragraph)

;(require 'lsp)
;; in case you are using client which is available as part of lsp refer to the
;; table bellow for the clients that are distributed as part of lsp-mode.el
;(require 'lsp-clients)
                                        ;(add-hook 'java-mode-hook 'lsp)

;(require 'meghanada)
;(add-hook 'java-mode-hook
;          (lambda ()
;            ;; meghanada-mode on
;            (meghanada-mode t)
;            (flycheck-mode +1)
;            ;; use code format
;            (add-hook 'before-save-hook 'meghanada-code-beautify-before-save)))
;(cond
;   ((eq system-type 'windows-nt)
;    (setq meghanada-java-path (expand-file-name "bin/java.exe" (getenv "JAVA_HOME")))
;    (setq meghanada-maven-path "mvn.cmd"))
;   (t
;    (setq meghanada-java-path "java")
;    (setq meghanada-maven-path "mvn")))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(browse-url-browser-function (quote browse-url-chromium))
 '(browse-url-chromium-program "google-chrome")
 '(global-auto-revert-mode t)
 '(indent-tabs-mode t)
 '(package-selected-packages (quote (jdecomp meghanada lsp-java)))
 '(tab-width 4)
 '(woman-use-own-frame nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Noto Mono" :foundry "GOOG" :slant normal :weight normal :height 113 :width normal)))))

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
