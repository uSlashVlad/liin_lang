import 'dart:io';
import 'dart:convert';
import 'line_parser.dart';
import 'funcs.dart';
import 'colors.dart';

final httpClient = HttpClient();

int includeCount = 0;
const includeMaxCount = 1000;

/// Method for processing [include] setting
Future<List<Map<String, dynamic>>?> includeLines(String path) async {
  try {
    // Max include count here is against stack overflow and recursive includings
    if (includeCount < includeMaxCount) {
      path = getFilePath(path);
      // print(path);
      final f = File(path);
      if (f.existsSync()) {
        // If it is local path, it includes local file
        includeCount++;
        return await defineMultiline(f.readAsLinesSync());
      } else {
        // If here is no such local file, it tries to inclides file from the internet
        final req = await httpClient.getUrl(Uri.parse(path));
        final res = await req.close();
        final fileLines =
            (await utf8.decoder.bind(res).toList())[0].split('\n');
        lprint('Asset loaded with code ${res.statusCode}');
        if (fileLines.isNotEmpty) {
          includeCount++;
          return await defineMultiline(fileLines);
        } else {
          lprint('Can\'t find any file with name "path". Skipping...');
        }
      }
    } else {
      print(error(
          'You can\'t do include more than $includeMaxCount times. Exiting...'));
      exit(2);
    }
  } catch (e) {
    print(error('Critical error while including file. Skipping...\n$e'));
  }
  return null;
}
