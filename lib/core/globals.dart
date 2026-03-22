import 'package:flutter/material.dart';

// 全局多选状态通知器
final ValueNotifier<bool> globalMultiSelectNotifier = ValueNotifier(false);

// 全局相册刷新通知器
final ValueNotifier<bool> globalAlbumRefreshNotifier = ValueNotifier(false);
