use Test;
use X11::libxdo;
my $xdo = Xdo.new;

my $match = 'Test Page';
my $win = $xdo.search(:name($match))<ID>;

sleep .25;

$xdo.type($win, "\r\n\r\nOK: Should be safe to close now.", 50000);

sleep 2;

CATCH { default { note $_; fail } }

ok 1;
done-testing;
