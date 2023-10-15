import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:services/cubit/AppCubit.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/chatsScreens/messageScreen.dart';
import 'package:services/moduels/payment/pages/return_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/component_screen.dart';
import '../../../core/constance/Apicontest.dart';
import 'auth_screen.dart';

class VisaScreen extends StatefulWidget {
  static const String routeName = 'VisaScreen';

   VisaScreen({Key? key,required this.model}) : super(key: key);
    UserModel model;
  @override
  State<VisaScreen> createState() => _VisaScreenState();
}

class _VisaScreenState extends State<VisaScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String extractSuccessValueFromURL(String url) {
    final uri = Uri.parse(url);
    final queryParams = uri.queryParameters;
    final successValue = queryParams['success'];

    print("{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{object}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
    print(successValue);

    if (successValue == "true") {
      Future.delayed(const Duration(seconds: 5), () {
AppCubit.get(context).deletepayment(widget.model.uId!);
AppCubit.get(context).sendmessage(text: 'تم الدفع بنجاح', R_uId: widget.model.uId!, datetime:  DateTime.now().toString(), price: '');
navigateAndFinish(context, MessageScreen(R_userdata: widget.model,));
      });
    } else if (successValue == "false") {
      Future.delayed(const Duration(seconds: 5), () {

        navigateAndFinish(context, MessageScreen(R_userdata: widget.model,));
      });
    }
    return successValue ?? '';
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              paymentExitApp(context);
            },
            icon: const Icon(
              Icons.exit_to_app,
            ),
          )
        ]),
        body: WebView(
          initialUrl: ApiContest.visaUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print(
                "{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{object}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}");
            extractSuccessValueFromURL(url);

            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        ),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      },
    );
  }

  // to exit from app
  void paymentExitApp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            'Are you sure completed the pay',
            style: TextStyle(
              fontSize: 14.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                navigateAndFinish(
                  context,
                  AuthScreen( model: widget.model, price: '',),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
