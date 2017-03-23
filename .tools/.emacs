(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(require 'evil)
(evil-mode 1)
(flyspell-mode 1)

(setq-default indent-tabs-mode nil)
(setq tab-width 4)

(use-package markdown-mode
:ensure t
:commands (markdown-mode gfm-mode)
:mode (("README\\.md\\'" . gfm-mode)
("\\.md\\'" . markdown-mode)
("\\.markdown\\'" . markdown-mode))
:init (setq markdown-command "multimarkdown"))

(global-set-key (kbd "<f7>") 'ispell-word)
