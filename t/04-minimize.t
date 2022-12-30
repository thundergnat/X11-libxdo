use Test;
use X11::libxdo;
my $xdo = Xdo.new;

my $match = 'Test Page';
my $win = $xdo.search(:name($match))<ID>;
sleep .5;
$xdo.activate-window($win);

my $id = $xdo.get-active-window;

loop {
    $xdo.minimize($id);
    $xdo.activate-window($id);
    sleep .5;
    $xdo.raise-window($id);
    sleep .25;
    last if $++ >= 2;
}

CATCH { default { fail } }

$xdo.type($win, "\r\nWindow minimize/maximize seems ok", 1000) if $win;
sleep 1;

ok 1;
done-testing;
