Rebol [
    title: "Rebol-based `grep` Program: use PARSE to process lines"
    file: %greb.r

    description: --[
        This program is based on the idea of a simple alternative to the UNIX
        utility called grep, which uses Regular Expressions to search lines in
        files.
    ]--

    usage: --[
        The most convenient way to use greb is to make it a shell alias:

            ~/home$ alias greb="r3 %/path/to/greb.r"

        Its typical use would be with piping.  So from bash, you might pipe the
        output of the `ls` command into greb.

            ~/home$ ls | greb 'some alpha ".reb"'

        The rule is implicitly wrapped in a BLOCK!, so outermost brackets are
        not required.
    ]--

    license: --[
        Licensed under the Lesser GPL, Version 3.0 (the "License");
        you may not use this file except in compliance with the License.
        You may obtain a copy of the License at
        https://www.gnu.org/licenses/lgpl-3.0.html
    ]--
]


=== MAKE PREDEFINED RULES ===

; !!! Over the years there have been many attempts to push for standardizing
; some of these sets vs. forcing users to define them in each program, but:
;
;   * There's no universal agreement on what should be included or how
;     the names should be (hexdigit or hex-digit, or alpha vs. letter),
;     and there's a lot of language bias which makes a true definition seem
;     too verbose (English.letter, Spanish.letter) etc.
;
;   * The more useful character sets that would be difficult for people
;     to define themself without consulting a specification tend to involve
;     Unicode characters, and bitsets in R3-Alpha are not "sparse" so they
;     will use significant memory when higher codepoints are covered.
;
;  * It's relatively easy to define exactly the characters you want under
;    the name you want (possibly abbreviated) compared to other languages.
;
; So the status quo has been to just have people paste in the definitions they
; need to each program they write.  A utility like `greb` is a case where you
; really do need to pin down some answers to these questions.

predefined: make object! [
    digit: charset [#"0" - #"9"]
    alpha: charset [#"a" - #"z" #"A" - #"Z"]
]


=== PROCESS COMMAND LINE ARGUMENTS ===

; Note: This is being done second instead of first for didactic purposes, e.g.
; to mention that the result of LOAD does not see definitions in this file.

if not ruletext: match text! first system.options.args [
    fail ["First argument to greb must be a parse rule"]
]

rule: transcode ruletext  ; always gives back a BLOCK!


=== MAKE HELPER DEFINITIONS VISIBLE TO PARSE CODE IN RULE ===

; !!! Binding is a tremendous dark cloud in Rebol, and notably the LOAD command
; only binds code into the LIB context by default.  This means that when we
; did the LOAD RULETEXT operation, the resulting RULE won't be able to see
; `character-classes` to access `character-classes.alpha`.  (So even if the
; alpha and digit were in module scope, it couldn't access them unqualified
; as just `alpha` or `digit`)
;
; What something is bound to is tremendously important to its function.  But
; historical Rebol played fast-and-loose with the property, with many routines
; invisibly affecting the binding of code passed to them.  Ren-C tries out some
; alternative methods of "virtualizing" binding, but these are really just
; experiments that are throwing more ideas into a somewhat muddled pool.
;
; We could arguably try and add the bindings of HELPERS to RULE.  But there's
; a limitation of that method, because bindings only broadcast down a block's
; structure...once a variable reference is followed to reach other code, the
; binding is lost.  UPARSE gives a methodology for explicitly building a set
; of rules that work pervasively in the engine with a MAP! of combinators.
; So we augment that map with our helpers.

combinators: copy default-combinators
for-each [key value] predefined [
    append combinators spread reduce [key value]
]


=== INVOKE PARSE ON EACH LINE ===

while [line: read-line stdin] [
    parse:combinators line rule combinators except e -> [continue]
    print line
]
