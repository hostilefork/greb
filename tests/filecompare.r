Rebol [
    title: "File Comparison"
    file: %filecompare.r

    description: --[
       Cross-platform file comparison script.
    ]--
]

actual: read to file! system.script.args.1
expected: read to file! system.script.args.2

if actual <> expected [
    print "!!! ACTUAL:"
    print @actual
    print "!!! EXPECTED:"
    print @expected
    panic "OUTPUT MISMATCH"
]
