import 'package:permission_handler/permission_handler.dart';

class PermissionsRepository {
  /// Requests microphone and speech recognition permissions.
  /// Returns true if both permissions are granted, false otherwise.
  Future<bool> requestRequiredPermissions() async {
    // A map of the permissions we need to request.
    final permissionsToRequest = <Permission>[
      Permission.microphone,
      Permission.speech,
    ];

    // Request the permissions
    final Map<Permission, PermissionStatus> statuses =
        await permissionsToRequest.request();

    // Check if both permissions are granted.
    // The 'isGranted' getter returns true if the status is granted or limited.
    final bool isMicGranted =
        statuses[Permission.microphone]?.isGranted ?? false;
    final bool isSpeechGranted =
        statuses[Permission.speech]?.isGranted ?? false;

    return isMicGranted && isSpeechGranted;
  }
}
