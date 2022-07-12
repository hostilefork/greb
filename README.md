## **greb** - A Ren-C UPARSE-based Replacement for `grep`

The goal of this project is to expose the literate pattern matching facitilies
of UPARSE through a simple command line tool.  (Idea from Petr Krenzelok (@pekr))

    ls | greb 'some alpha ".reb"'

Because UPARSE is an extremely slow prototype of reinventing Rebol2 PARSE, the
utility will be slow for the near term.  But it's intended as more of a test
and demo, to generate discussion about the mechanisms involved in writing a
short piping-based utility in Ren-C.
