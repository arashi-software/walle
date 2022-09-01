import harpoon, json, os, random
from std/uri import parseUri

randomize()
let idx = rand(1..25)
let redditJsonData = getJson(parseUri"https://www.reddit.com/r/wallpaper.json?jsonp=?&show=all&limit=25")
echo redditJsonData["data"]["children"]
