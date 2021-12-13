import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(
      'search-root',
      abbr: 'r',
      valueHelp:
          'The root of the directory where the theme_config files will be searched',
      defaultsTo: '.',
    )
    ..addOption(
      'search-depth',
      abbr: 'd',
      valueHelp: 'The depth where the theme_config files will be searched',
      defaultsTo: '3',
    )
    ..addOption('theme',
        abbr: 't',
        valueHelp: 'The theme that will be set',
        allowed: [
          'dark',
          'light',
          null
        ],
        allowedHelp: {
          'dark': 'Dark theme',
          'light': 'Light theme',
          null: 'Listen for themes on stdin',
        });
  final result = parser.parse(arguments);
  final rootDir = Directory(result['search-root']);
  final depth = int.parse(result['search-depth']);
}

enum Theme {
  dark,
  light,
}

String _themeToString(Theme theme) {
  switch (theme) {
    case Theme.dark:
      return 'dark';
    case Theme.light:
      return 'light';
    default:
      return null;
  }
}

Theme _themeFromString(String s) {
  switch (s) {
    case 'dark':
      return Theme.dark;
    case 'light':
      return Theme.light;
    default:
      return null;
  }
}

Future<void> changeTheme(Directory root, int depth, Theme theme) {
  final themeable = _findThemeable(root, depth).map(Themeable.fromDir);
  themeable.listen(
    (t) async {
      if (await t.getCurrentTheme() != theme) {
        // todo
        await t.setCurrentTheme(theme);
      }
    },
  );
}

class Themeable {
  final File themeConfig;
  final File currentTheme;
  final Directory root;

  const Themeable(
    this.themeConfig,
    this.currentTheme,
    this.root,
  );

  static Themeable fromDir(Directory root) => Themeable(
        File(p.join(root.path, 'theme_config')),
        File(p.join(root.path, '.current_theme')),
        root,
      );

  Future<Theme> getCurrentTheme() async {
    if (!await currentTheme.exists()) {
      return null;
    }
    final themeString = await currentTheme.readAsString();
    return _themeFromString(themeString.trim());
  }

  Future<void> setCurrentTheme(Theme theme) async {
    assert(theme != null);
    final themeString = _themeToString(theme);
    await currentTheme.writeAsString(themeString);
  }
}

Stream<Directory> _findThemeable(Directory root, int depth,
    [StreamController<Directory> controller]) {
  controller ??= StreamController<Directory>();
  final themeConfig = File(p.join(root.path, 'theme_config'));

  themeConfig.exists().then((exists) {
    if (exists) {
      controller.add(root);
    }
  });

  if (depth <= 0) {
    return controller.stream;
  }

  final dirs = root
      .list()
      .where(
        (e) => e is Directory,
      )
      .cast<Directory>();
  dirs.listen(
    (d) => _findThemeable(d, depth - 1, controller),
  );
  return controller.stream;
}
