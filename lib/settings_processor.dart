import 'dart:io';
import 'dart:convert';
import 'line_parser.dart';
import 'funcs.dart';
import 'colors.dart';

final httpClient = HttpClient();

int includeCount = 0;
const includeMaxCount = 1000;

Future<List<Map<String, dynamic>>> includeLines(String path) async {
  try {
    if (includeCount < includeMaxCount) {
      path = getFilePath(path);
      // print(path);
      final f = File(path);
      if (f.existsSync()) {
        includeCount++;
        return await defineMultiline(f.readAsLinesSync());
      } else {
        final req = await httpClient.getUrl(Uri.parse(path));
        final res = await req.close();
        final fileLines =
            (await utf8.decoder.bind(res).toList())[0].split('\n');
        lprint('Asset loaded with code ${res.statusCode}');
        if (fileLines.isNotEmpty) {
          includeCount++;
          return await defineMultiline(fileLines);
        } else {
          lprint('Incorrect file for including. Skipping...');
        }
      }
    } else {
      lprint(error('You can\'t do include more than $includeMaxCount times'));
      exit(2);
    }
  } catch (e) {
    lprint(error('Error while including file. Skipping...\n$e'));
  }
  return null;
}
