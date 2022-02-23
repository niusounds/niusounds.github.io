import 'dart:io';

Future<void> main(List<String> args) async {
  await executeCommand('flutter', ['build', 'web']);

  final buildRootDir = Directory('build/web');
  if (!(await buildRootDir.exists())) {
    print('${buildRootDir.path} directory not found.');
    return;
  }

  final deployRootDir = Directory('niusounds.github.io');
  if (!(await deployRootDir.exists())) {
    print('${deployRootDir.path} directory not found.');
    return;
  }

  // clean deploy dir
  await for (final entry in deployRootDir.list()) {
    if (entry.path.endsWith('.git')) continue;
    await entry.delete(recursive: true);
  }

  // move files
  await for (final entry in buildRootDir.list()) {
    final newPath = entry.path.replaceFirst(
      buildRootDir.path,
      deployRootDir.path,
    );
    await entry.rename(newPath);
  }
}

Future executeCommand(String command, List<String> args) async {
  final process = await Process.run(command, args);
  if (process.exitCode != 0) {
    throw Exception('$command ${args.join(' ')} failed!');
  }
}
