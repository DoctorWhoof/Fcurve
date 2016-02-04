# Fcurve
Small fcurve module for the Monkey Language.

Features:
- Add knots to a timeline and give them values.
- Retrieve the value at any point in the timeline, interpolating between knots
- Retrieve next and previous knots from any point in the timeline.
- Three knot types: Hold (no interpolation), Linear and Cosine
- Only dependency is Mojo2, but you can comment out the "Plot" method to remove all dependencies.

