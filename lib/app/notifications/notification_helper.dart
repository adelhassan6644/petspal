library notification_helper;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:huawei_push/huawei_push.dart' as huawei;
import '../../main_blocs/user_bloc.dart';
import '../../navigation/custom_navigation.dart';
import '../../navigation/routes.dart';
@pragma('vm:entry-point')
part 'firebase_notification_helper.dart';
part 'notification_operation.dart';
part 'local_notification.dart';
part 'huawei_push_notification.dart';
