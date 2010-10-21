#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use Test::Exception;

use Eval::Closure;

throws_ok {
    eval_closure()
} qr/'source'.*required/, "error when source isn't declared";

throws_ok {
    eval_closure(
        source => {},
    )
} qr/'source'.*string or array/, "error when source isn't string or array";

throws_ok {
    eval_closure(
        source => '1',
    )
} qr/'source'.*return.*sub/, "error when source doesn't return a sub";

throws_ok {
    eval_closure(
        source      => 'sub { }',
        environment => { 'foo' => \1 },
    )
} qr/should start with \@, \%, or \$/, "error from malformed env";

throws_ok {
    eval_closure(
        source      => 'sub { }',
        environment => { '$foo' => 1 },
    )
} qr/must be.*reference/, "error from non-ref value";

throws_ok {
    eval_closure(
        source => '$1++',
    )
} qr/Modification of a read-only value/, "gives us compile errors properly";

done_testing;