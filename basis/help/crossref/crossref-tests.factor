USING: help.crossref help.topics help.markup tools.test words
definitions assocs sequences kernel namespaces parser arrays
io.streams.string continuations debugger compiler.units eval
help.syntax ;
IN: help.crossref.tests

{ } [
    "IN: help.crossref.tests USING: help.syntax help.markup ; : foo ( -- ) ; HELP: foo \"foo is great\" ; ARTICLE: \"foo\" \"Foo\" { $subsection foo } ;" eval( -- )
] unit-test

{ $subsection } [
    "foo" article-content first first
] unit-test

{ t } [
    "foo" article-children
    "foo" "help.crossref.tests" lookup-word >link 1array sequence=
] unit-test

{ "foo" } [ "foo" "help.crossref.tests" lookup-word article-parent ] unit-test

{ } [
    [ "foo" "help.crossref.tests" lookup-word forget ] with-compilation-unit
] unit-test

{ } [
    "IN: help.crossref.tests USING: help.syntax help.markup ; : bar ( -- ) ; HELP: bar \"bar is great\" ; ARTICLE: \"bar\" \"Bar\" { $subsection bar } ;" eval( -- )
] unit-test

{ } [
    "IN: ayy USE: help.syntax ARTICLE: \"b\" \"B\" ;"
    <string-reader> "ayy" parse-stream drop
] unit-test

{ } [
    "IN: azz USE: help.syntax USE: help.markup ARTICLE: \"a\" \"A\" { $subsection \"b\" } ;"
    <string-reader> "ayy" parse-stream drop
] unit-test

{ } [
    "IN: ayy USE: help.syntax ARTICLE: \"c\" \"C\" ;"
    <string-reader> "ayy" parse-stream drop
] unit-test

{ } [
    "IN: azz USE: help.syntax USE: help.markup ARTICLE: \"a\" \"A\" { $subsection \"c\" } ;"
    <string-reader> "ayy" parse-stream drop
] unit-test

{ } [
    [
        "IN: azz USE: help.syntax USE: help.markup ARTICLE: \"yyy\" \"YYY\" ; ARTICLE: \"xxx\" \"XXX\" { $subsection \"yyy\" } ; ARTICLE: \"yyy\" \"YYY\" ;"
        <string-reader> "parent-test" parse-stream drop
    ] [ :1 ] recover
] unit-test

{ "xxx" } [ "yyy" article-parent ] unit-test

ARTICLE: "crossref-test-1" "Crossref test 1"
"Hello world" ;

ARTICLE: "crossref-test-2" "Crossref test 2"
{ $markup-example { $subsection "crossref-test-1" } } ;

{ { } } [ "crossref-test-2" >link article-children ] unit-test
