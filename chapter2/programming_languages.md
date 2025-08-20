Programming
===========

Programming is a key skill for any technical professional because lots 
of stuff can be automated and you're just leaving a lot of time on the table
if you don't know how it works.

The good news is that programming really has almost nothing to do with 
programming languages, per se. They are all almost identical. 

What I will try to teach you is how to think about programming in general 
and hopefully, if I succeed, you'll be comfortable picking up any language
that you want except perhaps for the really weird ones.

For data scientists in particular we just mostly glue methods together so our
programming is usually very simple. But not always!

```r file=little_scheme.scm
;; Meta-circular evaluator (simplified SICP version)

;; Entry point
(define (eval exp env)
  (cond
    ((self-evaluating? exp) exp)
    ((variable? exp) (lookup-variable-value exp env))
    ((quoted? exp) (text-of-quotation exp))
    ((assignment? exp) (eval-assignment exp env))
    ((definition? exp) (eval-definition exp env))
    ((if? exp) (eval-if exp env))
    ((lambda? exp) (make-procedure (lambda-parameters exp)
                                   (lambda-body exp)
                                   env))
    ((begin? exp) (eval-sequence (begin-actions exp) env))
    ((cond? exp) (eval (cond->if exp) env))
    ((application? exp)
     (apply (eval (operator exp) env)
            (list-of-values (operands exp) env)))
    (else (error "Unknown expression type -- EVAL" exp))))

(define (apply procedure arguments)
  (cond
    ((primitive-procedure? procedure)
     (apply-primitive-procedure procedure arguments))
    ((compound-procedure? procedure)
     (eval-sequence
       (procedure-body procedure)
       (extend-environment
         (procedure-parameters procedure)
         arguments
         (procedure-environment procedure))))
    (else (error "Unknown procedure type -- APPLY" procedure))))

;; Helpers for evaluation
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)

```
Its kind of hard to state how simple programming languages are, really, but above is a little dumb trick called the scheme meta-circular evaluator.
It is a full programming language defined in a handful of lines of code. Really,
once you get this idea, most other dynamically typed programming languages are
just "sugar" on top of these ideas.

Now to the "data" part of ::data_science:data science::