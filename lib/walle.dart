import 'dart:convert';
import 'dart:io' show Platform, stdout, File;

String? getHomeDir() {
  String? home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS || Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  return home;
}

dynamic fixJson(String json) {
  if (json.startsWith('[')) {
    return jsonDecode(json)[0];
  } else {
    return jsonDecode(json);
  }
}

bool inPath(String file) {
  var path = Platform.environment["PATH"]!.split(":");
  bool found = false;
  for (var i = 0; i < path.length; i++) {
    var dir = path[i];
    if (!dir.endsWith('/')) {
      dir = "$dir/";
    }
    if (found == false & File("$dir$file").existsSync()) {
      found = true;
    }
  }
  return found;
}
