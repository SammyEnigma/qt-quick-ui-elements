QtQuick UI Elements
===================

_A consistent set of UI elements with modern look-and-feel, and customizable behavior, to develop UI faster..._


## Controls

These are simple elements that can be used to create forms :

* `TextLabel` : a simple `Text` item, but which follows global `Style` by default (font family, font size, etc...)

* `TextButton` : a simple push button that can have either a label, an icon, or both. Additionally, it can have a custom back color.

* `TextBox` : a single-line editable text-field, which is in fact a wrapper around `TextInput`.

* `MultiLineTextBox` : a multi-line editable text-area, which is in fact a wrapper around `TextEdit`. It has fixed width and, automatic line-wrapping, and vertical auto-size by default.

* `NumberBox` : a composite field that can be used to edit numerical values between min and max bounds. It supports decimals, custom step value, and +/- buttons (that can be triggered with up/down arrow key strokes).

* `CheckableBox` : a simple ON/OFF field.

* `SliderBar` : a bar with movable handle to adjust numerical value in a given min/max range.

* `ProgressJauge` : a simple jauge to show progress of a value in a min/max range.

* `ComboList` : a selector for choosing one key/value pair in a fixed list of proposals. It handles separately the display value and selection key. It uses specific and customizable delegates to be able to use different kinds of models (QML ListModel, JS Array, with custom role names...).


## Containers

These elements are used as parents for controls :

* `ScrollContainer` : put a `Flickable` (or derived, e.g. `ListView`) in it to get vertical/horizontal scrollbars displayed around it (according to the flicking direction axis that are set). Those scrollbars can also be turned into simple indicators if needed.

* `Group` : a very basic invisible container for controls, with a title. It does nothing particular by itself, but it is meant to be used as children for `TabBar` and `Accordion` components.

* `TabBar` : a simple container that displays tabs to switch between the `Group` children.

* `Accordion` : another container that wraps/unwraps `Group` children when clicking on headers. Useful for sidebars.

* `ToolBar` : a simple horizontal set of controls that will be positioned inside a bar at top of a page.

* `StatusBar` : a simple horizontal set of controls that will be positioned inside a bar at bottom of a page.


## Layouts

These are invisible items that resize and reposition their children according to predefined behavior :

* `StretchRowContainer` : an horizontal layout, that positions its childrens side-by-side, setting their width in consequence of their implicit width hint, and using remaining space in the layout to distribute it between all items that expose a negative implicit width.

* `StretchColumnContainer` : an vertical layout, that positions its childrens one under the other, setting their height in consequence of their implicit height hint, and their width to its own width, and using remaining space in the layout to distribute it between all items that expose a negative implicit height.

* `GridContainer` : a smart grid that dimensions itself according to the sum/max of its children's implicit size hints, and then distributes regularly the available space between all children, positioned against a column/row model.

* `WrapLeftRightContainer` : a simplified layout for one of the most common positioning scheme in UI : on the same line, put some items to the left, the others to the right. But it has extra intelligency, to wrap itslef it left/right items do not fit in the provided space. It uses a `WrapBreaker` item to separate the left and right items.

* `Stretcher` : a simple item with implicit size hints to `-1` so that `Stretch***Container` auto-size it. It can also contain other items, to stretch easily some items which can't have their implicit size hints overwritten.


## Others

There are the helpers and utilities that don't fit in previous categories :

* `Style` : a global class that contains the most widely used variables (small/normal/big font size, font family, fixed font family, small/normal/big spacing, roundness, line size, etc). By changing this single file in an application, the UI elments will adapt automatically, no need to change each one separately.

* `ExtraAnchors` : an attached object which adds a lot of new convenience anchors (these anchors are only oneliners for things that can be acheived with classic anchors in multiple lines). Basically, it allows to anchors left/right, or top/bottom, or top/left/right, or top/left, etc, in a given object (parent or sibling).

* `SvgIconHelper` : a class that takes a SVG file as input, plus size/ratio information, and makes a PNG file in persistant cache as output and affect it to its parent item (usually an `Image`). If additional color information other than transparent is provided, the opaque pixels of the output will be colorized with the given tint.

* `FileSelector` : a nice file selector in plain QtQuick, with support for filtering, and icons according to file-type.

* `ThemeIconProvider` : a new image provider, to get icons from the theme (just use `image://icon-theme/<freedesktop icon name>`). Additionally, a small part of the Faenza icon theme is provided in resource file, basically for file types icons, and action icons (open, save, close, etc...), useful on platforms without standard FreeDesktop-compliant theme.

* `MimeIconsHelper` : a simple non-visual helper that can  return the icon name to use for a given MIME-type.

* `Polygon` : a simple QtQuick item that takes a list of points and draw them with a provided fill color and stroke width, either as a closed or open shape.

* `RegularPolygon` : a variant of `Polygon` with all sides having same size, and sized using handy diameter instead of side size.

* `RoundedRectangle` : a custom rectangle shape that can have different border-size for each side, and different radius for each corner, like in CSS, because the default `Rectangle` still can't.

* `AbstractSymbol` and `SymbolLoader` : two complementary components, providing resizable and recolorable symbols to use in custom components or as icon for `TextButton`. Some symbols (e.g: cross, plus, minus, arrows...) are available in `Style`, and can be easily used in a `SymbolLoader`.

* `Balloon` : a nice component that can contain a title, a text block and an image, and can be used to provide help or hints in the UI (e.g: in the side bars, or as temporary OSD...).

* `Line` : a thin gray line that can be stretched in vertical or horizontal direction, to be used as a single-side border on a container, or simply as a separator.


> NOTE : If you want to donate, use this link : [![Flattr this](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=thebootroo&url=http://gitlab.unique-conception.org/qt-qml-tricks/qt-quick-ui-elements)
