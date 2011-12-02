(setq org-babel-load-languages '((emacs-lisp . t) (latex . t)))

(require 'org)
(require 'org-id)

(defun org-dvipng-color (&rest arg) 0)
(defun face-attribute (&rest arg) 0)

(setq org-confirm-babel-evaluate nil)

(defvar hct-dir "~/hct/")
(defvar hct-publish-dir "~/public_html/hct")

(setq org-publish-project-alist
      `(("hct"
	 :components ("hct-org" "hct-extra"))
	("hct-org"
	 :base-directory ,hct-dir
	 :publishing-directory ,hct-publish-dir
	 :publishing-function org-publish-org-to-html
	 :convert-org-links org-export-html-link-org-files-as-html
	 :author "Tom Prince"
	 :email "tom.prince@ualberta.net")
	("hct-extra"
	 :base-directory ,hct-dir
	 :publishing-directory ,hct-publish-dir
	 :publishing-function org-publish-attachment
	 :base-extension "svg\\|pdf")))

(setq org-export-latex-packages-alist
      `(("" "diagrams" t)))

(defun server-eval-and-print (expr proc)
  "Eval EXPR and send the result back to client PROC."
  (with-temp-buffer
    (let ((standard-output (current-buffer)))
      (let ((v (save-excursion (eval (car (read-from-string expr))))))
	(when (and proc)
	  (when v (pp v))
	  (let ((text (buffer-substring-no-properties
			(point-min) (point-max))))
	    (server-send-string
	      proc (format "-print %s\n"
			   (server-quote-arg text)))))))))
