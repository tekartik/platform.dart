import 'package:node_io/node_io.dart' as node;
import 'package:tekartik_platform/context.dart';

class NodeImpl implements Node {
  @override
  bool get isLinux => node.Platform.isLinux;

  @override
  bool get isMac => node.Platform.isMacOS;

  @override
  bool get isWindows => node.Platform.isWindows;

  String get _platformText {
    String platform;
    if (isLinux) {
      platform = 'linux';
    } else if (isMac) {
      platform = 'mac';
    } else if (isWindows) {
      platform = 'windows';
    }
    return platform;
  }

  @override
  String toString() => toMap().toString();

  Map toMap() {
    Map map = {};
    map['platform'] = _platformText;
    return map;
  }
}

class PlatformContextNode implements PlatformContext {
  Browser get browser => null;

  Io get io => null;

  NodeImpl _node;

  NodeImpl get node => _node ??= new NodeImpl();

  @override
  String toString() => '[node] $node';

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {'node': node.toMap()};
    return map;
  }
}

PlatformContextNode _platformContextNode;

PlatformContextNode get platformContextNode =>
    _platformContextNode ??= new PlatformContextNode();
