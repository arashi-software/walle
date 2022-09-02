import httpclient, json, os, strutils
from osproc import execCmdEx

var subreddit = "wallpaper"
if paramCount() >= 1:
  case paramStr(1):
    of "--help", "-h":
      echo "Usage:\n\twalle [-h, --help | <subreddit>]"
      quit 0
    else:
      subreddit = paramStr(1).replace("r/", "")

var redditJsonData: JsonNode
var c = newHttpClient()
echo "Finding random wallpaper..."
while true:
  redditJsonData = parseJson(c.getContent(
      "https://www.reddit.com/r/" & subreddit & "/random.json"))[0]
  var url = redditJsonData["data"]["children"][0]["data"]{
      "url_overridden_by_dest"}.getStr()
  if url == "" or url == "null":
    continue
  else:
    break

let img = redditJsonData["data"]["children"][0]["data"]{
      "url_overridden_by_dest"}.getStr()
echo "Downloading image..."
let imgLen = img.split(".").len
let fileExt = img.split(".")[imgLen - 1]
let fname = getCacheDir() / ".wall." & fileExt
removeFile(fname)
try:
  c.downloadFile(img, fname)
except:
  echo "Failed to download image, try running walle again"
if execCmdEx("feh --help")[1] == 1:
  echo "Could not find feh to set background..."
  echo "You can manually set the background as the file " & fname
else:
  echo "Setting background with feh..."
  discard execShellCmd("feh --bg-scale " & fname)
  echo "Add the following command to your systems autostart file"
  echo "feh --bg-scale " & fname




