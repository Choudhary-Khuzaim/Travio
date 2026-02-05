# Implementation Plan - Enable Attraction Location Click

The goal is to make the static map/location preview image in the `AttractionDetailsScreen` interactive, allowing users to open the location in a map application when clicked.

## Proposed Changes

### `lib/screens/attraction_details_screen.dart`

#### [ ] Update Map Preview Container
- Locate the `Container` that serves as the map preview (around line 237).
- Wrap this `Container` with a `GestureDetector`.
- Set the `onTap` property to call the existing `_openMap` method.

## Verification Plan

### Automated Tests
- No new automated tests needed for this UI interaction change.

### Manual Verification
- Open the app and navigate to a "Top Attraction" (e.g., from Hyderabad or Multan details).
- Scroll down to the "About Destination" section.
- Locate the map preview image with the location icon.
- Tap the image.
- Verify that it attempts to launch the map URL (Google Maps).
