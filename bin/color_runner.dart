import 'dart:io';
import 'package:krunner/krunner.dart';
import 'svg_color_names.dart';
import 'package:regexpattern/regexpattern.dart';

String accentColor = "";

Future<void> main(List<String> arguments) async {
  // Check if already running.
  await checkIfAlreadyRunning();

  // Instantiate the plugin, provider identifiers and callback functions.
  final runner = KRunnerPlugin(
    identifier: 'tantalising.tanbir.color_runner',
    name: '/color_runner',
    matchQuery: matchQuery,
    retrieveActions: retrieveActions,
    runAction: runAction,
  );

  // Start the plugin and enter the event loop.
  await runner.init();
}

/// Check if an instance of this plugin is already running.
///
/// If we don't check KRunner will just launch a new instance every time.
Future<void> checkIfAlreadyRunning() async {
  final result = await Process.run('pidof', ['color_runner']);
  final hasError = result.stderr != '';
  if (hasError) {
    print('Issue checking for existing process: ${result.stderr}');
    return;
  }
  final output = result.stdout as String;
  final runningInstanceCount = output.trim().split(' ').length;
  if (runningInstanceCount != 1) {
    print('An instance of color_runner appears to already be running. '
        'Aborting run of new instance.');
    exit(0);
  }
}

Future<List<QueryMatch>> matchQuery(String query) async {
  accentColor = query.toLowerCase();
  final isRandomColor = randomAccentCommands.contains(accentColor);
  final isSvgColor = svgColorNames.contains(accentColor);
  final isHexColor = accentColor.isHex();
  final isValidColor = isRandomColor || isHexColor || isSvgColor;

  if (!isValidColor) return const [];
  if(isRandomColor) {
    svgColorNames.shuffle();
    accentColor = svgColorNames.first;
  }

  final matches = <QueryMatch>[];
  // Return one match.
  final colorText = accentColor[0].toUpperCase() + accentColor.substring(1);
  final subtitle = isRandomColor ? colorText : 'Set Accent Color';
  final title = isRandomColor ? "Set An Random Accent Color" : colorText;
  matches.add(QueryMatch(
    icon: 'color-profile',
    id: accentColor,
    rating: QueryMatchRating.exact,
    relevance: 1.0,
    title: title,
    properties: QueryMatchProperties(subtitle: subtitle),
  ));
  return matches;
}

Future<List<SecondaryAction>> retrieveActions() async {
  return [];
}

Future<void> runAction({
  required String matchId,
  String? actionId,
}) async {
    await Process.run('plasma-apply-colorscheme', ['--accent-color', accentColor]);
    return;
}

