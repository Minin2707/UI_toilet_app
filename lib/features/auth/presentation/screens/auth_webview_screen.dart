import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/auth/token_storage.dart';
import '../../../../core/config/app_config.dart';
import '../../../toilets/presentation/screens/toilet_map_screen.dart';

class AuthWebViewScreen extends StatefulWidget {
  const AuthWebViewScreen({super.key});

  @override
  State<AuthWebViewScreen> createState() =>
      _AuthWebViewScreenState();
}

class _AuthWebViewScreenState
    extends State<AuthWebViewScreen> {

  final TokenStorage _tokenStorage =
      TokenStorage();

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()

          ..setJavaScriptMode(
            JavaScriptMode.unrestricted,
          )

          ..addJavaScriptChannel(
            'AuthChannel',
            onMessageReceived: (message) async {

              final token = message.message;

              // save JWT
              await _tokenStorage.saveToken(token);

              debugPrint(
                'JWT SAVED = $token',
              );

              if (!mounted) {
                return;
              }

              // navigate to map
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ToiletMapScreen(),
                ),
              );
            },
          )
          ..setNavigationDelegate(
            NavigationDelegate(

              onPageStarted: (url) {
                debugPrint('PAGE START = $url');
              },

              onPageFinished: (url) {
                debugPrint('PAGE FINISH = $url');
              },

              onWebResourceError: (error) {
                debugPrint(
                  'WEBVIEW ERROR = ${error.description}',
                );
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              '${AppConfig.instance.baseUrl}/auth.html',
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}