(require 'widget)
(require 'dash)
(eval-when-compile
  (require 'wid-edit)
  (require 'cl-lib)
  )

(defvar widget-example-repeat)
(defconst chun/focus-add-new-buffer "*chun focus*")
(defconst chun/focus-list-buffer "*chun list*")

(defun chun/style-and-insert-text (text &optional end-line)
  "style and insert the text into the widget."
  (or end-line (setq end-line 1)) ;; default argument
  (widget-insert text)
  (add-text-properties
   (line-beginning-position) (line-end-position)
   '(face bold))

  (cl-loop
   for i from 1 to end-line
   do (widget-insert "\n")))

(defun chun/add-new-widget (&rest args)
  (setq chun/focus-added-widgets
        (cons 'chun/focus-added-widgets
              (apply #'widget-create args))))

(defvar chun/focus-added-widgets '())
(defvar chun/focus-add-new-group)

(defun widget-example()
  "Create teh widgets from the Widget manual."
  (interactive)
  (switch-to-buffer chun/focus-add-new-buffer)
  (kill-all-local-variables)
  (make-local-variable 'widget-example-repeat)
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)

  (chun/style-and-insert-text "Plan" 2)

  (setq chun/focus-add-new-group
        (widget-create 'group
                       :offset 20
                       ))

  (chun/add-new-widget
   'editable-field
   :size 20
   :parent 'chun/focus-add-new-group
   :format "Item : %v\n\n")

  (chun/add-new-widget 'editable-field
                 :size 50
                 :format "Note : %v\n\n")

  (chun/add-new-widget 'editable-field
                 :size 50
                 :format "Note : %v\n\n")

  (chun/add-new-widget 'editable-field
                 :size 10
                 :format "Defer: %v\n\n"
                 )
  (chun/add-new-widget 'editable-field
                 :size 10
                 :format "Due  : %v\n\n"
                 )


  (chun/add-new-widget 'toggle
                 :format "Flaged: %v\n\n"
                 :notify (lambda (widget &rest ignore)
                           (message "checkbox checked! %s" (widget-value widget)))
                 nil)
  (chun/add-new-widget 'editable-field
                 :format "Tags: %v\n\n"
                 :size 40
                 )

  (widget-create 'push-button
                       :notify (lambda (&rest ignore)
                                 ;; get the content of all the widget
                                 (message "button saved")
                                 (message "type: %s" (type-of chun/focus-added-widgets))
                                 (message "size: %d" (length chun/focus-added-widgets))
                                 (-map (lambda (widget) (message "content %s" (type-of widget)))
                                       chun/focus-added-widgets))
                       "Save")

  (use-local-map widget-keymap)
  (widget-setup))
