import 'package:flutter/material.dart';
import 'package:brother_admin_panel/utils/keyboard_handler.dart';

/// مراقب أحداث لوحة المفاتيح
/// Keyboard event monitor widget
class KeyboardMonitor extends StatefulWidget {
  final Widget child;
  final bool showDebugInfo;
  final bool enableKeyLogging;

  const KeyboardMonitor({
    Key? key,
    required this.child,
    this.showDebugInfo = false,
    this.enableKeyLogging = false,
  }) : super(key: key);

  @override
  State<KeyboardMonitor> createState() => _KeyboardMonitorState();
}

class _KeyboardMonitorState extends State<KeyboardMonitor> {
  final List<String> _keyLog = [];
  Map<String, dynamic> _keyboardInfo = {};

  @override
  void initState() {
    super.initState();
    _updateKeyboardInfo();
  }

  void _updateKeyboardInfo() {
    setState(() {
      _keyboardInfo = KeyboardHandler.getKeyboardInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: Stack(
        children: [
          widget.child,
          if (widget.showDebugInfo) _buildDebugOverlay(),
        ],
      ),
    );
  }

  Widget _buildDebugOverlay() {
    return Positioned(
      top: 50,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Keyboard Info',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            ..._keyboardInfo.entries.map((entry) => Text(
                  '${entry.key}: ${entry.value}',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                )),
            if (widget.enableKeyLogging && _keyLog.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Recent Keys:',
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
              ..._keyLog.take(5).map((key) => Text(
                    '• $key',
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (widget.enableKeyLogging) {
      setState(() {
        _keyLog.insert(0, '${event.runtimeType}: ${event.physicalKey}');
        if (_keyLog.length > 10) {
          _keyLog.removeLast();
        }
      });
    }

    _updateKeyboardInfo();
  }
}

/// زر لإعادة تعيين حالة لوحة المفاتيح
/// Button to reset keyboard state
class KeyboardResetButton extends StatelessWidget {
  const KeyboardResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        KeyboardHandler.resetKeyboardState();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keyboard state reset'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: const Text('Reset Keyboard'),
    );
  }
}

/// معلومات لوحة المفاتيح
/// Keyboard information widget
class KeyboardInfoWidget extends StatefulWidget {
  const KeyboardInfoWidget({Key? key}) : super(key: key);

  @override
  State<KeyboardInfoWidget> createState() => _KeyboardInfoWidgetState();
}

class _KeyboardInfoWidgetState extends State<KeyboardInfoWidget> {
  Map<String, dynamic> _info = {};

  @override
  void initState() {
    super.initState();
    _updateInfo();
  }

  void _updateInfo() {
    setState(() {
      _info = KeyboardHandler.getKeyboardInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Keyboard Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: _updateInfo,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._info.entries.map((entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
            const KeyboardResetButton(),
          ],
        ),
      ),
    );
  }
}
