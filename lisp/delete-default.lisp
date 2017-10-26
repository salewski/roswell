(roswell:include "list-installed")
(defpackage :roswell.delete.default
  (:use :cl :roswell.util))
(in-package :roswell.delete.default)

(defun default (&rest argv)
  (if (null argv)
      (progn
        (format *error-output* "Usage: ros delete dump [IMAGES...]~%")
        (format *error-output* "Usage: ros delete [IMPLS...]~2%")
        (format *error-output* "Possible subcommands:~%")
        (finish-output *error-output*)
        (format t "dump~%")
        (finish-output)
        (format *error-output* "~%Possible candidates of installed impls for deletion:~2%")
        (finish-output *error-output*)
        (let ((*error-output* (make-broadcast-stream)))
          (roswell.list.installed:installed)))
      (let* ((default (config "default.lisp"))
             (verstring (format nil "~A.version" default))
             (config (format nil "~A/~A" default (config verstring)))
             (impl-name (first argv))
             (path (merge-pathnames (format nil "impls/~A/~A/~A/"
                                            (uname-m) (uname) impl-name)
                                    (homedir))))
        (unless (position :up (pathname-directory path))
          (cond ((probe-file path)
                 (uiop/filesystem:delete-directory-tree path :validate t)
                 (format t "~&~A was deleted successfully.~%" impl-name)
                 (when (equal impl-name config)
                   (format t "~&clear config ~S~%" verstring)
                   (setf (config verstring) "")))
                (t (format *error-output* "~&~A is not installed.~%" impl-name)))))))