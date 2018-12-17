use Test;

#plan 3;

use-ok('X11::Xdo', 'is usable');

use X11::Xdo;
my $xdo = Xdo.new;
is($xdo.^name, 'X11::Xdo::Xdo', 'is an Xdo instance');
isa-ok( $xdo.version, Str, 'returns a version string');

done-testing;
