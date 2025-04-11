import 'package:flutter/material.dart';
import 'package:caffeing/res/style/style.dart';

class NetworkStatus {
  final bool isInternetConnected;
  final bool isServerReachable;

  NetworkStatus({
    required this.isInternetConnected,
    required this.isServerReachable,
  });
}

class SocketErrorDialog {
  static SocketErrorDialog? _instance;

  factory SocketErrorDialog() {
    _instance ??= SocketErrorDialog._();
    return _instance!;
  }

  SocketErrorDialog._();

  static void show(BuildContext context, NetworkStatus networkStatus) {
    _instance?._showDialog(context, networkStatus);
  }

  static void dismiss(BuildContext context) {
    _instance?._dismissDialog(context);
  }

  void _showDialog(BuildContext context, NetworkStatus networkStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: _SocketErrorComponents(networkStatus: networkStatus),
        );
      },
    );
  }

  void _dismissDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _SocketErrorComponents extends StatelessWidget {
  final NetworkStatus networkStatus;

  const _SocketErrorComponents({required this.networkStatus});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            networkStatus.isInternetConnected
                ? Icons.bug_report
                : Icons.wifi_off_rounded,
            size: 50,
            color: AppStyles.getTheme(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              textAlign: TextAlign.center,
              networkStatus.isInternetConnected
                  ? "無法連線至伺服器\r\n請聯絡管理人員"
                  : "請檢查網路連線狀況",
            ),
          ),
        ],
      ),
    );
  }
}
