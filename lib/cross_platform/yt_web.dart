import 'package:flutter/material.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

void registerYT(String videoId){
  final id = 'yt-$videoId';
  ui.platformViewRegistry.registerViewFactory(id, (int i){
    final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
      ..src = 'https://www.youtube-nocookie.com/embed/$videoId'
          '?rel=0&showinfo=0&enablejsapi=1&playsinline=1'
      ..width = '100%'
      ..height = '100%'
      ..allowFullscreen = true
      ..setAttribute('referrerpolicy', 'strict-origin-when-cross-origin')
      ..setAttribute('allow', 'accelerometer; autoplay; clipboard-write; '
          'encrypted-media; gyroscope; picture-in-picture; web-share',);
    (iframe as web.HTMLElement).style.border = 'none';
    return iframe;
  });
}
Widget ytWidget(String videoId) => AspectRatio(aspectRatio: 16 /7,child: HtmlElementView(viewType: 'yt-$videoId'),);
