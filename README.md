# Telegram Info Sticker Importer

Move stickers from VK and LINE to Telegram

## Building

### Setting up SDK

1. Get Flutter SDK from [the official website](https://flutter.dev/docs/get-started/install)
2. Run `flutter doctor` and make sure Android toolchain is working, you might need to accept licenses and install Android Studio for that.

### Generating the APKs

3. [Prepare signing keys](#prepare-signing-keys)
4. Grab all dependencies by `flutter pub get`
5. Run `flutter build apk --release`
6. Grab the files from `/build/app/outputs/apk/release`

## Prepare signing keys

### If you are from Telegram Info org

-   run `git submodule update --init --recursive`

### If you are building this package for yourself

1. Put a .jks key in
2. Create a `secrets` folder in root
3. Put your `android-sign-key.jks` into `secrets`
4. Create a `passwords.properties` file in `secrets` and put `releasePassword=yourpassword` into it
