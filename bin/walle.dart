#!/usr/bin/env dart
//  ___       __   ________  ___       ___       _______
// |\  \     |\  \|\   __  \|\  \     |\  \     |\  ___ \
// \ \  \    \ \  \ \  \|\  \ \  \    \ \  \    \ \   __/|
//  \ \  \  __\ \  \ \   __  \ \  \    \ \  \    \ \  \_|/__
//   \ \  \|\__\_\  \ \  \ \  \ \  \____\ \  \____\ \  \_|\ \
//    \ \____________\ \__\ \__\ \_______\ \_______\ \_______\
//     \|____________|\|__|\|__|\|_______|\|_______|\|_______|

// CC: Luke 2022

import 'package:walle/walle.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:process_run/shell.dart';

final vnum = "1.0.0";

void main(List<String> arguments) async {
  // Command line args //
  var parser = ArgParser();
  parser.addOption("sub",
      abbr: "s",
      defaultsTo: "wallpapers+wallpaper",
      help: "The subreeddits to get wallpapers from (seperated by a '+')");
  parser.addOption("flair",
      abbr: "f", help: "Only search for posts with specific a flair");
  parser.addFlag("help", abbr: "h", help: "Show this message", negatable: false,
      callback: (help) {
    if (help) {
      print(parser.usage);
      exit(0);
    }
  });  
  parser.addFlag("version", abbr: "v", help: "Show version info", negatable: false,
      callback: (version) {
    if (version) {
      print(vnum);
      exit(0);
    }
  });
  parser.addOption("palette", abbr: "p", help: "Use dye to colorize the image");
  var args = parser.parse(arguments);
  // Find images //
  print("Finding image...");
  var url = Uri.http("www.reddit.com", "/r/${args['sub']}/random.json");
  var histFile = "${getHomeDir()}/.walle.hist";
  String? img;
  while (true) {
    var postJson = fixJson(await http.read(url));
    var idx = Random().nextInt(postJson['data']['children'].length);
    if (args["flair"] != null) {
      if (postJson['data']['children'][idx]['data']["link_flair_text"] ==
              null ||
          !(postJson['data']['children'][idx]['data']["link_flair_text"]
              .contains(args['flair']))) {
        continue;
      }
    }
    img = postJson['data']['children'][idx]['data']["url_overridden_by_dest"];
    if (img == null) {
      continue;
    }
    print(img);
    var hf = File(histFile);
    hf.createSync(recursive: true);
    if ((await hf.readAsString()) == img) {
      continue;
    }
    hf.writeAsString(img);
    break;
  }
  var imgFilename = "${getHomeDir()}/walle.wall";
  var rest = img.split("/").last;
  var imageUrl = Uri.https(img.replaceAll("https://", "").split('/')[0], rest);
  print("Downloading image...");
  File(imgFilename).createSync(recursive: true);
  var shell = Shell();
  // Download image file //
  File(imgFilename).writeAsBytesSync(await http.readBytes(imageUrl));
  // Handle palettes //
  if (args["palette"] != null) {
    if (!inPath("dye")) {
      throw "Could not find dye executable in path";
    }
    await shell.run("dye -b -p ${args['palette']} $imgFilename");
    imgFilename = "${getHomeDir()}/conv-walle.png";
  }
  // Set wallpaper //
  print("Setting wallpaper...");
  await shell.run("feh --bg-scale $imgFilename");
  print("Done!");
  // Clean exit on success //
  exit(0);
}
