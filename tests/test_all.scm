;
; Copyright (C) 2024 The Goldfish Scheme Authors
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
; http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
; WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
; License for the specific language governing permissions and limitations
; under the License.
;

(import (liii list)
        (liii string)
        (liii os)
        (liii path))

(define (listdir2 dir)
  ((box (vector->list (listdir dir)))
   :map (lambda (x) (string-append dir "/" x))
   :collect))

(display (listdir2 "tests/goldfish"))

(define (all-tests)
  ((box (listdir2 "tests/goldfish"))
   :filter path-dir?
   :flat-map listdir2
   :filter (lambda (x) (path-file? x))
   :filter (lambda (x) (not (string-ends? x "srfi-78-test.scm")))))

(define (goldfish-cmd)
  (if (os-windows?)
    "bin\\goldfish "
    "bin/goldfish "))

(let1 ret-l ((all-tests)
             :map (lambda (x) (string-append (goldfish-cmd) x))
             :map (lambda (x)
                    (newline)
                    (display "----------->") (newline)
                    (display x) (newline)
                    (os-call x)))
  (when (ret-l :exists (compose not zero?))
    (exit -1)))

