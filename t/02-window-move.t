use Test;
use X11::libxdo;
my $xdo = Xdo.new;

my $match = 'Test Page';
my $id = $xdo.search(:name($match))<ID>;
sleep .5;
$xdo.activate-window($id);

my ($w,  $h ) = $xdo.get-window-size( $id );
my ($wx, $wy) = $xdo.get-window-location( $id );
my ($dw, $dh) = $xdo.get-desktop-dimensions( 0 );

$xdo.move-window( $id, 150, 150 );

$xdo.set-window-size( $id, 350, 350, 0 );

sleep .25;

for flat 1 .. $dw - 350, $dw - 350, {$_ - 1} … 1 -> $mx { #
    my $my = (($mx / $dw * τ).sin * 500).abs.Int;
    $xdo.move-window( $id, $mx, $my );
    $xdo.activate-window($id);
}

sleep .25;

$xdo.set-window-size( $id, $w, $h, 0 );
$xdo.move-window( $id, $wx, $wy );
$xdo.activate-window($id);

CATCH { default { fail } }

$xdo.type($id, "\r\nWindow move seems ok", 1000) if $id;
sleep 1;

ok 1;

done-testing;
