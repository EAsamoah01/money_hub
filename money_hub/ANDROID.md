# Run Money Core on your Android phone

## 1. One-time computer setup (Windows)

1. Install **Android Studio**: https://developer.android.com/studio
   Open it once and let the setup wizard install the **Android SDK**.
2. In Android Studio: **More Actions → SDK Manager → SDK Tools** tab → tick
   **Android SDK Command-line Tools** → Apply.
3. In PowerShell:
   ```powershell
   flutter doctor --android-licenses   # press y to accept each
   flutter doctor                      # "Android toolchain" should show a ✓
   ```

## 2. One-time phone setup

1. **Settings → About phone → tap "Build number" 7 times** → "You are now a developer".
   (On Samsung: Settings → About phone → Software information → Build number.)
2. **Settings → System → Developer options → turn on USB debugging.**
3. Plug the phone into the computer with a USB cable that carries data.
   On the phone tap **Allow** on "Allow USB debugging?" (tick *Always allow*).

## 3. Generate the icon and splash screen (after each `git pull` that changes them)

Inside the `money_hub` folder:
```powershell
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## 4. Run it

```powershell
flutter devices                 # your phone should be listed
flutter run -d <device-id>      # e.g. flutter run -d R58N12ABCDE
```
The first build takes several minutes. Later runs are much faster, and `r` hot-reloads changes while it's connected.

With RevenueCat keys (see MONETIZATION.md):
```powershell
flutter run -d <device-id> --dart-define-from-file=env.json
```

### Install a standalone copy (no cable needed afterwards)
```powershell
flutter build apk --release
flutter install -d <device-id>
```

## 5. Try the phone-only features

- **Bill reminders:** Budget → Bills → **Turn on** → Allow notifications. Add a bill due in a few days with "Remind me 1 day before". Reminders arrive at about 9:00 am (Android may delay them by a few minutes to save battery).
- **App lock:** Settings → App lock → Require unlock → confirm with your fingerprint. Close the app for 30+ seconds and reopen it.
- **Icon:** look at your home screen. On Android 13+ with *Themed icons* on, you'll see the single-colour version.

## Troubleshooting

| Problem | Fix |
|---|---|
| Phone not in `flutter devices` | Re-plug, accept the USB prompt, try another cable, set USB mode to *File transfer* |
| `Android license status unknown` | `flutter doctor --android-licenses` |
| Build error mentioning *desugaring* | Make sure you pulled the latest `android/app/build.gradle.kts` |
| `minSdk` error from a plugin | In `android/app/build.gradle.kts` set `minSdk = 23` instead of `flutter.minSdkVersion` |
| No reminders | Phone Settings → Apps → Money Core → Notifications → allowed; battery saver can delay them |

## Before publishing (covered in the launch-prep step)
- Create an **upload key** and release signing config (the build currently signs release APKs with the debug key).
- The app ID is **`com.peprahsoft.moneycore`**. It can never change after the first upload to Google Play.
