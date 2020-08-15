import 'package:fireflyapp/pages/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  static final String routeUri = '/settings';

  static final MapEntry<String, WidgetBuilder> route = MapEntry(
    routeUri,
    (BuildContext c) {
      return SettingsPage();
    },
  );

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _fingerprintEnabled = false;
  bool _fingerprintChangeEnabled = false;
  AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _authProvider.fingerprintLoginActivated().then((value) {
      setState(() {
        _fingerprintEnabled = value;
        _fingerprintChangeEnabled = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _buildSettings(),
    );
  }

  Widget _buildSettings() {
    return SettingsList(
      sections: [
        SettingsSection(
          title: 'Security',
          tiles: [
            SettingsTile.switchTile(
              enabled: _fingerprintChangeEnabled,
              title: 'Use fingerprint',
              leading: const Icon(Icons.fingerprint),
              switchValue: _fingerprintEnabled,
              onToggle: _handleFingerprintChange,
            ),
            SettingsTile.switchTile(
              title: 'Lock app in background',
              leading: const Icon(Icons.phonelink_lock),
              switchValue: false,
              onToggle: (bool value) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Account',
          tiles: [
            SettingsTile(
              title: 'Logout',
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.pop(context);
                _authProvider.logout();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _handleFingerprintChange(bool activated) {
    if (activated) {
      _authProvider.activateFingerprint().then((success) {
        if (success) {
          setState(() {
            _fingerprintEnabled = true;
          });
        }
      });
    } else {
      _authProvider.deactivateFingerprint();
      setState(() {
        _fingerprintEnabled = false;
      });
    }
  }
}
