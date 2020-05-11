# LoadingHud

[![pub package](https://img.shields.io/pub/v/loading_hud.svg)](https://img.shields.io/pub/v/loading_hud)

A dialog with a loading indicator.

![showcase](screenshots/screen_shot.gif)

## Getting Started

### Add dependency

```yaml
dependencies:
  loading_hud: ^0.2.0
```

### Examples

```dart
var loadingHud = LoadingHud(
  context,
  cancelable: true,                  // Cancelable when pressing Android back key
  canceledOnTouchOutside: true,      // Cancelable when touch outside of the LoadingHud
  dimBackground: true,               // Dimming background when LoadingHud is showing
  hudColor: Color(0x99000000),       // Color of the ProgressHud
  indicator: DefaultLoadingIndicator(
    color: Colors.white,
  ),
  iconSuccess: Icon(                 // Success icon
    Icons.done,
    color: Colors.white,
  ),
  iconError: Icon(                   // Error icon
    Icons.error,
    color: Colors.white,
  ),
  future: loadingSomething();
);

Future<Text> loadingSomething() async {
  try {
    var data = await loadingSomthingTimeConsuming();
    return Text('That was great!');
  } catch (e) {
    throw Text('Something went wrong.');
  }
}
  
/// Show LoadingHud
loadingHud.show();

/// Dismiss LoadingHud
loadingHud.dismiss();
```

