# Using `AppFramework.appInitializer`

`AppFramework.appInitializer` is the recommended entry point when you build an app on **flowter_core**. It wraps `runApp` in a guarded zone, runs a fixed bootstrap sequence, then mounts a `MaterialApp` that wires in the framework’s template navigation, theming, scaling, debugging tools, and other shared widgets.

Import the initializer library (it is not re-exported from a single barrel in all setups—use the path below):

```dart
import 'package:flowter_core/app_initializer/app_initializer.dart';
import 'package:flowter_core/template/template.dart';
```

## What to do in `main`

Call **`AppFramework.appInitializer`** instead of calling `runApp` yourself. Do not call `WidgetsFlutterBinding.ensureInitialized()` before it unless you have a specific reason—the internal `appInit` step does that for you.

```dart
void main() {
  AppFramework.appInitializer(
    customization: /* AppCustomization — see below */,
    onAppStartInitializing: (env) async {
      // Optional. Runs before internal initialization (see lifecycle below).
    },
    onAppInitialized: (env) async {
      // Optional. Runs after internal init, before `runApp`.
    },
  );
}
```

## Parameters

| Parameter | Purpose |
|-----------|---------|
| **`customization`** (required) | An `AppCustomization` instance (same library as [`AppFramework`](../lib/app_initializer/app_initializer.dart)): themes, template setup, optional Firebase/notifications, Windows window settings, error hooks, etc. |
| **`onAppStartInitializing`** | Async callback invoked **first**, with the same `AppCustomization` instance. Flutter bindings are **not** initialized yet unless you call `WidgetsFlutterBinding.ensureInitialized()` yourself here. |
| **`onAppInitialized`** | Async callback invoked **after** the framework’s internal `appInit` (Hive, logs, DB FFI on desktop, notifications on mobile, error widget wiring, etc.) and **before** `runApp`. |

## Lifecycle order

1. `appCustomization` is stored on `AppFramework`.
2. `onAppStartInitializing?.call(customization)`
3. Internal **`appInit(customization)`**, which among other things: `WidgetsFlutterBinding.ensureInitialized()`, app lifecycle observer, `Hive.initFlutter(filesDir)`, dev stage controller, desktop SQLite FFI, logging, optional notifications (non-Windows), optional Windows `window_manager`, `ErrorWidget.builder` integration, optional Arabic/Persian digit conversion for text fields.
4. `onAppInitialized?.call(customization)`
5. `runApp(_AppBaseWidget(...))` — your UI is a `MaterialApp` whose `home` uses `TemplateController` and the rest of the stack (`PreferredScreen`, `PublicListener`, `DebuggerConsole`, `Scaling`, `NoScroller`, etc.).

## Required `AppCustomization` fields

At minimum you must supply:

- **`templateCustomization`** — [`TemplateCustomization`](../lib/template/template.dart): `builder`, `topPadding`, `bottomPadding`, and `initTemplateData` (returns the first `TemplateData` for the home page).
- **`lightTheme`** and **`darkTheme`** — `ThemeData` for light and dark mode; `BrightnessController` drives `themeMode`.

All other `AppCustomization` fields are optional (Google Maps key, analytics, `filesDir` for Hive + log paths, `notificationSettings`, `windowsPlatformSettings`, `onErrorThrown`, `errorWidgetBuilder`, `defaultFontFamily`, `appScale`, `noScrollbar`, `arabicIndicAndPersianNumbersToEnglishNumbers`, etc.). Set **`filesDir`** to a stable subdirectory name if you rely on file logging or want Hive under a predictable folder.

## Error handling

The initializer runs the async body inside **`runZonedGuarded`**. Uncaught errors in that zone are passed to **`customization.onErrorThrown`** when it is non-null.

## Static accessors after startup

- **`AppFramework.appCustomization`** — the `AppCustomization` you passed in (available after initialization begins).
- **`AppFramework.updateState`** — assigned to the root state’s `setState`; framework code can trigger a full root rebuild when needed.

## Related source

- Library: [`app_initializer.dart`](../lib/app_initializer/app_initializer.dart) (`AppFramework`, `AppCustomization`, `NotificationSettingsEnvironment`, `WindowsPlatformSettings`)
- Bootstrap and root UI are implemented in the `part` files next to it (`_app_init.dart`, `_base_widget.dart`, etc.)
- Template stack: [`template.dart`](../lib/template/template.dart) (`TemplateController`, `TemplateData`, `TemplateCustomization`)

For navigation and page structure, see **`TemplateController`** and **`TemplateData`** in the template library once `AppCustomization.templateCustomization` is configured.
