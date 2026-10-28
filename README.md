# Mars Rover Flutter

Flutter port of the native Android Mars Rover app in `MarsRoverApp` directory.

<img width="400" height="820" alt="Simulator Screenshot - iPhone 16 Pro - 2026-10-28 at 10 50 45" src="https://github.com/user-attachments/assets/a644852d-494e-48e8-937c-fe6907aebddf" />
<img width="400" height="820" alt="Simulator Screenshot - iPhone 16 Pro - 2026-10-28 at 10 50 55" src="https://github.com/user-attachments/assets/0e7cbbb6-f69e-4d37-b663-5e99342b1ad7" />


## Features

- NASA header, rover cards, and the same local banner images as the Android app.
- Rover launch/landing dates, photo totals, and available camera counts from Mars Vista.
- Portrait list and two-column landscape layout.
- Rover details with a date picker and a two-column photo grid.
- Pagination, loading/empty/error states, retry, and remote image loading/error states.
- System light/dark modes using the existing indigo/orange palette.

## Local Configuration

Copy `config/example.json` to `config/local.json` and enter your Mars Vista API key:

```json
{
  "MARS_VISTA_BASE_URL": "https://api.marsvista.dev/",
  "MARS_VISTA_API_KEY": "your_key_here"
}
```

`config/local.json` is ignored by Git and is not declared as an app asset. Dart reads these values at compile time using `String.fromEnvironment`, the Flutter equivalent of Android's `BuildConfig`. Build-time configuration keeps the key out of source control, but a key included in a client build can still be extracted from the app.

The local key from the native project was reused during this port when available. Missing/invalid keys produce a configuration/authorization message without exposing the key or raw exceptions.

## Run

```bash
flutter pub get
flutter run --dart-define-from-file=config/local.json
```

In Android Studio, select the **Mars Rover** run configuration. For an existing Flutter run configuration, add `--dart-define-from-file=config/local.json` to **Additional run args**. A full restart is required after changing Dart defines.

```bash
flutter analyze
flutter build apk --debug --dart-define-from-file=config/local.json
```

## Structure

```text
lib/
  core/config/          Compile-time configuration
  data/marsvista/       HTTP service and typed JSON DTOs
  data/repositories/    DTO-to-domain mapping and rover cache
  domain/models/       Immutable rover/photo/error models
  domain/repositories/ Repository contract
  domain/usecases/     Get rovers and paginated photos
  presentation/common/ Shared states, date formatting, and widgets
  presentation/rovers/ Rover list and controller
  presentation/detail/ Photo browsing and controller
  presentation/theme/  Material 3 light/dark themes
```

Dependencies are assembled in `main.dart` and passed through constructors. Controllers expose immutable states through `ChangeNotifier`; widgets own and dispose them. HTTP calls use `package:http` with a persistent client and a 30-second timeout. Debug logging prints request paths, status codes, and timing only; credentials and response bodies are never logged.

The API uses the documented JSON:API `data`/`attributes` envelopes. Single-rover requests supply camera relationships, and photo requests filter the selected day with `date_min`/`date_max`. Photo requests are paginated in batches of 50. Dates initially default to today, matching the Android app; historical rovers usually need an earlier date selected.

No new automated tests were added, per the existing project direction. The generated counter-app test was removed because its screen no longer exists.

API references: [Rovers](https://marsvista.dev/docs/reference/rovers), [Photos](https://marsvista.dev/docs/reference/photos).
