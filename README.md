NAME
====

X11::Xdo

Perl 6 bindings to the [libxdo X11 automation library](https://github.com/jordansissel/xdotool).

Note: This is a WORK IN PROGRESS. The tests are under construction and many of them probably won't work on your computer. Several functions are not yet implemented, but a large core group is.

Not all libxdo functions are supported by every window manager. In general, mouse info & move and window info, move, & resize routines seem to be well supported, others... not so much.

SYNOPSIS
========

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

DESCRIPTION
===========

Perl 6 bindings to the [libxdo X11 automation library](https://github.com/jordansissel/xdotool).

Requires that libxdo and (for some functionality) xdtool command line utility is installed and accesable.

<table class="pod-table">
<thead><tr>
<th>Platform</th> <th>Install Method</th>
</tr></thead>
<tbody>
<tr> <td>Debian and Ubuntu</td> <td>[sudo] apt-get install libxdo-dev xdotool</td> </tr> <tr> <td>FreeBSD</td> <td>[sudo] pkg install libxdo-dev xdotool</td> </tr> <tr> <td>Fedora</td> <td>[sudo] dnf install libxdo-dev xdotool</td> </tr> <tr> <td>OSX</td> <td>[sudo] brew install libxdo-dev xdotool</td> </tr> <tr> <td>OpenSUSE</td> <td>[sudo] zypper install libxdo-dev xdotool</td> </tr> <tr> <td>Source Code on GitHub</td> <td>https://github.com/jordansissel/xdotool/releases</td> </tr>
</tbody>
</table>

Many (most?) of the xdo methods take a window ID # in their parameters. This is an integer ID# and MUST be passed as an Int. In general, to act on the currently active window, set the window ID to 0 or just leave blank.

Note that many of the methods will require a small delay for them to finish before moving on to the next, especially when performing several actions in a row. Either a short sleep or do a .activate-window($window-ID) before moving on to the next action.

There are several broad categories of methods available.

  * Misc

  * Mouse

  * Window

  * Keystrokes

  * Desktop

  * Display

Miscellaneous
-------------

##### method .version()

Get the library version.

Takes no parameters.

Returns the version string of the current libxdo library.

##### method .get_symbol_map()

Get modifier symbol pairs.

Takes no parameters.

Returns an array of modifier symbol pairs.

##### method .search ($query, :$visible = True, :$depth = 0)

Work in progress. Limited functionality at this point.

Takes (up to) three parameters:

  * Str $query: positional - String to search for in window name, class or classname

  * Bool $visible: named (optional) True (default) to only search visible windows. False for all windows.

  * into $depth: named (optional) Set to 0 (default to search all levels, 1 to only search toplevel windows, 2 to include their direct children, etc.

Mouse
-----

##### method .move-mouse( $x, $y, $screen )

Move the mouse to a specific location.

Takes three parameters:

  * int $x: the target X coordinate on the screen in pixels.

  * int $y: the target Y coordinate on the screen in pixels.

  * int $screen the screen (number) you want to move on.

Returns 0 on success !0 on failure.

##### method .move-mouse-relative( $delta-x, $delta-y )

Move the mouse relative to it's current position.

Takes two parameters:

  * int $delta-x: the distance in pixels to move on the X axis.

  * int $delta-y: the distance in pixels to move on the Y axis.

Returns 0 on success !0 on failure.

##### method .move-mouse-relative-to-window( $x, $y, $screen )

Move the mouse to a specific location relative to the top-left corner of a window.

Takes three parameters:

  * int $x: the target X coordinate on the screen in pixels.

  * int $y: the target Y coordinate on the screen in pixels.

  * int $window: ID of the window.

Returns 0 on success !0 on failure.

##### method .get-mouse-location()

Get the current mouse location (coordinates and screen ID number).

Takes no parameters;

Returns three integers:

  * int $x: the x coordinate of the mouse pointer.

  * int $y: the y coordinate of the mouse pointer.

  * int $screen: the index number of the screen the mouse pointer is located on.

##### method .get-mouse-info()

Get all mouse location-related data.

Takes no parameters;

Returns four integers:

  * int $x: the x coordinate of the mouse pointer.

  * int $y: the y coordinate of the mouse pointer.

  * int $window: the ID number of the window the mouse pointer is located on.

  * int $screen: the index number of the screen the mouse pointer is located on.

##### method .wait-for-mouse-to-move-from( $origin-x, $origin-y )

Wait for the mouse to move from a location. This function will block until the condition has been satisfied.

Takes two integer parameters:

  * int $origin-x: the X position you expect the mouse to move from.

  * int $origin-y: the Y position you expect the mouse to move from.

Returns nothing.

##### method .wait-for-mouse-to-move-to( $dest-x, $dest-y )

Wait for the mouse to move to a location. This function will block until the condition has been satisfied.

Takes two integer parameters:

  * int $dest-x: the X position you expect the mouse to move to.

  * int $dest-y: the Y position you expect the mouse to move to.

Returns nothing.

##### method .mouse-button-down( $window, $button )

Send a mouse press (aka mouse down) for a given button at the current mouse location.

Takes two parameters:

  * int $window: The ID# of the window receiving the event. 0 for the current window.

  * int $button: The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

##### method .mouse-button-up( $window, $button )

Send a mouse release (aka mouse up) for a given button at the current mouse location.

Takes two parameters:

  * int $window: The ID# of the window receiving the event. 0 for the current window.

  * int $button: The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

##### method .mouse-button-click( $window, $button )

Send a click for a specific mouse button at the current mouse location.

Takes two parameters:

  * int $window: The ID# of the window receiving the event. 0 for the current window.

  * int $button: The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

Returns nothing.

##### method .mouse-button-multiple( $window, $button, $delay? )

Send a one or more clicks for a specific mouse button at the current mouse location.

Takes three parameters:

  * int $window: The ID# of the window receiving the event. 0 for the current window.

  * int $button: The mouse button. Generally, 1 is left, 2 is middle, 3 is right, 4 is wheel up, 5 is wheel down.

  * int $repeat: (optional, defaults to 2) number of times to click the button.

  * int $delay: (optional, defaults to 8000) useconds delay between clicks. 8000 is a reasonable default.

Returns nothing.

##### method .get-window-under-mouse()

Get the window the mouse is currently over

Takes no parameters.

Returns the ID of the topmost window under the mouse.

Window
------

##### method .get-active-window()

Get the currently-active window. Requires your window manager to support this.

Takes no parameters.

Returns one integer:

  * $screen: Window ID of active window.

##### method .select-window-with-mouse()

Get a window ID by clicking on it. This function blocks until a selection is made.

Takes no parameters.

Returns one integer:

  * $screen: Window ID of active window.

##### method .get-window-location( $window?, $scrn? )

Get a window's location.

Takes two optional parameters:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

  * int $screen: Optional parameter screen ID. If none supplied, uses active screen ID.

Returns three integers:

  * $x: x coordinate of top left corner of window.

  * $y: y coordinate of top left corner of window.

  * $screen index of screen the window is located on.

##### method .get-window-size( $window? )

Get a window's size.

Takes one optional parameters:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns two integers:

  * int $width the width of the queried window in pixels.

  * int $height the height of the queried window in pixels.

##### method .get-window-geometry( $window? )

Get a windows geometry string.

Takes one optional parameter:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns standard geometry string

  * Str $geometry "{$width}x{$height}+{$x}+{$y}" format

##### method .get-window-name( $window? )

Get a window's name, if any.

Takes one optional parameter:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns one string:

  * Str $name Name of the queried window.

##### method .get-window-pid( $window )

Get the PID owning a window. Not all applications support this. It looks at the _NET_WM_PID property of the window.

Takes one parameter:

  * int $window: Window ID.

Returns one integer:

  * int $pid process id, or 0 if no pid found.

##### method .set-window-size( $window, $width, $height, $flags? = 0 )

Set the window size.

Takes four parameters:

  * int $window: the ID of the window to resize.

  * int $width: the new desired width.

  * int $height: the new desired height

  * int $flags: Optional, if 0, use pixels for units. Otherwise the units will be relative to the window size hints.

HINTS:

  * 1 size X dimension relative to character block width

  * 2 size Y dimension relative to character block height

  * 3 size both dimensions relative to character block size

Returns 0 on success !0 on failure.

##### method .focus-window( $window )

Set the focus on a window.

Takes one parameter:

  * int $window: ID of window to focus on.

Returns 0 on success !0 on failure.

##### method .get-focused-window( )

Get the ID of the window currently having focus.

Takes no parameters:

Returns one parameter:

  * int $window: ID of window currently having focus.

##### method .activate-window( $window )

Activate a window. This is generally a better choice than xdo_focus_window for a variety of reasons, but it requires window manager support:

  * If the window is on another desktop, that desktop is switched to.

  * It moves the window forward rather than simply focusing it

Takes one parameter:

  * int $window: Window ID.

Returns 0 on success !0 on failure.

##### method .raise-window( $window )

Raise a window to the top of the window stack. This is also sometimes termed as bringing the window forward.

Takes one parameter:

  * int $window: Window ID.

Returns 0 on success !0 on failure.

##### method .minimize( $window )

Minimize a window.

Takes one parameter:

  * int $window: Window ID.

Returns 0 on success !0 on failure.

##### method .map-window( $window )

Map a window. This mostly means to make the window visible if it is not currently mapped.

Takes one parameter:

  * int $window: Window ID.

Returns 0 on success !0 on failure.

##### method .unmap-window( $window )

Unmap a window. This means to make the window invisible and possibly remove it from the task bar on some WMs.

Takes one parameter:

  * int $window: Window ID.

Returns 0 on success !0 on failure.

##### method .move-window( $window )

Move a window to a specific location.

The top left corner of the window will be moved to the x,y coordinate.

Takes three parameters:

  * int $window: Window ID of the window to move.

  * int $x : the X coordinate to move to.

  * int $y: the Y coordinate to move to.

Returns 0 on success !0 on failure.

##### method .wait_for_window_active( $window )

Wait for a window to be active or not active. Requires your window manager to support this. Uses _NET_ACTIVE_WINDOW from the EWMH spec.

Takes one parameter:

  * int $window: Window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

##### method .close-window( $window )

TODO not working under Cinnamon?

Close a window without trying to kill the client.

Takes one parameter:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

##### method .kill-window( $window )

TODO not working under Cinnamon?

Kill a window and the client owning it.

Takes one parameter:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

Returns 0 on success !0 on failure.

##### method .override-redirect( $window, $value )

TODO not working under Cinnamon?

Set the override_redirect value for a window. This generally means whether or not a window manager will manage this window.

Takes two parameters:

  * int $window: Optional parameter window ID. If none supplied, uses active window ID.

  * int $value: If you set it to 1, the window manager will usually not draw borders on the window, etc. If you set it to 0, the window manager will see it like a normal application window.

Returns 0 on success !0 on failure.

Keystrokes
----------

##### method .type( $window, $string, $delay? )

Type a string to the specified window.

If you want to send a specific key or key sequence, such as "alt+l", you want instead send-sequence(...).

Not well supported under many window managers or by many applications unfortunately. Somewhat of a crapshoot as to which applications pay attention to this function. Web browsers tend to; (Firefox and Chrome tested), many other applications do not. Need to try it to see if it will work in your situation.

Takes three parameters:

  * int $window: The window you want to send keystrokes to or 0 for the current window.

  * string $string: The string to type, like "Hello world!"

  * int $delay: Optional delay between keystrokes in microseconds. 12000 is a decent choice if you don't have other plans.

Returns 0 on success !0 on failure.

##### method .send-sequence( $window, $string, $delay? )

This allows you to send keysequences by symbol name. Any combination of X11 KeySym names separated by '+' are valid. Single KeySym names are valid, too.

Examples: "l" "semicolon" "alt+Return" "Alt_L+Tab"

Takes three parameters:

  * int $window: The window you want to send keystrokes to or 0 for the current window.

  * string $string: The string keysequence to send.

  * int $delay: Optional delay between keystrokes in microseconds. 12000 is a decent choice if you don't have other plans.

Returns 0 on success !0 on failure.

##### method .send-key-press( $window, $string, $delay? )

Send key press (down) events for the given key sequence.

See send-sequence

Takes three parameters:

  * int $window: The window you want to send keystrokes to or 0 for the current window.

  * string $string: The string keysequence to send.

  * int $delay: Optional delay between key down events in microseconds.

Returns 0 on success !0 on failure.

##### method .send-key-release( $window, $string, $delay? )

Send key release (up) events for the given key sequence.

See send-sequence

Takes three parameters:

  * int $window: The window you want to send keystrokes to or 0 for the current window.

  * string $string: The string keysequence to send.

  * int $delay: Optional delay between key down events in microseconds.

Returns 0 on success !0 on failure.

Desktop
-------

NYI

Display
-------

Mostly NYI

##### method .get-desktop-dimensions( $screen? )

Query the viewport (your display) dimensions

If Xinerama is active and supported, that api internally is used. If Xinerama is disabled, will report the root window's dimensions for the given screen.

Takes one parameter:

  * int $screen: Optional parameter screen index. If none supplied, uses default 0.

Returns three integers:

  * $x: x dimension of the desktop window.

  * $y: y dimension of the desktop window.

  * $screen index of screen for which the dimensions are reported.

AUTHOR
======

2018 Steve Schulze aka thundergnat

This package is free software and is provided "as is" without express or implied warranty. You can redistribute it and/or modify it under the same terms as Perl itself.

LICENSE
=======

Licensed under The Artistic 2.0; see LICENSE.

