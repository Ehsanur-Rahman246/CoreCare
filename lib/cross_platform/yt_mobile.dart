import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

void registerYT(String videoId) {}

Widget ytWidget(String videoId) => YoutubePlayerScaffold(
    builder: (context, player) => AspectRatio(aspectRatio: 16/7, child: player,),
    controller: YoutubePlayerController.fromVideoId(videoId: videoId, params: const YoutubePlayerParams(showControls: true, showFullscreenButton: true, playsInline: true)),
);