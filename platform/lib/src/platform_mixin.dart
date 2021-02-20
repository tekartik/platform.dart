import 'package:tekartik_platform/context.dart';

mixin PlatformMixin implements Platform {
  Map<String, dynamic> getPlatformInfoMap([Map<String, dynamic>? map]) {
    map ??= <String, dynamic>{};
    return map;
  }
}
