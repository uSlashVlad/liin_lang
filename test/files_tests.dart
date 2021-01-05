import 'package:liin_lang/liin_lang.dart';

const fileRoot = 'lang_examples';
const List<String> fileNames = [
  'collections_and_types.liin',
  'conditions.liin',
  'files.liin',
  'hello_world.liin',
  'strings.liin',
  'vars_and_blocks.liin',
  'includes/main.liin',
  'input.liin',
];

void main() async {
  late String fn;
  for (var i = 0; i < fileNames.length - 1; i++) {
    fn = fileNames[i];
    print('Common file testing "$fn"');
    final result = await runLiin(
      filePath: '$fileRoot/$fn',
      blockPrint: true,
    );
    print('Test completed in ${result.executionTime?.inMilliseconds}ms');
  }

  fn = fileNames[fileNames.length - 1];
  print('\nInput tesing in "$fn"');
  final result = await runLiin(
    filePath: '$fileRoot/$fn',
    runInput: ['10', 'true', '"Hello World!"'],
    blockPrint: true,
  );
  print('''Test completed in ${result.executionTime?.inMilliseconds}ms
Output is ${result.output}
Blocks are ${result.blocks}
Context is ${result.context}''');

  print('Test completed. If here is no errors, it seams to be okay with liin');
}
