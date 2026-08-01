import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/core_providers.dart';
import '../storage/hive_boxes.dart';

part 'notifications_preference_notifier.g.dart';

const pushNotificationsPreferenceKey = 'push_notifications_enabled';

@Riverpod(keepAlive: true)
class NotificationsPreferenceNotifier extends _$NotificationsPreferenceNotifier {
  @override
  bool build() {
    final box = hiveBox(ref, HiveBoxes.preferences);
    return (box.get(pushNotificationsPreferenceKey) as bool?) ?? true;
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    await hiveBox(ref, HiveBoxes.preferences).put(pushNotificationsPreferenceKey, enabled);
  }
}
