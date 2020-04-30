;;; apt-mode.el --- Major mode to edit Apt files in Emacs

;; Copyright (C) 2007, 2008 Jason Blevins

;; Version: 1.6
;; Keywords: Apt major mode
;; Author: Jason Blevins <jrblevin@sdf.lonestar.org>
;; URL: http://jblevins.org/projects/apt-mode/

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; apt-mode is a major mode for editing [Apt][]-formatted
;; text files in GNU Emacs.  apt-mode is free software, licensed
;; under the GNU GPL.
;;
;;  [Apt]: http://daringfireball.net/projects/apt/
;;
;; The latest version is apt-mode 1.6, released on June 4. 2008:
;;
;;  * [apt-mode.el][]
;;  * [Screenshot][]
;;  * [Release notes][]
;;
;; apt-mode is also available in the Debian `emacs-goodies-el`
;; package (beginning with revision 27.0-1).
;;
;;  [apt-mode.el]: http://code.jblevins.org/apt-mode/apt-mode.el
;;  [screenshot]: http://jblevins.org/projects/apt-mode/screenshots/20080604-001.png
;;  [release notes]: http://jblevins.org/projects/apt-mode/rev-1-6

;;; Dependencies:

;; apt-mode requires easymenu, a standard package since GNU Emacs
;; 19 and XEmacs 19, which provides a uniform interface for creating
;; menus in GNU Emacs and XEmacs.

;;; Installation:

;; Make sure to place `apt-mode.el` somewhere in the load-path and add
;; the following lines to your `.emacs` file to associate apt-mode
;; with `.text` files:
;;
;;     (autoload 'apt-mode "apt-mode.el"
;;        "Major mode for editing Apt files" t)
;;     (setq auto-mode-alist
;;        (cons '("\\.text" . apt-mode) auto-mode-alist))
;;
;; There is no consensus on an official file extension so change `.text` to
;; `.mdwn`, `.md`, `.mdt`, or whatever you call your apt files.

;;; Usage:

;; Although no configuration is necessary there are a few things that can
;; be customized (`M-x customize-mode`).
;;
;; Keybindings are grouped by prefixes based on their function.  For
;; example, commands dealing with headers begin with `C-c C-t`.  The
;; primary commands in each group will are described below.  You can
;; obtain a list of all keybindings by pressing `C-c C-h`.
;;
;; * Anchors: `C-c C-a`
;;
;;   `C-c C-a l` inserts inline links of the form `[text](url)`.  If
;;   there is an active region, text in the region is used for the link
;;   text.  `C-c C-a w` acts similarly for wiki links of the form
;;   `[[WikiLink]]`.
;;
;; * Commands: `C-c C-c`
;;
;;   `C-c C-c m` will run Apt on the current buffer and preview the
;;   output in another buffer while `C-c C-c p` runs Apt on the
;;   current buffer and previews the output in a browser.
;;
;;   `C-c C-c c` will check for undefined references.  If there are any,
;;   a small buffer will open with a list of undefined references and
;;   the line numbers on which they appear.  In Emacs 22 and greater,
;;   selecting a reference from this list and pressing `RET` will insert
;;   an empty reference definition at the end of the buffer.  Similarly,
;;   selecting the line number will jump to the corresponding line.
;;
;; * Images: `C-c C-i`
;;
;;   `C-c C-i i` inserts an image, using the active region (if any) as
;;   the alt text.
;;
;; * Physical styles: `C-c C-p`
;;
;;   These commands all act on text in the active region, if any, and
;;   insert empty markup fragments otherwise.  `C-c C-p b` makes the
;;   selected text bold, `C-c C-p f` formats the region as fixed-width
;;   text, and `C-c C-p i` is used for italic text.
;;
;; * Logical styles: `C-c C-s`
;;
;;   These commands all act on text in the active region, if any, and
;;   insert empty markup fragments otherwise.  Logical styles include
;;   blockquote (`C-c C-s b`), preformatted (`C-c C-s p`), code (`C-c C-s c`),
;;   emphasis (`C-c C-s e`), and strong (`C-c C-s s`).
;;
;; * Headers: `C-c C-t`
;;
;;   All header commands use text in the active region, if any, as the
;;   header text.  To insert an atx or hash style level-n header, press
;;   `C-c C-t n` where n is between 1 and 5.  For a top-level setext or
;;   underline style header press `C-c C-t t` (mnemonic: title) and for
;;   a second-level underline-style header press `C-c C-t s`
;;   (mnemonic: section).
;;
;; * Other commands
;;
;;   `C-c -` inserts a horizontal rule.
;;
;; Many of the commands described above behave differently depending on
;; whether Transient Mark mode is enabled or not.  When it makes sense,
;; if Transient Mark mode is on and a region is active, the command
;; applies to the text in the region (e.g., `C-c C-p b` makes the region
;; bold).  For users who prefer to work outside of Transient Mark mode,
;; in Emacs 22 it can be enabled temporarily by pressing `C-SPC C-SPC`.
;;
;; When applicable, commands that specifically act on the region even
;; outside of Transient Mark mode have the same keybinding as the with
;; the exception of an additional `C-` prefix.  For example,
;; `apt-insert-blockquote` is bound to `C-c C-s b` and only acts on
;; the region in Transient Mark mode while `apt-blockquote-region`
;; is bound to `C-c C-s C-b` and always applies to the region (when
;; nonempty).
;;
;; Apt mode supports outline-minor-mode as well as org-mode-style
;; visibility cycling for atx- or hash-style headers.  There are two
;; types of visibility cycling: Pressing `S-TAB` cycles globally between
;; the table of contents view (headers only), outline view (top-level
;; headers only), and the full document view.  Pressing `TAB` while the
;; point is at a header will cycle through levels of visibility for the
;; subtree: completely folded, visiable children, and fully visible.
;; Note that mixing hash and underline style headers will give undesired
;; results.

;;; Extensions:

;; Besides supporting the basic Apt syntax, apt-mode also
;; includes syntax highlighting for `[[Wiki Links]]` by default.
;;
;; [SmartyPants][] support is possible by customizing `apt-command`.
;; If you install `SmartyPants.pl` at, say, `/usr/local/bin/smartypants`,
;; then you can set `apt-command` to `"apt | smartypants"`.
;; You can do this either by using `M-x customize-group apt`
;; or by placing the following in your `.emacs` file:
;;
;;     (defun apt-custom ()
;;       "apt-mode-hook"
;;       (setq apt-command "apt | smartypants"))
;;     (add-hook 'apt-mode-hook '(lambda() (apt-custom)))
;;
;; Experimental syntax highlighting for mathematical expressions written
;; in LaTeX (only expressions denoted by `$..$`, `$$..$$`, or `\[..\]`)
;; can be enabled by editing `apt-mode.el` and changing `(defvar
;; apt-enable-itex nil)` to `(defvar apt-enable-itex t)`.
;;
;; [SmartyPants]: http://daringfireball.net/projects/smartypants/

;;; Thanks:

;; * Cyril Brulebois <cyril.brulebois@enst-bretagne.fr> for Debian packaging.
;; * Conal Elliott <conal@conal.net> for a font-lock regexp patch.
;; * Edward O'Connor <hober0@gmail.com> for a font-lock regexp fix.
;; * Greg Bognar <greg_bognar@hms.harvard.edu> for menus and a patch.
;; * Daniel Burrows <dburrows@debian.org> for filing Debian bug #456592.
;; * Peter S. Galbraith <psg@debian.org> for maintaining emacs-goodies-el.
;; * Dmitry Dzhus <mail@sphinx.net.ru> for reference checking functions.

;;; Bugs:

;; Apt mode is developed and tested primarily using GNU Emacs 22
;; although compatibility with GNU Emacs 21 is also a priority.
;; 
;; Presently Apt mode does not attempt to distinguish between
;; multiple indentation levels and preformatted text (four or more
;; leading spaces).  I am not aware of a way to handle this using
;; Emacs's regexp-based font-lock facilities.  Implementing a more
;; robust approach to syntax highlighting is a high-priority item for
;; future work.
;; 
;; If you find any bugs, such as syntax highlighting issues, please
;; construct a test case and email me at <jrblevin@sdf.lonestar.org>.
;; Comments and patches are welcome!



;;; Code:

(require 'easymenu)
(require 'outline)

;;; User Customizable Variables ===============================================

;; To enable LaTeX/itex syntax highlighting, change to
;; (defvar apt-enable-itex t)
(defvar apt-enable-itex nil)


;;; Customizable variables ====================================================

;; Current revision
(defconst apt-mode-version "1.6")

;; A hook for users to run their own code when the mode is loaded.
(defvar apt-mode-hook nil)


;;; Customizable variables ====================================================

(defgroup apt nil
  "Major mode for editing text files in Apt format."
  :prefix "apt-"
  :group 'wp
  :link '(url-link "http://jblevins.org/projects/apt-mode/"))

(defcustom apt-command "apt-convert"
  "Command to run apt."
  :group 'apt
  :type 'string)

(defcustom apt-hr-length 5
  "Length of horizonal rules."
  :group 'apt
  :type 'integer)

(defcustom apt-bold-underscore nil
  "Use two underscores for bold instead of two asterisks."
  :group 'apt
  :type 'boolean)

(defcustom apt-italic-underscore nil
  "Use underscores for italic instead of asterisks."
  :group 'apt
  :type 'boolean)


;;; Font lock =================================================================

(require 'font-lock)

(defgroup apt-faces nil
  "Faces used in Apt Mode"
  :group 'apt
  :group 'faces)

(defcustom apt-italic-face 'font-lock-variable-name-face
  "Italic text."
  :group 'apt-faces
  :type '(face))

(defcustom apt-bold-face 'font-lock-type-face
  "Bold text"
  :group 'apt-faces
  :type '(face))

(defcustom apt-header-face 'font-lock-function-name-face
  "Headers"
  :group 'apt-faces
  :type '(face))

(defcustom apt-inline-code-face 'font-lock-builtin-face
  "Inline code"
  :group 'apt-faces
  :type '(face))

(defcustom apt-list-face 'font-lock-variable-name-face
  "List item markers"
  :group 'apt-faces
  :type '(face))

(defcustom apt-blockquote-face 'font-lock-comment-face
  "Blockquote sections and preformatted text"
  :group 'apt-faces
  :type '(face))

(defcustom apt-link-face 'font-lock-constant-face
  "Link text"
  :group 'apt-faces
  :type '(face))

(defcustom apt-reference-face 'font-lock-type-face
  "Link references"
  :group 'apt-faces
  :type '(face))

(defcustom apt-url-face 'font-lock-string-face
  "URLs"
  :group 'apt-faces
  :type '(face))

(defcustom apt-math-face 'font-lock-builtin-face
  "LaTeX expressions"
  :group 'apt-faces
  :type '(face))

(defconst apt-regex-link-inline
  "\\(!?\\[[^]]*?\\]\\)\\(([^\\)]*)\\)"
  "Regular expression for a [text](file) or an image link ![text](file)")

(defconst apt-regex-link-reference
  "\\(!?\\[[^]]+?\\]\\)[ ]?\\(\\[[^]]*?\\]\\)"
  "Regular expression for a reference link [text][id]")

(defconst apt-regex-reference-definition
  "^ \\{0,3\\}\\(\\[.+?\\]\\):\\s *\\(.*?\\)\\s *\\( \"[^\"]*\"$\\|$\\)"
  "Regular expression for a link definition [id]: ...")

(defconst apt-regex-header-atx
  "^\\(#+ \\)\\(.*?\\)\\($\\| #+$\\)"
  "Regular expression for atx-style (hash mark) headers")

(defconst apt-regex-header-setext
  "^\\(.*\\)\n\\(===+\\|---+\\)$"
  "Regular expression for setext-style (underline) headers")

(defconst apt-regex-hr
  "^\\(\\*[ ]?\\*[ ]?\\*[ ]?[\\* ]*\\|-[ ]?-[ ]?-[--- ]*\\)$"
  "Regular expression for matching Apt horizontal rules")

(defconst apt-regex-code
  "\\(^\\|[^\\]\\)\\(\\(`\\{1,2\\}\\)\\([^ \\]\\|[^ ].*?[^ \\]\\)\\3\\)"
  "Regular expression for matching inline code fragments")

(defconst apt-regex-pre
  "^    .*$"
  "Regular expression for matching preformatted text sections")

(defconst apt-regex-list
  "^[ \t]*\\([0-9]+\\.\\|[\\*\\+-]\\) "
  "Regular expression for matching list markers")

(defconst apt-regex-bold
  "\\(^\\|[^\\]\\)\\(\\([*_]\\{2\\}\\)\\(.\\|\n\\)*?[^\\ ]\\3\\)"
  "Regular expression for matching bold text")

(defconst apt-regex-italic
  "\\(^\\|[^\\]\\)\\(\\([*_]\\)\\([^ \\]\\3\\|[^ ]\\(.\\|\n\\)*?[^\\ ]\\3\\)\\)"
  "Regular expression for matching italic text")

(defconst apt-regex-blockquote
  "^>.*$"
  "Regular expression for matching blockquote lines")

(defconst apt-regex-line-break
  "  $"
  "Regular expression for matching line breaks")

(defconst apt-regex-wiki-link
  "\\[\\[[^]]+\\]\\]"
  "Regular expression for matching wiki links")

(defconst apt-regex-uri
  "<\\(acap\\|cid\\|data\\|dav\\|fax\\|file\\|ftp\\|gopher\\|http\\|https\\|imap\\|ldap\\|mailto\\|mid\\|modem\\|news\\|nfs\\|nntp\\|pop\\|prospero\\|rtsp\\|service\\|sip\\|tel\\|telnet\\|tip\\|urn\\|vemmi\\|wais\\)://[^>]*>"
  "Regular expression for matching inline URIs")

(defconst apt-regex-email
  "<\\(\\sw\\|\\s_\\|\\s.\\)+@\\(\\sw\\|\\s_\\|\\s.\\)+>"
  "Regular expression for matching inline email addresses")

(defconst apt-regex-latex-expression
  "\\(^\\|[^\\]\\)\\(\\$\\($\\([^\\$]\\|\\\\.\\)*\\$\\|\\([^\\$]\\|\\\\.\\)*\\)\\$\\)"
  "Regular expression for itex $..$ or $$..$$ math mode expressions")

(defconst apt-regex-latex-display
    "^\\\\\\[\\(.\\|\n\\)*?\\\\\\]$"
  "Regular expression for itex \[..\] display mode expressions")

(defconst apt-mode-font-lock-keywords-basic
  (list
   (cons apt-regex-code '(2 apt-inline-code-face))
   (cons apt-regex-pre apt-blockquote-face)
   (cons apt-regex-header-setext apt-header-face)
   (cons apt-regex-header-atx apt-header-face)
   (cons apt-regex-list apt-list-face)
   (cons apt-regex-hr apt-header-face)
   (cons apt-regex-link-inline
         '((1 apt-link-face t)
           (2 apt-url-face t)))
   (cons apt-regex-link-reference
         '((1 apt-link-face t)
           (2 apt-reference-face t)))
   (cons apt-regex-reference-definition
         '((1 apt-reference-face t)
           (2 apt-url-face t)
           (3 apt-link-face t)))
   (cons apt-regex-bold '(2 apt-bold-face))
   (cons apt-regex-italic '(2 apt-italic-face))
   (cons apt-regex-blockquote apt-blockquote-face)
   (cons apt-regex-wiki-link apt-link-face)
   (cons apt-regex-uri apt-link-face)
   (cons apt-regex-email apt-link-face))
  "Syntax highlighting for Apt files.")


;; Includes additional Latex/itex/Instiki font lock keywords
(defconst apt-mode-font-lock-keywords-itex
  (append
    (list
     ;; itex math mode $..$ or $$..$$
     (cons apt-regex-latex-expression '(2 apt-math-face))
     ;; Display mode equations with brackets: \[ \]
     (cons apt-regex-latex-display apt-math-face)
     ;; Equation reference (eq:foo)
     (cons "(eq:\\w+)" apt-reference-face)
     ;; Equation reference \eqref
     (cons "\\\\eqref{\\w+}" apt-reference-face))
    apt-mode-font-lock-keywords-basic)
  "Syntax highlighting for Apt, itex, and wiki expressions.")


(defvar apt-mode-font-lock-keywords
  (if apt-enable-itex 
      apt-mode-font-lock-keywords-itex
    apt-mode-font-lock-keywords-basic)
  "Default highlighting expressions for Apt mode")



;;; Syntax Table ==============================================================

(defvar apt-mode-syntax-table
  (let ((apt-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?\" "w" apt-mode-syntax-table)
    apt-mode-syntax-table)
  "Syntax table for apt-mode")



;;; Element Insertion =========================================================

(defun apt-wrap-or-insert (s1 s2)
 "Insert the strings S1 and S2.
If Transient Mark mode is on and a region is active, wrap the strings S1
and S2 around the region."
 (if (and transient-mark-mode mark-active)
     (let ((a (region-beginning)) (b (region-end)))
       (goto-char a)
       (insert s1)
       (goto-char (+ b (length s1)))
       (insert s2))
   (insert s1 s2)))

(defun apt-insert-hr ()
  "Inserts a horizonal rule."
  (interactive)
  (let (hr)
    (dotimes (count (- apt-hr-length 1) hr)        ; Count to n - 1
      (setq hr (concat "* " hr)))                       ; Build HR string
    (setq hr (concat hr "*\n"))                         ; Add the n-th *
    (insert hr)))

(defun apt-insert-bold ()
  "Inserts markup for a bold word or phrase.
If Transient Mark mode is on and a region is active, it is made bold."
  (interactive)
  (if apt-bold-underscore
      (apt-wrap-or-insert "__" "__")
    (apt-wrap-or-insert "**" "**"))
  (backward-char 2))

(defun apt-insert-italic ()
  "Inserts markup for an italic word or phrase.
If Transient Mark mode is on and a region is active, it is made italic."
  (interactive)
  (if apt-italic-underscore
      (apt-wrap-or-insert "_" "_")
    (apt-wrap-or-insert "*" "*"))
  (backward-char 1))

(defun apt-insert-code ()
  "Inserts markup for an inline code fragment.
If Transient Mark mode is on and a region is active, it is marked
as inline code."
  (interactive)
  (apt-wrap-or-insert "`" "`")
  (backward-char 1))

(defun apt-insert-link ()
  "Inserts an inline link of the form []().
If Transient Mark mode is on and a region is active, it is used
as the link text."
  (interactive)
  (apt-wrap-or-insert "[" "]")
  (insert "()")
  (backward-char 1))

(defun apt-insert-wiki-link ()
  "Inserts a wiki link of the form [[WikiLink]].
If Transient Mark mode is on and a region is active, it is used
as the link text."
  (interactive)
  (apt-wrap-or-insert "[[" "]]")
  (backward-char 2))

(defun apt-insert-image ()
  "Inserts an inline image tag of the form ![]().
If Transient Mark mode is on and a region is active, it is used
as the alt text of the image."
  (interactive)
  (apt-wrap-or-insert "![" "]")
  (insert "()")
  (backward-char 1))

(defun apt-insert-header-1 ()
  "Inserts a first level atx-style (hash mark) header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (apt-insert-header 1))

(defun apt-insert-header-2 ()
  "Inserts a second level atx-style (hash mark) header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (apt-insert-header 2))

(defun apt-insert-header-3 ()
  "Inserts a third level atx-style (hash mark) header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (apt-insert-header 3))

(defun apt-insert-header-4 ()
  "Inserts a fourth level atx-style (hash mark) header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (apt-insert-header 4))

(defun apt-insert-header-5 ()
  "Inserts a fifth level atx-style (hash mark) header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (apt-insert-header 5))

(defun apt-insert-header (n)
  "Inserts an atx-style (hash mark) header.
With no prefix argument, insert a level-1 header.  With prefix N,
insert a level-N header.  If Transient Mark mode is on and the
region is active, it is used as the header text."
  (interactive "p")
  (unless n                             ; Test to see if n is defined
    (setq n 1))                         ; Default to level 1 header
  (let (hdr)
    (dotimes (count n hdr)
      (setq hdr (concat "#" hdr)))      ; Build a hash mark header string
    (setq hdrl (concat hdr " "))
    (setq hdrr (concat " " hdr))
    (apt-wrap-or-insert hdrl hdrr))
  (backward-char (+ 1 n)))

(defun apt-insert-title ()
  "Insert a setext-style (underline) first level header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (if (and transient-mark-mode mark-active)
      (let ((a (region-beginning))
            (b (region-end))
            (len 0)
            (hdr))
        (setq len (- b a))
        (dotimes (count len hdr)
          (setq hdr (concat "=" hdr)))  ; Build a === title underline
        (end-of-line)
        (insert "\n" hdr "\n"))
    (insert "\n==========\n")
    (backward-char 12)))

(defun apt-insert-section ()
  "Insert a setext-style (underline) second level header.
If Transient Mark mode is on and a region is active, it is used
as the header text."
  (interactive)
  (if (and transient-mark-mode mark-active)
      (let ((a (region-beginning))
            (b (region-end))
            (len 0)
            (hdr))
        (setq len (- b a))
        (dotimes (count len hdr)
          (setq hdr (concat "-" hdr)))  ; Build a --- section underline
        (end-of-line)
        (insert "\n" hdr "\n"))
    (insert "\n----------\n")
    (backward-char 12)))

(defun apt-insert-blockquote ()
  "Start a blockquote section (or blockquote the region).
If Transient Mark mode is on and a region is active, it is used as
the blockquote text."
  (interactive)
  (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
      (apt-blockquote-region)
    (insert "> ")))

(defun apt-blockquote-region (beg end &optional arg)
  "Blockquote the region."
  (interactive "*r\nP")
  (if mark-active
      (perform-replace "^" "> " nil 1 nil nil nil beg end)))

(defun apt-insert-pre ()
  "Start a preformatted section (or apply to the region).
If Transient Mark mode is on and a region is active, it is marked
as preformatted text."
  (interactive)
  (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
      (apt-pre-region)
    (insert "    ")))

(defun apt-pre-region (beg end &optional arg)
  "Format the region as preformatted text."
  (interactive "*r\nP")
  (if mark-active
      (perform-replace "^" "    " nil 1 nil nil nil beg end)))




;;; Keymap ====================================================================

(defvar apt-mode-map
  (let ((apt-mode-map (make-keymap)))
    ;; Element insertion
    (define-key apt-mode-map "\C-c\C-al" 'apt-insert-link)
    (define-key apt-mode-map "\C-c\C-aw" 'apt-insert-wiki-link)
    (define-key apt-mode-map "\C-c\C-ii" 'apt-insert-image)
    (define-key apt-mode-map "\C-c\C-t1" 'apt-insert-header-1)
    (define-key apt-mode-map "\C-c\C-t2" 'apt-insert-header-2)
    (define-key apt-mode-map "\C-c\C-t3" 'apt-insert-header-3)
    (define-key apt-mode-map "\C-c\C-t4" 'apt-insert-header-4)
    (define-key apt-mode-map "\C-c\C-t5" 'apt-insert-header-5)
    (define-key apt-mode-map "\C-c\C-pb" 'apt-insert-bold)
    (define-key apt-mode-map "\C-c\C-ss" 'apt-insert-bold)
    (define-key apt-mode-map "\C-c\C-pi" 'apt-insert-italic)
    (define-key apt-mode-map "\C-c\C-se" 'apt-insert-italic)
    (define-key apt-mode-map "\C-c\C-pf" 'apt-insert-code)
    (define-key apt-mode-map "\C-c\C-sc" 'apt-insert-code)
    (define-key apt-mode-map "\C-c\C-sb" 'apt-insert-blockquote)
    (define-key apt-mode-map "\C-c\C-s\C-b" 'apt-blockquote-region)
    (define-key apt-mode-map "\C-c\C-sp" 'apt-insert-pre)
    (define-key apt-mode-map "\C-c\C-s\C-p" 'apt-pre-region)
    (define-key apt-mode-map "\C-c-" 'apt-insert-hr)
    (define-key apt-mode-map "\C-c\C-tt" 'apt-insert-title)
    (define-key apt-mode-map "\C-c\C-ts" 'apt-insert-section)
    ;; Visibility cycling
    (define-key apt-mode-map (kbd "<tab>") 'apt-cycle)
    (define-key apt-mode-map (kbd "<S-iso-lefttab>") 'apt-shifttab)
    ;; Apt functions
    (define-key apt-mode-map "\C-c\C-cm" 'apt)
    (define-key apt-mode-map "\C-c\C-cp" 'apt-preview)
    ;; References
    (define-key apt-mode-map "\C-c\C-cc" 'apt-check-refs)
    apt-mode-map)
  "Keymap for Apt major mode")

;;; Menu ==================================================================

(easy-menu-define apt-mode-menu apt-mode-map
  "Menu for Apt mode"
  '("Apt"
    ("Show/Hide"
     ["Cycle visibility" apt-cycle (outline-on-heading-p)]
     ["Cycle global visibility" apt-shifttab])
    "---"
    ["Compile" apt]
    ["Preview" apt-preview]
    "---"
    ("Headers (setext)"
     ["Insert Title" apt-insert-title]
     ["Insert Section" apt-insert-section])
    ("Headers (atx)"
     ["First level" apt-insert-header-1]
     ["Second level" apt-insert-header-2]
     ["Third level" apt-insert-header-3]
     ["Fourth level" apt-insert-header-4]
     ["Fifth level" apt-insert-header-5])
    "---"
    ["Bold" apt-insert-bold]
    ["Italic" apt-insert-italic]
    ["Blockquote" apt-insert-blockquote]
    ["Preformatted" apt-insert-pre]
    ["Code" apt-insert-code]
    "---"
    ["Insert inline link" apt-insert-link]
    ["Insert image" apt-insert-image]
    ["Insert horizontal rule" apt-insert-hr]
    "---"
    ["Check references" apt-check-refs]
    "---"
    ["Version" apt-show-version]
    ))



;;; References ================================================================

;;; Undefined reference checking code by Dmitry Dzhus <mail@sphinx.net.ru>.

(defconst apt-refcheck-buffer
  "*Undefined references for %BUFFER%*"
  "Name of buffer which will contain a list of undefined
references in `apt-mode' buffer named %BUFFER%.")

(defun apt-has-reference-definition (reference)
    "Find out whether Apt REFERENCE is defined.

REFERENCE should include the square brackets, like [this]."
    (let ((reference (downcase reference)))
      (save-excursion
        (goto-char (point-min))
        (catch 'found
          (while (re-search-forward apt-regex-reference-definition nil t)
            (when (string= reference (downcase (match-string-no-properties 1)))
              (throw 'found t)))))))

(defun apt-get-undefined-refs ()
  "Return a list of undefined Apt references.

Result is an alist of pairs (reference . occurencies), where
occurencies is itself another alist of pairs (label .
line-number).

For example, an alist corresponding to [Nice editor][Emacs] at line 12,
\[GNU Emacs][Emacs] at line 45 and [manual][elisp] at line 127 is
\((\"[emacs]\" (\"[Nice editor]\" . 12) (\"[GNU Emacs]\" . 45)) (\"[elisp]\" (\"[manual]\" . 127)))."
  (let ((missing))
    (save-excursion
      (goto-char (point-min))
      (while
          (re-search-forward apt-regex-link-reference nil t)
        (let* ((label (match-string-no-properties 1))
               (reference (match-string-no-properties 2))
               (target (downcase (if (string= reference "[]") label reference))))
          (unless (apt-has-reference-definition target)
            (let ((entry (assoc target missing)))
              (if (not entry)
                  (add-to-list 'missing (cons target
                                              (list (cons label (apt-line-number-at-pos)))) t)
                (setcdr entry
                        (append (cdr entry) (list (cons label (apt-line-number-at-pos))))))))))
      missing)))

(defun apt-add-missing-ref-definition (ref buffer &optional recheck)
  "Add blank REF definition to the end of BUFFER.

REF is a Apt reference in square brackets, like \"[lisp-history]\".

When RECHECK is non-nil, BUFFER gets rechecked for undefined
references so that REF disappears from the list of those links."
  (with-current-buffer buffer
      (when (not (eq major-mode 'apt-mode))
        (error "Not available in current mdoe"))
      (goto-char (point-max))
      (indent-new-comment-line)
      (insert (concat ref ": ")))
  (switch-to-buffer-other-window buffer)
  (goto-char (point-max))
  (when recheck
    (apt-check-refs t)))

;; Button which adds an empty Apt reference definition to the end
;; of buffer specified as its 'target-buffer property. Reference name
;; is button's label
(when (>= emacs-major-version 22)
  (define-button-type 'apt-ref-button
    'help-echo "Push to create an empty reference definition"
    'face 'bold
    'action (lambda (b)
              (apt-add-missing-ref-definition
               (button-label b) (button-get b 'target-buffer) t))))

;; Button jumping to line in buffer specified as its 'target-buffer
;; property. Line number is button's 'line property.
(when (>= emacs-major-version 22)
  (define-button-type 'goto-line-button
    'help-echo "Push to go to this line"
    'face 'italic
    'action (lambda (b)
              (message (button-get b 'buffer))
              (switch-to-buffer-other-window (button-get b 'target-buffer))
              (goto-line (button-get b 'target-line)))))

(defun apt-check-refs (&optional silent)
  "Show all undefined Apt references in current `apt-mode' buffer.

If SILENT is non-nil, do not message anything when no undefined
references found.

Links which have empty reference definitions are considered to be
defined."
  (interactive "P")
  (when (not (eq major-mode 'apt-mode))
    (error "Not available in current mode"))
  (let ((oldbuf (current-buffer))
        (refs (apt-get-undefined-refs))
        (refbuf (get-buffer-create (replace-regexp-in-string
                                 "%BUFFER%" (buffer-name)
                                 apt-refcheck-buffer t))))
    (if (null refs)
        (progn
          (when (not silent)
            (message "No undefined references found"))
          (kill-buffer refbuf))
      (with-current-buffer refbuf
        (when view-mode
          (View-exit-and-edit))
        (erase-buffer)
        (insert "Following references lack definitions:")
        (newline 2)
        (dolist (ref refs)
          (let ((button-label (format "%s" (car ref))))
            (if (>= emacs-major-version 22)
                ;; Create a reference button in Emacs 22
                (insert-text-button button-label
                                    :type 'apt-ref-button
                                    'target-buffer oldbuf)
              ;; Insert reference as text in Emacs < 22
              (insert button-label)))
          (insert " (")
          (dolist (occurency (cdr ref))
            (let ((line (cdr occurency)))
              (if (>= emacs-major-version 22)
                  ;; Create a line number button in Emacs 22
                  (insert-button (number-to-string line)
                                 :type 'goto-line-button
                                 'target-buffer oldbuf
                                 'target-line line)
                ;; Insert line number as text in Emacs < 22
                (insert (number-to-string line)))
              (insert " "))) (delete-backward-char 1)
          (insert ")")
          (newline))
        (view-buffer-other-window refbuf)
        (goto-line 4)))))


;;; Outline ===================================================================

;; The following visibility cycling code was taken from org-mode
;; by Carsten Dominik and adapted for apt-mode.

(defvar apt-cycle-global-status 1)
(defvar apt-cycle-subtree-status nil)

;; Based on org-end-of-subtree from org.el
(defun apt-end-of-subtree (&optional invisible-OK)
  ;; This is an exact copy of the original function, but it uses
  ;; `outline-back-to-heading', to make it work also in invisible
  ;; trees.  And is uses an invisible-OK argument.
  ;; Under Emacs this is not needed, but the old outline.el needs this fix.
  (outline-back-to-heading invisible-OK)
  (let ((first t)
        (level (funcall outline-level)))
    (while (and (not (eobp))
                (or first (> (funcall outline-level) level)))
      (setq first nil)
      (outline-next-heading))
    (if (memq (preceding-char) '(?\n ?\^M))
        (progn
          ;; Go to end of line before heading
          (forward-char -1)
          (if (memq (preceding-char) '(?\n ?\^M))
              ;; leave blank line before heading
              (forward-char -1)))))
  (point))

;; Based on org-cycle from org.el.
(defun apt-cycle (&optional arg)
  "Visibility cycling for Apt mode."
  (interactive "P")
  (cond
     ((eq arg t) ;; Global cycling
      (cond
       ((and (eq last-command this-command)
             (eq apt-cycle-global-status 2))
        ;; Move from overview to contents
        (hide-sublevels 1)
        (message "CONTENTS")
        (setq apt-cycle-global-status 3))

       ((and (eq last-command this-command)
             (eq apt-cycle-global-status 3))
        ;; Move from contents to all
        (show-all)
        (message "SHOW ALL")
        (setq apt-cycle-global-status 1))

       (t
        ;; Defaults to overview
        (hide-body)
        (message "OVERVIEW")
        (setq apt-cycle-global-status 2))))

     ((save-excursion (beginning-of-line 1) (looking-at outline-regexp))
      ;; At a heading: rotate between three different views
      (outline-back-to-heading)
      (let ((goal-column 0) eoh eol eos)
        ;; Determine boundaries
        (save-excursion
          (outline-back-to-heading)
          (save-excursion
            (beginning-of-line 2)
            (while (and (not (eobp)) ;; this is like `next-line'
                        (get-char-property (1- (point)) 'invisible))
              (beginning-of-line 2)) (setq eol (point)))
          (outline-end-of-heading)   (setq eoh (point))
          (apt-end-of-subtree t)
          (skip-chars-forward " \t\n")
          (beginning-of-line 1) ; in case this is an item
          (setq eos (1- (point))))
        ;; Find out what to do next and set `this-command'
      (cond
         ((= eos eoh)
          ;; Nothing is hidden behind this heading
          (message "EMPTY ENTRY")
          (setq apt-cycle-subtree-status nil))
         ((>= eol eos)
          ;; Entire subtree is hidden in one line: open it
          (show-entry)
          (show-children)
          (message "CHILDREN")
          (setq apt-cycle-subtree-status 'children))
         ((and (eq last-command this-command)
               (eq apt-cycle-subtree-status 'children))
          ;; We just showed the children, now show everything.
          (show-subtree)
          (message "SUBTREE")
          (setq apt-cycle-subtree-status 'subtree))
         (t
          ;; Default action: hide the subtree.
          (hide-subtree)
          (message "FOLDED")
          (setq apt-cycle-subtree-status 'folded)))))

     (t
      (message "TAB")
      (indent-relative))))

;; Based on org-shifttab from org.el.
(defun apt-shifttab (&optional arg)
  "Global visibility cycling or move to previous table field.
Calls `apt-cycle' with argument t"
  (interactive "P")
  (apt-cycle t))

;;; Commands ==================================================================

(defun apt ()
  "Run apt on the current buffer and preview the output in another buffer."
  (interactive)
    (if (and (boundp 'transient-mark-mode) transient-mark-mode mark-active)
        (shell-command-on-region (region-beginning) (region-end) apt-command
                                 "*apt-output*" nil)
      (shell-command-on-region (point-min) (point-max) apt-command
                               "*apt-output*" nil)))

(defun apt-preview ()
  "Run apt on the current buffer and preview the output in a browser."
  (interactive)
  (apt)
  (browse-url-of-buffer "*apt-output*"))


;;; Miscellaneous =============================================================

(defun apt-line-number-at-pos (&optional pos)
  "Return (narrowed) buffer line number at position POS.
If POS is nil, use current buffer location.
This is an exact copy of line-number-at-pos for use in emacs21."
  (let ((opoint (or pos (point))) start)
    (save-excursion
      (goto-char (point-min))
      (setq start (point))
      (goto-char opoint)
      (forward-line 0)
      (1+ (count-lines start (point))))))



;;; Mode definition  ==========================================================

(defun apt-show-version ()
  "Show the version number in the minibuffer."
  (interactive)
  (message "apt-mode, version %s" apt-mode-version))

(define-derived-mode apt-mode text-mode "Apt"
  "Major mode for editing Apt files."
  ;; Font lock.
  (set (make-local-variable 'font-lock-defaults)
       '(apt-mode-font-lock-keywords))
  (set (make-local-variable 'font-lock-multiline) t)
  ;; For menu support in XEmacs
  (easy-menu-add apt-mode-menu apt-mode-map)
  ;; Outline mode
  (make-local-variable 'outline-regexp)
  (setq outline-regexp "#+")
  ;; Cause use of ellipses for invisible text.
  (add-to-invisibility-spec '(outline . t)))

;(add-to-list 'auto-mode-alist '("\\.apt$" . apt-mode))

(provide 'apt-mode)

;;; apt-mode.el ends here
