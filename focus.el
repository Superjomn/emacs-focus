(require 'widget)
(require 'dash)
(eval-when-compile
  (require 'wid-edit)
  (require 'cl-lib))

(defvar widget-example-repeat)
(defconst chun/focus-add-new-buffer "*chun focus*")
(defconst chun/focus-list-buffer "*chun list*")

(defvar chun/focus-added-widgets '())
(defvar chun/focus-add-new-group)
(defvar chun/focus-item-properties '())

(defun chun/focus-new-item-window()
  "Create teh widgets from the Widget manual."
  (interactive)
  (switch-to-buffer chun/focus-add-new-buffer)
  (kill-all-local-variables)
  (make-local-variable 'widget-example-repeat)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (chun/style-and-insert-text "Plan" 2)
  (chun/add-new-widget 'editable-field
                       :size 20
                       :format "Item : %v\n\n")
  (chun/add-new-widget 'editable-field
                       :size 50
                       :format "Note : %v\n\n"
                       :notify (lambda (widget &rest ignore)
                                 (chun/focus-update-property 'note (widget-value widget))))
  (chun/add-new-widget 'editable-field
                       :size 10
                       :format "Defer: %v\n\n"
                       :notify (lambda (widget &rest ignore)
                                 (chun/focus-update-property 'defer (widget-value widget))))
  (chun/add-new-widget 'editable-field
                       :size 10
                       :format "Due  : %v\n\n"
                       :notify (lambda (widget &rest ignore)
                                 (chun/focus-update-property 'due (widget-value widget))))
  (chun/add-new-widget 'toggle
                       :format "Flag : %v\n\n"
                       :notify (lambda (widget &rest ignore)
                                 (chun/focus-update-property 'flag (widget-value widget))
                                 (message "checkbox checked! %s" (widget-value widget))) nil)
  (chun/add-new-widget 'editable-field
                       :format "Tags : %v\n\n"
                       :size 40
                       :notify (lambda (widget &rest ignore)
                                 (chun/focus-update-property 'tags (widget-value widget))))
  (widget-create 'push-button
                 :notify (lambda
                           (&rest
                            ignore)
                           ;; get the content of all the widget
                           (message "button saved")
                           (message "type: %s" (type-of chun/focus-added-widgets))
                           (message "size: %d" (length chun/focus-added-widgets))
                           (message "global plist %s" chun/focus-item-properties)
                           ) "Save")
  (use-local-map widget-keymap)
  (widget-setup))

(defun chun/focus-list ()
  "list the current org"
  )

;; helper functions about GUI
(defun chun/style-and-insert-text (text &optional end-line)
  "style and insert the text into the widget."
  (or end-line
      (setq end-line 1)) ;; default argument
  (widget-insert text)
  (add-text-properties (line-beginning-position)
                       (line-end-position)
                       '(face bold))
  (cl-loop for i from 1 to end-line do (widget-insert "\n")))

(defun chun/add-new-widget
    (&rest
     args)
  (setq chun/focus-added-widgets (cons 'chun/focus-added-widgets (apply #'widget-create args))))

(defun chun/focus-update-property (key value)
  (setq chun/focus-item-properties (plist-put chun/focus-item-properties key value)))
