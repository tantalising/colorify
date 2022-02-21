## Compile plugin to self-contained executable

From project root folder run:

```bash
dart pub get
```

```bash
dart compile exe -o package/color_runner bin/color_runner.dart
```


## Install plugin

```bash
package/install.sh
```


## Test plugin

- Launch KRunner with `Alt` + `Space`.
- type in a color name


## Uninstall plugin

```bash
package/uninstall.sh
```


## Debug plugin

Make sure the plugin is not installed, then:

```bash
touch package/color_runner   # Create dummy package to "install".
```

```bash
package/install.sh
```

Now run the program in debug mode in your IDE, or by running `dart run
bin/color_runner.dart` and KRunner calls will connect to the debug version; add
breakpoints, inspect, etc.
