;;; russell-mode.el --- Major mode for the Russell language -*- lexical-binding: t; -*-

;; Copyright (C) 2026
;; This file is part of the Russell 3.3 Linux port.

;;; Commentary:
;; A small programming mode for Russell source files.  Russell uses
;; (* ... *) comments, declarations closed by ni, and conditional/loop
;; constructs closed by fi/od.  The indentation is intentionally close to
;; the layout used by the examples shipped with Russell.

;;; Code:

(require 'prog-mode)

(defgroup russell nil
  "Editing Russell source files."
  :group 'languages)

(defcustom russell-indent-offset 4
  "Number of spaces used for one Russell indentation level."
  :type 'integer
  :safe #'integerp
  :group 'russell)

(defvar russell-mode-hook nil)

(defconst russell--keywords
  '("cand" "characters" "constants" "cor" "do" "else" "elsif" "enum"
    "export" "extend" "extern" "fi" "field" "func" "hide" "if" "in"
    "let" "ni" "od" "prod" "record" "readonly" "signature"
    "then" "type" "union" "use" "val" "var" "with")
  "Russell language keywords.")

(defconst russell--types
  '("Array" "Bool" "ChStr" "Complex" "Float" "Long" "Null" "Short"
    "Void" "LList")
  "Common Russell and runtime type names.")

(defconst russell--font-lock-keywords
  `((,(regexp-opt russell--keywords 'symbols) . font-lock-keyword-face)
    (,(regexp-opt russell--types 'symbols) . font-lock-type-face)
    ("\\_<\\(?:True\\|False\\)\\_>" . font-lock-constant-face)
    ("\\_<\\(?:[A-Z][A-Za-z0-9_]*\\)\\_>" . font-lock-type-face)
    ("\\(?:==>\\|===\\|==\\|:=\\|<>\\|<=\\|>=\\|\\^\\*\\|\\*\\*\\|\\$\\)"
     . font-lock-function-name-face))
  "Font-lock rules for `russell-mode'.")

(defvar russell-mode-syntax-table
  (let ((table (make-syntax-table)))
    ;; Russell comments are delimited by (* and *).  The two-character
    ;; delimiters are installed by `syntax-propertize'.
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?' "\\\"" table)
    (modify-syntax-entry ?\\ "\\\\" table)
    (modify-syntax-entry ?\" "\\\"" table)
    (modify-syntax-entry ?\( "()" table)
    (modify-syntax-entry ?\) ")(" table)
    table)
  "Syntax table used while editing Russell source.")

(defconst russell--syntax-propertize-rules
  (syntax-propertize-rules
   ("\\((\\*\\)" (1 (string-to-syntax "< 1")))
   ("\\(\\*[)]\\)" (1 (string-to-syntax "> 4"))))
  "Syntax properties for Russell's two-character comment delimiters.")

(defun russell--syntax-propertize (start end)
  "Install Russell comment syntax properties between START and END."
  (goto-char start)
  (funcall russell--syntax-propertize-rules start end))

(defun russell--code-line-p ()
  "Return non-nil when point is outside a Russell comment or string."
  (not (nth 4 (syntax-ppss (line-beginning-position)))))

(defun russell--line-first-token ()
  "Return the first Russell token on the current code line, or nil."
  (save-excursion
    (back-to-indentation)
    (unless (or (looking-at "#")
                (nth 4 (syntax-ppss)))
      (when (looking-at "\\([[:alnum:]_]+\\|[{}()]\\)")
        (match-string-no-properties 1)))))

(defun russell--line-depth-change ()
  "Return the block-depth change contributed by the current line."
  (save-excursion
    (goto-char (line-beginning-position))
    (let ((end (line-end-position)) (change 0))
      (while (re-search-forward
              "\\_<\\(let\\|if\\|do\\|use\\|ni\\|fi\\|od\\)\\_>\\|[{}]"
              end t)
        (let* ((token (match-string-no-properties 0))
               (next (match-end 0))
               (in-comment (nth 4 (syntax-ppss (match-beginning 0)))))
          (unless in-comment
            (cond
             ((string= token "{") (setq change (1+ change)))
             ((string= token "}") (setq change (1- change)))
             ((member token '("ni" "fi" "od")) (setq change (1- change)))
             (t (setq change (1+ change)))))
          (goto-char next)))
      change)))

(defun russell--closing-line-p ()
  "Return non-nil if the current line starts a closing Russell block."
  (let ((token (russell--line-first-token)))
    (member token '("in" "ni" "fi" "od" "}"))))

(defun russell--alternative-line-p ()
  "Return non-nil if the current line is a Russell `#' alternative.
Preprocessor directives also begin with `#', but an alternative has an
`==>' on its line."
  (save-excursion
    (back-to-indentation)
    (looking-at "#[^\n]*==>")))

(defun russell--calculate-indentation ()
  "Calculate indentation for the current Russell line."
  (let ((target (line-beginning-position))
        (depth 0))
    (save-excursion
      (goto-char (point-min))
      (while (< (point) target)
        (unless (or (looking-at "[ \t]*$")
                    (looking-at "[ \t]*#"))
          (setq depth (+ depth (russell--line-depth-change)))
          (setq depth (max 0 depth)))
        (forward-line 1))
      (when (russell--closing-line-p)
        (setq depth (max 0 (1- depth))))
      (let ((indent (* russell-indent-offset depth)))
        ;; With the usual four-space block indent, placing `#' two spaces
        ;; before its branch expression makes all alternatives line up.
        (if (russell--alternative-line-p)
            (max 0 (- indent 2))
          indent)))))

(defun russell-indent-line ()
  "Indent the current Russell line."
  (interactive)
  (let ((indent (russell--calculate-indentation))
        (offset (- (current-column) (current-indentation))))
    (indent-line-to indent)
    (when (> offset 0)
      (move-to-column (+ indent offset)))))

;;;###autoload
(define-derived-mode russell-mode prog-mode "Russell"
  "Major mode for editing Russell source files."
  :syntax-table russell-mode-syntax-table
  (setq-local font-lock-defaults '(russell--font-lock-keywords))
  (setq-local syntax-propertize-function #'russell--syntax-propertize)
  (setq-local indent-line-function #'russell-indent-line)
  (setq-local comment-start "(*")
  (setq-local comment-end "*)")
  (setq-local comment-start-skip "(\\*+[ \t]*")
  (setq-local comment-end-skip "[ \t]*\\*+)")
  (setq-local indent-tabs-mode nil)
  (setq-local font-lock-multiline t))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.r\\'" . russell-mode))

(provide 'russell-mode)

;;; russell-mode.el ends here
