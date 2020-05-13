import 'dart:html';

void xlistDownload(String fileName, String content) {
AnchorElement tl = document.createElement('a');
  tl
  ..attributes['href'] = 'data:text/plain;charset=utf-8,' + Uri.encodeComponent(content)
  ..attributes['download'] = fileName
  ..click();
}