QtQuick UI Elements
===================

A small set of UI elements with modern look-and-feel, and customizable behavior, to develop UI faster (buttons, input fields, layouts, etc...)

* `QQmlSvgIconHelper` : a class that takes a SVG file as input, plus size/ratio information, and makes a PNG file in persistant cache as output. If additional color information other than transparent is provided, the opaque pixels of the output will be colorized with the given tint.

* `QQuickPolygon` : a simple QtQuick item that takes a list of points and draw them with a provided color.

* `RowContainer` : an horizontal layout, that positions its childrens side-by-side, setting their size in consequence of their implicit size hints, and using remaining space in the layout to distribute it between all items that expose a negative implicit width.

* `GridContainer` : a smart grid that dimensions itself according to the sum/max of its children's implicit size hints, and then distributes regularly the available space between all children, positioned against a col/row model.

* `WrapLeftRightContainer` : a simplified layout for one of the most common positioning scheme in UI, on the same line, put some items at left, the others at right. But it has extra intelligency, to wrap itslef it left/right items do not fit in the provided space.

* `ScrollContainer` : put a `Flickable` (or derived, e.g. `ListView`) in it to get vertical/horizontal scrollbars displayed around it (according to the flicking direction axis that are set).

* `IconTextButton` : a simple and customizable push button that can have either an icon, a label, or both. Colors, sizes, fonts and rounding are customizable.
