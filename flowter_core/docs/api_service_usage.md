# Using `flowter_core` API Service (`ApiController`)

`flowter_core` provides a small HTTP layer in [`lib/services/api/api.dart`](../lib/services/api/api.dart). It standardizes:

- Base URL + versioned endpoint URL shape
- Default JSON headers
- Optional auth/language headers via callbacks
- A unified [`ApiResponse`](../lib/services/api/api.dart) wrapper
- Optional request/response callbacks for logging or interceptors

---

## Import

Most examples use the direct import:

```dart
import 'package:flowter_core/services/api/api.dart';
```

You can also import the services barrel if it exists in your setup:

```dart
import 'package:flowter_core/services/services.dart';
```

---

## Configure `ApiController`

Create an `ApiController` once (e.g., in your state class or app bootstrap), then reuse it.

```dart
final api = ApiController(
  baseURL: 'https://api.example.com',
  apiDefaultVersion: 1,
  getBearerToken: () => authToken, // optional
  getAcceptLanguage: () => 'en-US', // optional
  getUserType: () => 'customer', // optional
  additionalHeaders: {
    'X-App-Version': () => '1.0.0',
  },
  // Optional: provide default processors for certain response codes.
  overridenResponseProcessesByCodes: {
    401: (data) => data,
  },
);
```

### Header injection callbacks

`ApiController` can automatically attach these headers if you provide the corresponding functions:

- `Authorization: Bearer <token>` (from `getBearerToken`)
- `Accept-Language: <locale>` (from `getAcceptLanguage`)
- `User-Type: <type>` (from `getUserType`)

---

## Endpoint URL format

For both `request` and `multipartRequest`, the final URL is built as:

`$baseURL/api/v$version/$path`

Where:

- `version` is either `request(..., version: ...)` or `apiDefaultVersion`
- `path` is the `path` argument you pass to `request`

---

## Make a JSON request (`request`)

```dart
final response = await api.request(
  type: HttpRequestType.get,
  path: 'posts/1',
  // version: 2, // optional
  // headers: {'X-Trace-Id': 'abc'}, // optional extra headers
  // body: {...}, // used for POST/PUT/PATCH/DELETE in this implementation
  timeout: 30,
);
```

### `ApiResponse`

`request` returns an `ApiResponse`:

- `response.code` is the HTTP status code
- `response.data` is either JSON-decoded data (when possible) or the raw response body

To convert the response data into a typed model, use `processByCode<T>()`:

```dart
final post = response.processByCode<Map<String, dynamic>>({
  200: (data) => data as Map<String, dynamic>,
});
```

If no processor exists for `response.code` (neither in the map you pass to `processByCode` nor in `overridenResponseProcessesByCodes`), `processByCode` throws an `Exception`.

---

## Make a multipart request (`multipartRequest`)

Use `multipartRequest` for file uploads.

Requires `dart:io` for `File`:

```dart
import 'dart:io';
```

```dart
final response = await api.multipartRequest(
  type: HttpRequestType.post,
  path: 'uploads',
  files: {
    'file': File('/path/to/image.png'),
  },
  fields: {
    'title': 'My photo',
  },
);
```

It returns the same `ApiResponse` wrapper as `request`.

---

## Connectivity + error handling

Before sending, `request`/`multipartRequest` check connectivity via `ApiController.hasConnectivity()`.

```dart
final ok = await ApiController.hasConnectivity();
```

Exceptions you may see:

- `NoConnectionException` (no network interfaces detected)
- `NetworkException` (timeout/socket/handshake errors)

Both exceptions are defined in [`classes/exceptions.dart`](../lib/classes/exceptions.dart).

---

## Request/response callbacks (logging, interceptors)

`ApiController` exposes static hooks you can use for logging or intercepting traffic:

```dart
ApiController.addOnRequestCallback((path, type, headers, body) {
  // path is the full URL: $baseURL/api/v$version/$path
  debugPrint('API REQUEST ${type.name} $path');
});

ApiController.addOnResponseCallback((path, type, code, headers, body) {
  debugPrint('API RESPONSE ${type.name} $path -> $code');
});
```

This is how `flowter_core`’s built-in logging initializes API request/response logs (it masks sensitive headers like `Authorization`).

---

## Virtual response (testing/demo)

For demos or virtual flows, `virtualResponse` waits 3 seconds and then either returns `resBody` or throws `virtualException`:

```dart
final result = await api.virtualResponse(
  resBody: {'mock': true},
);
```

