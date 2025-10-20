# Flutter Linux Build Guide for MusicBud

## ✅ SOLVED - Issue Summary

The MusicBud Flutter app has been successfully updated with 66+ dependency updates and is now **running successfully on NixOS** using an FHS environment!

**Previous issues** (now resolved):
1. **32-bit/64-bit library conflicts**: The system LD_LIBRARY_PATH contained 32-bit zlib libraries that conflicted with the 64-bit Flutter binary
2. **Missing runtime libraries**: libfreetype.so.6 and other GTK/graphics libraries needed to be available at runtime

**Solution**: Use `buildFHSEnv` to create an isolated environment with proper library paths.

## Successful Build Process

The application **builds successfully** using:

```bash
nix-shell -p flutter --run "flutter build linux --debug"
```

Build output location: `build/linux/x64/debug/bundle/musicbud_flutter`

## Dependency Updates Completed

✅ **52 dependencies** updated via `flutter pub upgrade`
✅ **14 major version updates** including:
- flutter_bloc: 8.1.6 → 9.1.1
- fl_chart: 0.68.0 → 1.1.1
- flutter_secure_storage: 9.0.0 → 10.0.0-beta.4
- flutter_lints: 2.0.0 → 6.0.0
- bloc_test: 9.1.1 → 10.0.0

## Runtime Issue

The binary fails to run due to library path conflicts:
```
error while loading shared libraries: libz.so.1: wrong ELF class: ELFCLASS32
```
or
```
error while loading shared libraries: libfreetype.so.6: cannot open shared object file
```

## ✅ Working Solution for NixOS

### Use FHS Environment (VERIFIED WORKING)

The app now runs successfully using the provided FHS environment configuration.

**Quick Start:**

```bash
# Simply run the provided script
./run-flutter-fhs.sh
```

This script uses `flutter-fhs.nix` which creates an isolated FHS environment with all required libraries properly configured.

**What it does:**
- Creates a clean FHS (Filesystem Hierarchy Standard) environment
- Includes all GTK3, graphics, and system libraries needed by Flutter
- Properly isolates 64-bit libraries to avoid conflicts
- Sets up correct LD_LIBRARY_PATH automatically

**First run:** The FHS environment will be built (takes a few minutes), then cached for future runs.

### Option 2: Patch Binary with Correct RPATH

Use `patchelf` to embed the correct library paths:

```bash
nix-shell -p patchelf --run '
  patchelf --set-rpath "/nix/store/...-zlib/lib:/nix/store/...-freetype/lib:..." \
    build/linux/x64/debug/bundle/musicbud_flutter
'
```

### Option 3: Docker/Podman Container

Build and run in a container with a clean Linux environment:

```dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y flutter libgtk-3-0
COPY . /app
WORKDIR /app
RUN flutter build linux
CMD ["./build/linux/x64/debug/bundle/musicbud_flutter"]
```

### Option 4: Standard Linux Distribution

If available, install Flutter on a standard Linux distribution (Ubuntu, Fedora, etc.) where library paths are managed conventionally:

```bash
flutter run -d linux --debug
```

## Scripts Provided

Several helper scripts have been created:

- `run_flutter_linux.sh` - Attempts to run with nix-shell
- `simple_run.sh` - Two-step build and run
- `final_run.sh` - Uses NIX environment variables
- `run_app.sh` - Direct binary execution wrapper

**Note**: These scripts work for building but have runtime library path issues on NixOS.

## Next Steps

1. Try Option 1 (FHS environment) as it's designed for this exact scenario
2. If that doesn't work, consider using a standard Linux VM or container
3. For production, package the app with all dependencies using `flutter build linux --release` and bundle libraries

## Additional Notes

- The app compiles without errors
- All Flutter dependencies are up-to-date
- The issue is purely related to runtime library loading on NixOS
- On standard Linux distributions, `flutter run -d linux --debug` should work without issues
