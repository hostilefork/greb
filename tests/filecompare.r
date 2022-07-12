Rebol [
    Title: {File Comparison}
    File: %filecompare.r

    Description: {
       Cross-platform file comparison script.
    }
]

actual: read to file! system.script.args.1
expected: read to file! system.script.args.2

if actual <> expected [
    print "!!! OUTPUT MISMATCH, RECEIVED:"
    print ^actual
    print "!!! EXPECTED:"
    print ^expected
    quit 1
]

quit 0

