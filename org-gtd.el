;;; org-gtd.el --- An implementation of GTD -*- lexical-binding: t; -*-

;; Copyright (C) 2019-2021 Aldric Giacomoni

;; Author: Aldric Giacomoni <trevoke@gmail.com>
;; Version: 1.1.1
;; Homepage: https://github.com/Trevoke/org-gtd.el
;; Package-Requires: ((emacs "26.1") (org-edna "1.1.2") (f "0.20.0") (org "9.3.1") (org-agenda-property "1.3.1"))

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package tries to replicate as closely as possible the GTD workflow.
;; This package assumes familiarity with GTD.
;;
;; Upgrading? make sure you read the CHANGELOG.
;;
;; This package provides a system that allows you to capture incoming things
;; into an inbox, then process the inbox and categorize each item based on the
;; GTD categories.  It leverages org-agenda to show today's items as well as the
;; NEXT items.  It also has a simple project management system, which currently
;; assumes all tasks in a project are sequential.
;;
;; For a comprehensive instruction manual, see the file `README.org'.
;;
;;; Code:

;;;; Requirements

(require 'subr-x)
(require 'cl-lib)
(require 'f)
(require 'org)
(require 'org-element)
(require 'org-agenda-property)
(require 'org-edna)

(defconst org-gtd-inbox "inbox")
(defconst org-gtd-incubated "incubated")
(defconst org-gtd-projects "projects")
(defconst org-gtd-actions "actions")
(defconst org-gtd-delegated "delegated")
(defconst org-gtd-scheduled "scheduled")

(defconst org-gtd--refile-properties
  (let ((myhash (make-hash-table :test 'equal)))
    (puthash org-gtd-actions "Action" myhash)
    (puthash org-gtd-incubated "Incubated" myhash)
    (puthash org-gtd-delegated "Delegated" myhash)
    (puthash org-gtd-projects "Projects" myhash)
    (puthash org-gtd-scheduled "Scheduled" myhash)
    myhash))

(defconst org-gtd-actions-definition
  "+LEVEL=1+ORG_GTD=\"Action\""
  "How to identify single actions in the GTD system.")

(defconst org-gtd-incubated-definition
  "+LEVEL=1+ORG_GTD=\"Incubated\""
  "How to identify incubated items in the GTD system.")

(defconst org-gtd-delegated-definition
  "+LEVEL=1+ORG_GTD=\"Delegated\""
  "How to identify delegated items in the GTD system.")

(defconst org-gtd-scheduled-definition
  "+LEVEL=1+ORG_GTD=\"Scheduled\""
  "How to identify scheduled items in the GTD system.")

(defconst org-gtd-projects-definition
  "+LEVEL=2+ORG_GTD=\"Projects\""
  "How to identify projects in the GTD system.")

(require 'org-gtd-archive)
(require 'org-gtd-files)
(require 'org-gtd-refile)
(require 'org-gtd-customize)
(require 'org-gtd-projects)
(require 'org-gtd-agenda)
(require 'org-gtd-inbox-processing)


(defun org-gtd-capture (&optional goto keys)
  "Capture something into the GTD inbox.

Wraps the function `org-capture' to ensure the inbox exists.

For GOTO and KEYS, see `org-capture' documentation for the variables of the same name."
  (interactive)
  (kill-buffer (org-gtd--inbox-file))
  (org-capture goto keys))

(provide 'org-gtd)

;;; org-gtd.el ends here
