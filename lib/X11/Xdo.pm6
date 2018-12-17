unit module X11::Xdo:ver<0.0.1>:auth<github:thundergnat>;

=begin pod

=head1 NAME

X11::Xdo

Perl 6 bindings to the L<libxdo X11 automation library|https://github.com/jordansissel/xdotool>.

Note: This is a WORK IN PROGRESS. The tests are under construction and many of
them probably won't work on your computer. Several functions are not yet
implemented, but a large core group is.

Many of the test files do not actally run tests that can be chaecked for
correctness. (Many of the object move and resize test for example.)
Rather, they attempt to perform and action and fail/pass based on if the attempt
does or doesn't produce an error.

Not all libxdo functions are supported by every window manager. In general,
mouse info & move and window info, move, & resize routines seem to be well
supported, others... not so much.

=head1 SYNOPSIS

    use X11::Xdo;

    my $xdo = Xdo.new;

    say 'Version: ', $xdo.version;

    say 'Active window id: ', my $active = $xdo.get-active-window;

    say 'Active window title: ', $xdo.get-window-name($active);

    say "Pause for a bit...";
    sleep 4; # pause for a bit

    loop {
        my ($x, $y, $window-id, $screen) = $xdo.get-mouse-info;
        my $name = (try $xdo.get-window-name($window-id) if $window-id)
           // 'No name set';

        my $line = "Mouse location: $x, $y, Window under mouse - ID: " ~
           $window-id ~ ', Name: ' ~ $name ~ ", Screen #: $screen";

        print "\e[H\e[JMove mouse around screen; move to top to exit.\n", $line;

        # exit if pointer moved to top of screen
        say '' and last if $y < 1;

        # update periodically.
        sleep .05;
    }


=head1 DESCRIPTION

Perl 6 bindings to the [libxdo X11 automation library](https://github.com/jordansissel/xdotool).

Requires that libxdo and (for some functionality) xdtool command line utility is installed and accessible.

=begin table
Platform 	          |  Install Method
======================================================
Debian and Ubuntu     |  [sudo] apt-get install libxdo-dev xdotool
FreeBSD               |  [sudo] pkg install libxdo-dev xdotool
Fedora                |  [sudo] dnf install libxdo-dev xdotool
OSX                   |  [sudo] brew install libxdo-dev xdotool
OpenSUSE              |  [sudo] zypper install libxdo-dev xdotool
Source Code on GitHub |  https://github.com/jordansissel/xdotool/releases
=end table


Many (most?) of the xdo methods take a window ID # in their parameters.
This is an integer ID# and MUST be passed as an Int. In general, to act on the
currently active window, set the window ID to 0 or just leave blank.

Note that many of the methods will require a small delay for them to finish
before moving on to the next, especially when performing several actions in a
row. Either a short sleep or do a .activate-window($window-ID) before moving on
to the next action.

There are several broad categories of methods available.

=item Misc
=item Mouse
=item Window
=item Keystrokes
=item Desktop
=item Display

=head2 Miscellaneous

=head5 method .version()

Get the library version.

Takes no parameters.

Returns the version string of the current libxdo library.

=head5 method .get_symbol_map()

Get modifier symbol pairs.

Takes no parameters.

Returns an array of modifier symbol pairs.

=head5 method .search ($query, :$visible = True, :$depth = 0)

Work in progress. Limited functionality at this point.

Takes (up to) three parameters:

=item Str   $query: positional - String to search for in window name, class or classname
=item Bool  $visible: named (optional) True (default) to only search visible windows. False for all windows.
=item into  $depth: named (optional) Set to 0 (default to search all levels, 1 to only search toplevel windows, 2 to include their direct children, etc.

=end pod

#`[ SEARCH
TODO - need to figure out the parameter passing. Probably the most complicated
routine to bind to.

Search for windows.

search: the search query.
* @param windowlist_ret the list of matching windows to return
* @param nwindows_ret the number of windows (length of windowlist_ret)
* @see xdo_search_t
*/
int xdo_search_windows(const xdo_t *xdo, const xdo_search_t *search,
                    Window **windowlist_ret, unsigned int *nwindows_ret);
]

=begin pod

=head2 Mouse


=head5 method .move-mouse( $x, $y, $screen )

Move the mouse to a specific location.

Takes three parameters:

=item int $x:      the target X coordinate on the screen in pixels.
=item int $y:      the target Y coordinate on the screen in pixels.
=item int $screen  the screen (number) you want to move on.

Returns 0 on success !0 on failure.

=head5 method .move-mouse-relative( $delta-x, $delta-y )

Move the mouse relative to it's current position.

Takes two parameters:

=item int $delta-x:    the distance in pixels to move on the X axis.
=item int $delta-y:    the distance in pixels to move on the Y axis.

Returns 0 on success !0 on failure.

=head5 method .move-mouse-relative-to-window( $x, $y, $screen )

Move the mouse to a specific location relative to the top-left corner
of a window.

Takes three parameters:

=item int $x:      the target X coordinate on the screen in pixels.
=item int $y:      the target Y coordinate on the screen in pixels.
=item int $window: ID of the window.

Returns 0 on success !0 on failure.

=head5 method .get-mouse-location()

Get the current mouse location (coordinates and screen ID number).

Takes no parameters;

Returns three integers:

=item int $x:       the x coordinate of the mouse pointer.
=item int $y:       the y coordinate of the mouse pointer.
=item int $screen:  the index number of the screen the mouse pointer is located on.

=head5 method .get-mouse-info()

Get all mouse location-related data.

Takes no parameters;

Returns four integers:

=item int $x:       the x coordinate of the mouse pointer.
=item int $y:       the y coordinate of the mouse pointer.
=item int $window:  the ID number of the window the mouse pointer is located on.
=item int $screen:  the index number of the screen the mouse pointer is located on.

=head5 method .wait-for-mouse-to-move-from( $origin-x, $origin-y )

Wait for the mouse to move from a location. This function will block
until the condition has been satisfied.

Takes two integer parameters:

=item int $origin-x: the X position you expect the mouse to move from.
=item int $origin-y: the Y position you expect the mouse to move from.

Returns nothing.

=head5 method .wait-for-mouse-to-move-to( $dest-x, $dest-y )

Wait for the mouse to move to a location. This function will block
until the condition has been satisfied.

Takes two integer parameters:

=item int $dest-x: the X position you expect the mouse to move to.
=item int $dest-y: the Y position you expect the mouse to move to.

Returns nothing.

=head5 method .mouse-button-down( $window, $button )

Send a mouse press (aka mouse down) for a given button at the current mouse
location.

Takes two parameters:

=item int $window:  The ID# of the window receiving the event. 0 for the current window.
=item int $button:  The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

=head5 method .mouse-button-up( $window, $button )

Send a mouse release (aka mouse up) for a given button at the current mouse
location.

Takes two parameters:

=item int $window:  The ID# of the window receiving the event. 0 for the current window.
=item int $button:  The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

=head5 method .mouse-button-click( $window, $button )

Send a click for a specific mouse button at the current mouse location.

Takes two parameters:

=item int $window:  The ID# of the window receiving the event. 0 for the current window.
=item int $button:  The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

=head5 method .mouse-button-multiple( $window, $button, $delay? )

Send a one or more clicks for a specific mouse button at the current mouse
location.

Takes three parameters:

=item int $window:  The ID# of the window receiving the event. 0 for the current window.
=item int $button:  The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.
=item int $repeat:  (optional, defaults to 2) number of times to click the button.
=item int $delay:   (optional, defaults to 8000) useconds delay between clicks. 8000 is a reasonable default.

Returns nothing.

=head5 method .get-window-under-mouse()

Get the window the mouse is currently over

Takes no parameters.

Returns the ID of the topmost window under the mouse.


=head2 Window

=head5 method .get-active-window()

Get the currently-active window. Requires your window manager to support this.

Takes no parameters.

Returns one integer:

=item $screen:  Window ID of active window.

=head5 method .select-window-with-mouse()

Get a window ID by clicking on it. This function blocks until a selection
 is made.

Takes no parameters.

Returns one integer:

=item $screen:  Window ID of active window.

=head5 method .get-window-location( $window?, $scrn? )

Get a window's location.

Takes two optional parameters:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.
=item int $screen: Optional parameter screen ID. If none supplied, uses active screen ID.

Returns three integers:

=item $x:       x coordinate of top left corner of window.
=item $y:       y coordinate of top left corner of window.
=item $screen   index of screen the window is located on.

=head5 method .get-window-size( $window? )

Get a window's size.

Takes one optional parameters:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns two integers:

=item int $width     the width of the queried window in pixels.
=item int $height    the height of the queried window in pixels.

=head5 method .get-window-geometry( $window? )

Get a windows geometry string.

Takes one optional parameter:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns standard geometry string

=item Str $geometry  "{$width}x{$height}+{$x}+{$y}" format

=head5 method .get-window-name( $window? )

Get a window's name, if any.

Takes one optional parameter:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns one string:

=item Str $name   Name of the queried window.

=head5 method .get-window-pid( $window )

Get the PID owning a window. Not all applications support this.
It looks at the _NET_WM_PID property of the window.

Takes one  parameter:

=item int $window: Window ID.

Returns one integer:

=item int $pid   process id, or 0 if no pid found.

=head5 method .set-window-size( $window, $width, $height, $flags? = 0 )

Set the window size.

Takes four parameters:

=item int $window:   the ID of the window to resize.
=item int $width:    the new desired width.
=item int $height:   the new desired height

=begin item
int $flags:    Optional, if 0, use pixels for units. Otherwise the units will
be relative to the window size hints.
=end item

HINTS:

=item 1 size X dimension relative to character block width
=item 2 size Y dimension relative to character block height
=item 3 size both dimensions relative to character block size

Returns 0 on success !0 on failure.

=head5 method .focus-window( $window )

Set the focus on a window.

Takes one  parameter:

=item int $window:  ID of window to focus on.

Returns 0 on success !0 on failure.

=head5 method .get-focused-window( )

Get the ID of the window currently having focus.

Takes no parameters:

Returns one parameter:

=item int $window:  ID of window currently having focus.


=head5 method .activate-window( $window )

Activate a window. This is generally a better choice than xdo_focus_window
for a variety of reasons, but it requires window manager support:

=item If the window is on another desktop, that desktop is switched to.
=item It moves the window forward rather than simply focusing it

Takes one  parameter:

=item int $window: Window ID.

Returns 0 on success !0 on failure.

=head5 method .raise-window( $window )

Raise a window to the top of the window stack. This is also sometimes
termed as bringing the window forward.

Takes one parameter:

=item int $window: Window ID.

Returns 0 on success !0 on failure.

=head5 method .minimize( $window )

Minimize a window.

Takes one parameter:

=item int $window: Window ID.

Returns 0 on success !0 on failure.

=head5 method .map-window( $window )

Map a window. This mostly means to make the window visible if it is
not currently mapped.

Takes one parameter:

=item int $window: Window ID.

Returns 0 on success !0 on failure.

=head5 method .unmap-window( $window )

Unmap a window. This means to make the window invisible and possibly remove it
from the task bar on some WMs.

Takes one parameter:

=item int $window: Window ID.

Returns 0 on success !0 on failure.

=head5 method .move-window( $window )

Move a window to a specific location.

The top left corner of the window will be moved to the x,y coordinate.

Takes three parameters:

=item int $window: Window ID of the window to move.
=item int $x :     the X coordinate to move to.
=item int $y:      the Y coordinate to move to.

Returns 0 on success !0 on failure.

=head5 method .wait_for_window_active( $window )

Wait for a window to be active or not active.
Requires your window manager to support this.
Uses _NET_ACTIVE_WINDOW from the EWMH spec.

Takes one parameter:

=item int $window: Window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

=head5 method .close-window( $window )

TODO not working under Cinnamon?

Close a window without trying to kill the client.

Takes one  parameter:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

=head5 method .kill-window( $window )

TODO not working under Cinnamon?

Kill a window and the client owning it.

Takes one  parameter:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

=head5 method .override-redirect( $window, $value )

TODO not working under Cinnamon?

Set the override_redirect value for a window. This generally means
whether or not a window manager will manage this window.

Takes two parameters:

=item int $window: Optional parameter window ID. If none supplied, uses active window ID.
=item int $value:  If you set it to 1, the window manager will usually not draw borders on the window, etc. If you set it to 0, the window manager will see it like a normal application window.

Returns 0 on success !0 on failure.

=head2 Keystrokes

=head5 method .type( $window, $string, $delay? )

Type a string to the specified window.

If you want to send a specific key or key sequence, such as "alt+l", you
want instead send-sequence(...).

Not well supported under many window managers or by many applications
unfortunately. Somewhat of a crapshoot as to which applications pay attention to
this function. Web browsers tend to; (Firefox and Chrome tested), many other
applications do not. Need to try it to see if it will work in your situation.

Takes three parameters:

=item int    $window: The window you want to send keystrokes to or 0 for the current window.
=item string $string: The string to type, like "Hello world!"
=item int    $delay:  Optional delay between keystrokes in microseconds. 12000 is a decent choice if you don't have other plans.

Returns 0 on success !0 on failure.

=head5 method .send-sequence( $window, $string, $delay? )

This allows you to send keysequences by symbol name. Any combination
of X11 KeySym names separated by '+' are valid. Single KeySym names
are valid, too.

Examples:  "l"   "semicolon"  "alt+Return"  "Alt_L+Tab"

Takes three parameters:

=item int    $window: The window you want to send keystrokes to or 0 for the current window.
=item string $string: The string keysequence to send.
=item int    $delay:  Optional delay between keystrokes in microseconds. 12000 is a decent choice if you don't have other plans.

Returns 0 on success !0 on failure.

=head5 method .send-key-press( $window, $string, $delay? )

Send key press (down) events for the given key sequence.

See send-sequence

Takes three parameters:

=item int    $window: The window you want to send keystrokes to or 0 for the current window.
=item string $string: The string keysequence to send.
=item int    $delay:  Optional delay between key down events in microseconds.

Returns 0 on success !0 on failure.

=head5 method .send-key-release( $window, $string, $delay? )

Send key release (up) events for the given key sequence.

See send-sequence

Takes three parameters:

=item int    $window: The window you want to send keystrokes to or 0 for the current window.
=item string $string: The string keysequence to send.
=item int    $delay:  Optional delay between key down events in microseconds.

Returns 0 on success !0 on failure.

=end pod

#`[ TODO - need to figure out proper calling conventions.
Send a series of keystrokes.

window:   The window to send events to or CURRENTWINDOW
keys:     The array of charcodemap_t entities to send.
nkeys:    The length of the keys parameter
pressed:  1 for key press, 0 for key release.
modifier: Pointer to integer to record the modifiers activated by
          the keys being pressed. If NULL, we don't save the modifiers.
delay:     The delay between keystrokes in microseconds.

method send-keysequence-list($window = 0, Carray @keys, int $pressed, int, $modifier, int64 $delay = 12000) {
    sub xdo_send_keysequence_window_list_do(int64, int64, Carray, int, int, int64) returns int32 is native('xdo') { * };
    xdo_send_keysequence_window_list_do(self.id, @keys, +@keys, $pressed, $modifier, $delay)
}
]

=begin pod

=head2 Desktop

NYI

=head2 Display

Mostly NYI


=head5 method .get-desktop-dimensions( $screen? )

Query the viewport (your display) dimensions

If Xinerama is active and supported, that api internally is used.
If Xinerama is disabled, will report the root window's dimensions
for the given screen.

Takes one parameter:

=item int $screen: Optional parameter screen index. If none supplied, uses default 0.

Returns three integers:

=item $x:       x dimension of the desktop window.
=item $y:       y dimension of the desktop window.
=item $screen   index of screen for which the dimensions are reported.

=head1 AUTHOR

2018 Steve Schulze aka thundergnat

This package is free software and is provided "as is" without express or implied
warranty.  You can redistribute it and/or modify it under the same terms as Perl
itself.

=head1 LICENSE

Licensed under The Artistic 2.0; see LICENSE.


=end pod

#===============================================================================

use NativeCall;

class Xdo is export {
    has Pointer $.id is rw;

    submethod BUILD {
        sub xdo_new(Str) returns Pointer is native('xdo') { * }
        self.id = xdo_new('');
    }

    #`[ Return a string representing the version of this library.]
    method version() {
        sub xdo_version() returns Str is encoded('utf8') is native('xdo') { * }
        xdo_version()
    }

    #`[
    Move the mouse to a specific location.

    Takes three parameters:
      x:          the target X coordinate on the screen in pixels.
      y:          the target Y coordinate on the screen in pixels.
      screen ID:  the screen (number) you want to move on.
    ]
    method move-mouse (int32 $x, int32 $y is copy, int8 $screen is copy) {
        sub xdo_move_mouse(Pointer, int32, int32, int8) returns int32 is native('xdo') { * };
        ($, $, $screen ) = self.get-mouse-location unless $screen;
        xdo_move_mouse(self.id, $x, $y, $screen +& 15);
    }

    #`[
    Move the mouse to a specific location relative to the top-left corner
    of a window.

    Takes three parameters:
      x:          the target X coordinate on the screen in pixels.
      y:          the target Y coordinate on the screen in pixels.
      window-ID:  ID of the window.
    ]
    method move-mouse-relative-to-window (int32 $x, int32 $y, int64 $window){
        sub xdo_move_mouse_relative_to_window(Pointer, int64, int32, int32) returns int32 is native('xdo') { * };
        xdo_move_mouse_relative_to_window(self.id, $window, $x, $y)
    }


    #`[
    Move the mouse relative to it's current position.

    Takes two parameters:
      x:    the distance in pixels to move on the X axis.
      y:    the distance in pixels to move on the Y axis.
    ]
    method move-mouse-relative (int32 $x, int32 $y){
        sub xdo_move_mouse_relative(Pointer, int32, int32) returns int32 is native('xdo') { * };
        xdo_move_mouse_relative(self.id, $x, $y)
    }

    #`[
    Send a mouse press (aka mouse down) for a given button at the current mouse
    location.

    Takes two parameters:
      window-ID:  The window receiving the event. 0 for the current window.
      button:     The mouse button. Generally, 1 is left, 2 is middle, 3 is
                   right, 4 is wheel up, 5 is wheel down.
    ]
    method mouse-button-down (int64 $window = 0, int $button = 1) {
        sub xdo_mouse_down(Pointer, int64, int32) returns int32 is native('xdo') { * };
        xdo_mouse_down(self.id, $window, $button)
    }

    #`[
    Send a mouse release (aka mouse up) for a given button at the current mouse
    location.

    window-ID:  The window receiving the event. 0 for the current window.
    button:     The mouse button. Generally, 1 is left, 2 is middle, 3 is
                right, 4 is wheel up, 5 is wheel down.
    ]
    method mouse-button-up (int64 $window = 0, int $button = 1) {
        sub xdo_mouse_up(Pointer, int64, int32) returns int32 is native('xdo') { * };
        xdo_mouse_up(self.id, $window, $button)
    }

    #`[
    Send a click for a specific mouse button at the current mouse location.

    window-ID:  The window receiving the event. 0 for the current window.
    button:     The mouse button. Generally, 1 is left, 2 is middle, 3 is
                right, 4 is wheel up, 5 is wheel down.
    ]
    method mouse-button-click (int64 $window = 0, int $button = 1) {
        sub xdo_click_window(Pointer, int64, int32) returns int32 is native('xdo') { * };
        xdo_click_window(self.id, $window, $button)
    }

    #`[
    Send a one or more clicks for a specific mouse button at the current mouse
    location.

    window-ID:  The window receiving the event. 0 for the current window.
    button:     The mouse button. Generally, 1 is left, 2 is middle, 3 is
                right, 4 is wheel up, 5 is wheel down.

    delay:      useconds delay between clicks. 8000 is a reasonable default.
    ]
    method mouse-button-multiple (int64 $window = 0, int $button = 1, int $repeat = 2, int $delay = 8000) {
        sub xdo_mouse_multiple(Pointer, int64, int32, int32, uint32) returns int32 is native('xdo') { * };
        xdo_mouse_multiple(self.id, $window, $button, $repeat, $delay)
    }

    #`[
    Get the current mouse location (coordinates and screen ID number).
    ]
    method get-mouse-location () {
        sub xdo_get_mouse_location(Pointer, int32 is rw, int32 is rw, int8 is rw) returns int32 is native('xdo') { * };
        my int32 ($x, $y);
        my int8 $screen;
        my $error = xdo_get_mouse_location(self.id, $x, $y, $screen);
        $x, $y, $screen +& 15
    }

    #`[
    Get all mouse location-related data.

    Returns four integers: $x, $y, $window-ID, $screen-ID.
    ]
    method get-mouse-info () {
        sub xdo_get_mouse_location2(Pointer, int32 is rw, int32 is rw, int8 is rw, int64 is rw) returns int32 is native('xdo') { * };
        my int32 ($x, $y);
        my int8 $screen;
        my int64 $window;
        my $error = xdo_get_mouse_location2(self.id, $x, $y, $screen, $window);
        $x, $y, $window, $screen +& 15
    }

    #`[
    Wait for the mouse to move from a location. This function will block
    until the condition has been satisfied.

    origin-x: the X position you expect the mouse to move from
    origin-y: the Y position you expect the mouse to move from
    ]
    method wait-for-mouse-to-move-from (int32 $origin-x, int32 $origin-y) {
        sub xdo_wait_for_mouse_move_from(int64, int32, int32) returns int32 is native('xdo') { * };
        xdo_wait_for_mouse_move_from(self.id, $origin-x, $origin-y);
    }

    #`[
    Wait for the mouse to move to a location. This function will block
    until the condition has been satisfied.

    dest_x: the X position you expect the mouse to move to
    dest_y: the Y position you expect the mouse to move to
    ]
    method wait-for-mouse-to-move-to (int32 $dest-x, int32 $dest-y) {
        sub xdo_wait_for_mouse_move_to(int64, int32, int32) returns int32 is native('xdo') { * };
        xdo_wait_for_mouse_move_to(self.id, $dest-x, $dest-y);
    }


   #`[
    Type a string to the specified window.

    If you want to send a specific key or key sequence, such as "alt+l", you
    want instead send-sequence(...).

    window: The window you want to send keystrokes to or CURRENTWINDOW
    string: The string to type, like "Hello world!"
    delay:  The delay between keystrokes in microseconds. 12000 is a decent
            choice if you don't have other plans.
    ]
    method type ($window, str $text = '', int32 $delay = 12000) {
        sub xdo_enter_text_window(Pointer, int64, str, int32) returns int32 is native('xdo') { * };
        xdo_enter_text_window(self.id, $window, $text, $delay)
    }

    #`[
    This allows you to send keysequences by symbol name. Any combination
    of X11 KeySym names separated by '+' are valid. Single KeySym names
    are valid, too.

    Examples:
      "l"
      "semicolon"
      "alt+Return"
      "Alt_L+Tab"

    If you want to type a string, such as "Hello world." you want to instead
    use xdo_enter_text_window.

    window:      The window you want to send the keysequence to or
                   CURRENTWINDOW
    keysequence: The string keysequence to send.
    delay        The delay between keystrokes in microseconds.
    ]
    method send-sequence ($window = 0, str $keysequence = '', int32 $delay = 12000) {
        sub xdo_send_keysequence_window(Pointer, int64, str, int32) returns int32 is native('xdo') { * };
        xdo_send_keysequence_window(self.id, $window, $keysequence, $delay)
    }

    #`[
    Send key release (up) events for the given key sequence.

    See send-sequence
    ]
    method send-key-release ($window = 0, str $keysequence = '', int64 $delay = 12000) {
        sub xdo_send_keysequence_window_up(Pointer, int64, str, int64) returns int32 is native('xdo') { * };
        xdo_send_keysequence_window_up(self.id, $window, $keysequence, $delay)
    }

    #`[
    Send key press (down) events for the given key sequence.

    See send-sequence
    ]
    method send-key-press ($window = 0, str $keysequence = '', int64 $delay = 12000) {
        sub xdo_send_keysequence_window_down(Pointer, int64, str, int64) returns int32 is native('xdo') { * };
        xdo_send_keysequence_window_down(self.id, $window, $keysequence, $delay)
    }

    #`[
    Send a series of keystrokes.

    window:   The window to send events to or CURRENTWINDOW
    keys:     The array of charcodemap_t entities to send.
    nkeys:    The length of the keys parameter
    pressed:  1 for key press, 0 for key release.
    modifier: Pointer to integer to record the modifiers activated by
              the keys being pressed. If NULL, we don't save the modifiers.
    delay:     The delay between keystrokes in microseconds.

    method send-keysequence-list($window = 0, Carray @keys, int $pressed, int, $modifier, int64 $delay = 12000) {
        sub xdo_send_keysequence_window_list_do(int64, int64, Carray, int, int, int64) returns int32 is native('xdo') { * };
        xdo_send_keysequence_window_list_do(self.id, @keys, +@keys, $pressed, $modifier, $delay)
    }
    ]

    #`[
    Get the window the mouse is currently over
    Returns the ID of the topmost window under the mouse.
    ]
    method get-window-under-mouse () {
        my uint64 $window;
        sub xdo_get_window_at_mouse(Pointer, int64 is rw) returns int32 is native('xdo') { * };
        xdo_get_window_at_mouse(self.id, $window);
        $window
    }

    #`[
    Get a window's location.
    Optional argument window ID. If none supplied, uses active window ID.
    Optional argument screen ID. If none supplied, uses active screen ID.
    Returns three integers: $x, $y, $screen-ID.
    ]
    method get-window-location (int64 $window? is copy, int8 $screen? is copy ) {
        my int32 ($x, $y);
        $screen = 0 unless $screen;
        sub xdo_get_window_location( uint64, uint64, int32 is rw, int32 is rw, int8 is rw ) is native('xdo') { * };
        $window = self.get-active-window unless $window;
        xdo_get_window_location( self.id, $window, $x, $y, $screen );
        $x, $y, $screen +& 15
    }

    #`[
    Get a window's size.
    Optional argument window ID. If none supplied, uses active window ID.
    Returns two integers: width, height.
    ]
    method get-window-size (int64 $window? is copy) {
        my int32 ($width, $height);
        sub xdo_get_window_size( uint64, uint64, int32 is rw, int32 is rw ) is native('xdo') { * };
        $window = self.get-active-window unless $window;
        xdo_get_window_size( self.id, $window, $width, $height );
        $width, $height;
    }

    #`[
    Get window geometry.
    Optional argument window ID. If none supplied, uses active window ID.
    Returns standard geometry strings
    ]
    method get-window-geometry (int64 $window? is copy) {
        $window = self.get-active-window unless $window;
        my ($x, $y) = self.get-window-location($window);
        my ($width, $height) = self.get-window-size($window);
        "{$width}x{$height}+{$x}+{$y} "
    }

    #`[
    Change the window size.

      param window: the window to resize
      param w: the new desired width
      param h: the new desired height
      param flags: if 0, use pixels for units. If SIZE_USEHINTS, then
         the units will be relative to the window size hints.
    ]
    method set-window-size (int64 $window, int32 $width, int32 $height, int32 $flags? = 0) {
        sub xdo_set_window_size( uint64, uint64, int32, int32, int32) returns int32 is native('xdo') { * };
        xdo_set_window_size( self.id, $window, $width, $height, $flags );
    }

    #`[
    Get the currently-active window.
    Requires your window manager to support this.

    Returns ID of active window.
    ]
    method get-active-window () {
        my uint64 $window;
        sub xdo_get_active_window(Pointer, uint64 is rw) returns int32 is native('xdo') { * };
        xdo_get_active_window(self.id, $window);
        $window;
    }

    #`[
    Get a window ID by clicking on it. This function blocks until a selection
     is made.

    Returns Window ID of the selected window.
    ]
    method select-window-with-mouse () {
        my uint64 $window;
        sub xdo_select_window_with_click(Pointer, uint64 is rw) returns int32 is native('xdo') { * };
        my $error = xdo_select_window_with_click(self.id, $window);
        $window;
    }

    #`[
    Get a window's name, if any.
    ]
    method get-window-name (int64 $window? is copy) {
        sub xdo_get_window_name(Pointer, uint64, Pointer is rw, int32 is rw, int32 is rw ) returns int32 is native('xdo') { * };
        $window = self.get-active-window unless $window;
        my $name = Pointer[Str].new;
        my int ($name-length, $name-type);
        xdo_get_window_name( self.id, $window, $name, $name-length, $name-type );
        $name.deref;
    }

    #`[
    Get the PID owning a window. Not all applications support this.
    It looks at the _NET_WM_PID property of the window.
    Returns the process id or 0 if no pid found.
    ]
    method get-window-pid (int64 $window) {
        sub xdo_get_pid_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_get_pid_window( self.id, $window )
    }

    #`[ # TODO not working under Cinnamon?
    Kill a window and the client owning it.
    ]
    method kill-window (int64 $window) {
        sub xdo_kill_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_kill_window( self.id, $window )
    }

    #`[ # TODO not working under Cinnamon?
    Close a window without trying to kill the client.
    ]
    method close-window (int64 $window) {
        sub xdo_close_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_close_window( self.id, $window )
    }

    #`[
    Focus a window.
    ]
    method focus-window (int64 $window) {
        sub xdo_focus_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_focus_window( self.id, $window )
    }

    #`[
    Get the window currently having focus.

       param window_ret Pointer to a window where the currently-focused window
       ID will be stored.
    ]
    method get-focused-window () {
        my int64 $window;
        sub xdo_get_focused_window_sane(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_get_focused_window_sane( self.id, $window );
        $window
    }


    #`[
    Activate a window. This is generally a better choice than xdo_focus_window
    for a variety of reasons, but it requires window manager support:
       - If the window is on another desktop, that desktop is switched to.
       - It moves the window forward rather than simply focusing it

    Requires your window manager to support this.
    Uses _NET_ACTIVE_WINDOW from the EWMH spec.
    ]
    method activate-window (int64 $window) {
        sub xdo_activate_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_activate_window( self.id, $window );
    }

    #`[
    Raise a window to the top of the window stack. This is also sometimes
    termed as bringing the window forward.
    ]
    method raise-window (int64 $window) {
        sub xdo_raise_window(Pointer, uint64) returns int32 is native('xdo') { * };
        xdo_raise_window( self.id, $window )
    }

    #`[
    Wait for a window to be active or not active.
    Requires your window manager to support this.
    Uses _NET_ACTIVE_WINDOW from the EWMH spec.

      param window: the window to wait on
      param active: If 1, wait for active. If 0, wait for inactive.
    ]
    method wait_for_window_active (int64 $window, int32 $active) {
        sub xdo_wait_for_window_active(Pointer, uint64, int32) returns int32 is native('xdo') { * };
        xdo_wait_for_window_active( self.id, $window, $active );
    }

    #`[ # TODO not working under Cinnamon?
    Set the override_redirect value for a window. This generally means
    whether or not a window manager will manage this window.

    If you set it to 1, the window manager will usually not draw borders on the
    window, etc. If you set it to 0, the window manager will see it like a
    normal application window.
    ]
    method override-redirect (int64 $window, int32 $value) {
        sub xdo_set_window_override_redirect(Pointer, uint64, int32 ) returns int32 is native('xdo') { * };
        xdo_set_window_override_redirect(self.id, $window, $value)
   }

   #`[
   Search for windows.

   search: the search query.
   * @param windowlist_ret the list of matching windows to return
   * @param nwindows_ret the number of windows (length of windowlist_ret)
   * @see xdo_search_t
   */
  int xdo_search_windows(const xdo_t *xdo, const xdo_search_t *search,
                        Window **windowlist_ret, unsigned int *nwindows_ret);

   # search bitmask bits
   #define SEARCH_TITLE       (1UL << 0) DEPRECATED - Use SEARCH_NAME
   #define SEARCH_CLASS       (1UL << 1)
   #define SEARCH_NAME        (1UL << 2)
   #define SEARCH_PID         (1UL << 3)
   #define SEARCH_ONLYVISIBLE (1UL << 4)
   #define SEARCH_SCREEN      (1UL << 5)
   #define SEARCH_CLASSNAME   (1UL << 6)
   #define SEARCH_DESKTOP     (1UL << 7)

    class search-struct is repr('CStruct') {
        has str   $.title;            # regex pattern to test against a window title
        has str   $.winclass;         # regex pattern to test against a window class
        has str   $.winclassname;     # regex pattern to test against a window class
        has str   $.winname;          # regex pattern to test against a window name
        has int   $.pid;              # window pid (From window atom _NET_WM_PID)
        has long  $.max_depth = 1;    # depth of search. 1 means only toplevel windows
        has int   $.only_visible = 1; # boolean; set true to search only visible windows
        has int   $.screen;           # what screen to search, if any. If none given, search all

        # Should the tests be 'and' 0 or 'or' 1 ? If 'and', any failure will skip the
        # window. If 'or', any success will keep the window in search results.
        has int   $.require = 0;

        # bitmask of things you are searching for, such as SEARCH_NAME, etc.
        # @see SEARCH_NAME, SEARCH_CLASS, SEARCH_PID, SEARCH_CLASSNAME, etc

        has long $.searchmask = 2;

        # What desktop to search, if any. If none given, search all screens. */
        has long $.desktop;

        # How many results to return? If 0, return all. */
        has uint32 $.limit = 0;
    }

    method search-windows (str $string) {
        my $query = search-struct.new(:winname($string), :searchmask(2));
        dd $query;
        my Pointer $ids;
        sub xdo_search_windows(Pointer, search-struct, Pointer, int32 ) returns int32 is native('xdo') { * };
        my int32 $n;
        say xdo_search_windows(self.id, $query, $ids, $n);
        $ids.deref
   }
   ]

   method search ($query, :$visible = True, :$depth = 0) {
       my $v = $visible ?? '--onlyvisible'     !! '';
       my $s = $depth   ?? "--maxdepth $depth" !! '';
       (shell "xdotool search --onlyvisible  --name \"$query\"", :out, :err).out.lines».Int;
   }


   #`[
   Minimize a window.
   ]
   method minimize (int64 $window) {
       sub xdo_minimize_window(Pointer, uint64) returns int32 is native('xdo') { * };
       xdo_minimize_window(self.id, $window)
   }

   #`[
   Map a window. This mostly means to make the window visible if it is
   not currently mapped.

   @param wid the window to map.
   ]
   method map-window (int64 $window) {
       sub xdo_map_window(Pointer, uint64) returns int32 is native('xdo') { * };
       xdo_map_window(self.id, $window)
   }

   #`[
   Unmap a window

   @param wid the window to unmap
   ]
   method unmap-window (int64 $window) {
       sub xdo_unmap_window(Pointer, uint64) returns int32 is native('xdo') { * };
       xdo_unmap_window(self.id, $window)
   }

   #`[
   Move a window to a specific location.

   The top left corner of the window will be moved to the x,y coordinate.

     param window the window to move
     param x the X coordinate to move to.
     param y the Y coordinate to move to.
   ]
   method move-window (int64 $window, int32 $x, int32 $y) {
       sub xdo_move_window(Pointer, uint64, int32, int32) returns int32 is native('xdo') { * };
       xdo_move_window(self.id, $window, $x, $y)
   }

   method get_symbol_map () {
       ['alt'    => 'Alt_L',
       'ctrl'    => 'Control_L',
       'control' => 'Control_L',
       'meta'    => 'Meta_L',
       'super'   => 'Super_L',
       'shift'   => 'Shift_L',
       Nil       => Nil
       ]
   }

   #`[
    Query the viewport (your display) dimensions

     If Xinerama is active and supported, that api internally is used.
     If Xineram is disabled, we will report the root window's dimensions
     for the given screen.
   ]
   method get-desktop-dimensions (int8 $screen? is copy) {
       my uint32 ($width, $height);
       $screen //= 0;
       sub xdo_get_viewport_dimensions(Pointer, uint32 is rw, uint32 is rw, int8) returns int32 is native('xdo') { * };
       xdo_get_viewport_dimensions(self.id, $width, $height, $screen);
       $width, $height, $screen +& 15;
   }

}
