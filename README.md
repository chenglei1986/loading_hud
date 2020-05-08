# LoadingHud

A dialog with a loading indicator.

![showcase](screenshots/screen_shot.gif)

## Getting Started

### Add dependency

```yaml
dependencies:
  loading_hud: ^0.1.0
```

### Examples

```dart
var loadingHud = LoadingHud(
  context,
  cancelable: true,                  // Cancelable when pressing Android back key
  canceledOnTouchOutside: true,      // Cancelable when touch outside of the ProgressHud
  dimBackground: false,              // Dimming background when ProgressHud is showing
  hudColor: Color(0x99000000),       // Color of the ProgressHud
  indicatorColor: Color(0xFFFFFFFF), // Color of the spinning progress indicator
);
/// Show LoadingHud
loadingHud.show();
/// Dismiss LoadingHud
loadingHud.dismiss();
```

