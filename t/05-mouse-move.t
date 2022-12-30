use Test;
use X11::libxdo;
my $xdo = Xdo.new;

my ($dw, $dh) = $xdo.get-desktop-dimensions( 0 );

sleep .25;

for ^$dw -> $mx {
    my $my = (($mx / $dh * τ).sin * 500).abs.Int + 200;
    $xdo.move-mouse( $mx, $my, 0 );
    my ($x, $y, $window-id, $screen) = $xdo.get-mouse-info;
    my $name = (try $xdo.get-window-name($window-id) if $window-id)
       // 'No name set';

    my $line = "Mouse location: x=$x : y=$y\nWindow under mouse:\nWindow ID: " ~
       $window-id ~ "\nWindow name: " ~ $name ~ "\nScreen #: $screen";

    print "\e[H\e[J", $line;
    sleep .001;
}

say '';

sleep .25;

CATCH { default { fail } }

my $match = 'Test Page';
my $win = $xdo.search(:name($match))<ID>;
sleep .5;
$xdo.activate-window($win);
$xdo.type($win, "\r\nMouse move seems ok", 1000) if $win;
sleep 1;

ok 1;
done-testing;
