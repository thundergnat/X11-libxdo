use Test;
use X11::Xdo;
my $xdo = Xdo.new;

my $active = $xdo.get-active-window;

my $command = $*KERNEL ~~ 'Mac' ?? 'open' !! 'xdg-open';

my $location = IO::Path.new($?FILE).dirname;

shell "$command $location/test.html" or die 'Could not open test page';
sleep .5;

my $match = 'Test Page';

say "Window IDs matching string $match:";
say my @w = $xdo.search($match);

sleep .25;

my $para = q:to/END/;
This is a paragraph of text. It is kind of boring, but I needed something in
 here and figured this is (marginally) more interesting than Hello World! 100
 times.

 Sorry, can not automatically close this window (or tab, as the case may be)
 safely. Please close it manually when testing is done.
END

if @w > 0 {
    my $w = @w[0];
    say "Window name: ", $xdo.get-window-name( $w );
    $xdo.send-key($w, 'Tab');
    $xdo.type($w, "Hello World! " x 6);
    $xdo.type($w, $para, 100000);
}

sleep 2;

$xdo.activate-window($active);
$xdo.raise-window($active);
sleep .5;

CATCH { default { fail } }

ok 1;
done-testing;
