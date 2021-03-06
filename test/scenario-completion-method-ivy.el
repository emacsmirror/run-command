(load-file "setup.el")

(director-run
 :version 1
 :before-start
 (lambda ()
   (require 'ivy)
   (require 'run-command)
   (ivy-mode 1)
   (add-to-list 'run-command-recipes 'run-command-recipe-example))
 :steps
 '((:call run-command)
   (:assert (length= (window-list) 2))
   (:type "say")
   (:type [return])
   (:assert (let ((window-1-buffer (window-buffer (nth 1 (window-list)))))
              (with-current-buffer window-1-buffer
                (and (string-match "^say-hello" (buffer-name))
                     (re-search-forward "Hello, world!" nil t))))))
 :log-target '(file . "director.log")
 :delay-between-steps 0.01
 :on-error (lambda () (kill-emacs 1))
 :on-failure (lambda () (kill-emacs 1))
 :after-end (lambda () (kill-emacs)))
