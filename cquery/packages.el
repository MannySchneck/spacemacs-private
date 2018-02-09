;;; packages.el --- manny/cquery layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: manny <manny@manny-phenix>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `manny/cquery-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `manny/cquery/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `manny/cquery/pre-init-PACKAGE' and/or
;;   `manny/cquery/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(spacemacs|defvar-company-backends c++-mode)

(defconst cquery-packages
  '((cquery :location local)
    lsp-mode
    lsp-ui
    company-lsp
    markdown-mode)
  "The list of Lisp packages required by the manny/cquery layer.


Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")


(defun cquery/lsp-mode ()
  (use-package lsp-mode
    :config
    (progn
      (spacemacs/add-to-hook #'lsp-mode c++-mode-hook)
      (require 'lsp-flycheck)
      (lsp-flycheck-setup))))

(defun cquery/init-company-lsp ()
  (use-package company-lsp
    :config
    (progn
      (setq company-lsp-async t
            company-transformers nil
            company-lsp-cache-candidates nil)
      (push 'company-lsp company-backends-c-mode-common)
      )))

;; (defun cquery/init-markdown-mode ()
;;   (use-package markdown-mode)
;;   )

(defun cquery/init-lsp-ui ()
  (use-package lsp-ui
    :after lsp-mode
    ;; :after markdown-mode
    :config
    (add-hook 'lsp-after-open-hook 'lsp-ui-mode)
    ))

;; (defun cquery/init-helm-xref ()
;;   "from github.com/MaskRay/Config"
;;   (use-package helm-xref
;;     :config
;;     (progn
;;       (setq xref-prompt-for-identifier
;;             '(not xref-find-definitions xref-find-definitions-other-window
;;                   xref-find-definitions-other-frame xref-find-references
;;                   spacemacs/jump-to-definition spacemacs/jump-to-reference))
;;       (setq xref-show-xrefs-function 'helm-xref-show-xrefs))
;;     ))

(defun cquery/init-cquery ()
  (use-package cquery
    :after lsp-mode
    :init
    (progn
      (setq cquery-executable "/home/manny/source/cquery/build/release/bin/cquery")
      ;(setq cquery-extra-init-params '(:index (comments 2) :cacheformat "msgpack"))
      (spacemacs/add-to-hooks #'lsp-cquery-enable '(c-mode-hook c++-mode-hook))
      (dolist (mode '(c-mode c++-mode))
        (evil-leader/set-key-for-mode mode
          "r." 'lsp-ui-peek-find-definitions
          "r," 'lsp-ui-peek-find-references
          "r[" 'lsp-ui-peek-jump-backward
          "r]" 'lsp-ui-peek-jump-forward
          "rl" 'helm-imenu
          )))))



;;; packages.el ends here
