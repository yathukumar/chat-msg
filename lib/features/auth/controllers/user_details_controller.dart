import 'dart:async';
import 'dart:io';
import 'package:chatapp/shared/repositories/compression_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/features/auth/views/auth_complete.dart';
import 'package:chatapp/shared/models/user.dart';
import 'package:chatapp/shared/utils/abc.dart';
import 'package:chatapp/shared/utils/attachment_utils.dart';
import 'package:chatapp/shared/widgets/gallery.dart';
import 'package:chatapp/theme/theme.dart';
import '../service/auth_service.dart';

final userDetailsControllerProvider =
    StateNotifierProvider.autoDispose<UserDetailsController, File?>(
        (ref) => UserDetailsController(ref));

class UserDetailsController extends StateNotifier<File?> {
  UserDetailsController(this.ref) : super(null);

  final AutoDisposeStateNotifierProviderRef ref;
  late final TextEditingController _usernameController;

  void init() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _usernameController.dispose();
    super.dispose();
  }

  TextEditingController get usernameController => _usernameController;

  void deleteImage(BuildContext context) {
    state = null;
    Navigator.of(context).pop();
  }

  void setImageFromCamera() async {
    final image = await capturePhoto();
    if (image == null) return;
    state = await CompressionService.compressImage(image);
  }

  Future<void> setImageFromGallery(BuildContext context) async {
    if (Platform.isAndroid) {
      final file = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const Gallery(
          title: 'Pick a photo',
          returnFiles: true,
        ),
        settings: const RouteSettings(name: "/gallery"),
      ));

      state = await CompressionService.compressImage(file);
      return;
    }

    final image = await pickImageFromGallery();
    if (image == null) return;
    state = await CompressionService.compressImage(image);
  }

  void onNextBtnPressed(
    BuildContext context,
    WidgetRef ref,
    Phone phone,
  ) async {
    final colorTheme = Theme.of(context).custom.colorTheme;
    bool internetConnActive = await isConnected();

    final username = ref
        .read(userDetailsControllerProvider.notifier)
        .usernameController
        .text;

    String errorMsg = '';
    if (username.isEmpty) {
      errorMsg = 'Please type your name';
    } else if (!internetConnActive) {
      errorMsg = 'Unable to connect. Please check your '
          'internet connection and try again';
    }

    if (!mounted) return;

    if (errorMsg.isNotEmpty) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsPadding: const EdgeInsets.all(0),
            content: Text(
              errorMsg,
              style: Theme.of(context).textTheme.bodySmall!,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'OK',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: colorTheme.greenColor),
                ),
              ),
            ],
          );
        },
      );
    }

    final authController = ref.read(authControllerProvider);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return FutureBuilder<User>(
            future: authController.saveUserData(
              context,
              ref,
              username,
              phone,
              state,
            ),
            builder: (context, snapshot) {
              String? text;
              Widget? widget;

              if (snapshot.hasData) {
                text = 'You\'re all set!';
                widget = Icon(
                  Icons.check_circle,
                  color: colorTheme.greenColor,
                  size: 38.0,
                );

                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => AuthCompletePage(
                          user: snapshot.data!,
                        ),
                      ),
                      (route) => false);
                });
              } else if (snapshot.hasError) {
                text = 'Oops! an error occured';
                widget = Icon(
                  Icons.cancel,
                  color: colorTheme.errorSnackBarColor,
                  size: 38.0,
                );

                Future.delayed(const Duration(seconds: 2), () {
                  Navigator.of(context).pop();
                });
              }

              return AlertDialog(
                actionsPadding: const EdgeInsets.all(0),
                content: Row(
                  children: [
                    widget ??
                        CircularProgressIndicator(
                          color: colorTheme.greenColor,
                        ),
                    const SizedBox(
                      width: 24.0,
                    ),
                    Text(
                      text ?? 'Connecting',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 16.0),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
