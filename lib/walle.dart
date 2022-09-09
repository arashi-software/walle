import 'dart:convert';
import 'dart:io' show Platform, stdout;

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
