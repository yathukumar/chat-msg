import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatapp/shared/utils/shared_pref.dart';
import 'package:chatapp/theme/theme.dart';
import '../../../shared/utils/snackbars.dart';
import '../service/auth_service.dart';

const _resendFactor = 5;
const _resendInitial = 60;

final resendTimerControllerProvider =
    AutoDisposeStateNotifierProvider<ResendTimerController, int>(
  (ref) => ResendTimerController(ref),
);

class ResendTimerController extends StateNotifier<int> {
  ResendTimerController(this.ref) : super(_resendInitial);

  AutoDisposeStateNotifierProviderRef ref;
  int _resendCount = 1;
  Timer _resendTimer = Timer(Duration.zero, () {});
  int get resendCount => _resendCount;

  @override
  void dispose() {
    if (_resendTimer.isActive) {
      _resendTimer.cancel();
    }
    super.dispose();
  }

  bool get isTimerActive => _resendTimer.isActive;

  void updateTimer([bool saveTimestamp = true]) {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == 0) {
        timer.cancel();
        state = _resendCount * _resendInitial * _resendFactor;
      } else {
        state -= 1;
      }
    });

    if (saveTimestamp) {
      SharedPref.instance
        ..setInt('resendTime', state)
        ..setString(
          'resendTimestamp',
          DateTime.now().millisecondsSinceEpoch.toString(),
        );

      _resendCount++;
    }
  }

  void setState(int time) {
    state = time;
  }

  void setCount(int count) {
    _resendCount = count;
  }
}

final verificationControllerProvider = Provider<VerificationController>(
  (ref) => VerificationController(ref),
);

class VerificationController {
  VerificationController(this.ref);

  ProviderRef ref;
  late String _verificationCode;

  Future<void> init(BuildContext context, String phoneNumber) async {
    final resendTime = SharedPref.instance.getInt('resendTime');
    final resendTimestamp =
        int.parse(SharedPref.instance.getString('resendTimestamp') ?? '0') ~/
            1000;
    final elapsedTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000 - resendTimestamp;
    final remainingTime = (resendTime ?? 0) - elapsedTime;

    if (resendTime == null || remainingTime < 1) {
      if (resendTime != null && elapsedTime < 3600) {
        int count = resendTime ~/ (_resendFactor * _resendInitial) + 1;

        ref.read(resendTimerControllerProvider.notifier)
          ..setCount(count)
          ..setState(count * _resendFactor * _resendInitial);
      } else {
        ref.read(resendTimerControllerProvider.notifier)
          ..setCount(1)
          ..setState(_resendInitial);
      }

      await sendVerificationCode(context, phoneNumber);
      return;
    }

    int count = resendTime ~/ (_resendFactor * _resendInitial) + 1;

    ref.read(resendTimerControllerProvider.notifier)
      ..setState(remainingTime)
      ..setCount(count)
      ..updateTimer(false);
  }

  void updateVerificationCode(String verificationCode) {
    _verificationCode = verificationCode;
    ref.read(resendTimerControllerProvider.notifier).updateTimer();
  }

  void onResendPressed(BuildContext context, String phoneNumber) async {
    await sendVerificationCode(context, phoneNumber);
  }

  Future<void> sendVerificationCode(
    BuildContext context,
    String phoneNumber,
  ) async {
    final colorTheme = Theme.of(context).custom.colorTheme;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return FutureBuilder<void>(future: () async {
          final authController = ref.read(
            authControllerProvider,
          );

          await authController.sendVerificationCode(
            context,
            phoneNumber,
            updateVerificationCode,
          );
        }(), builder: (context, snapshot) {
          String? text;
          Widget? widget;

          if (snapshot.hasError) {
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

  Future<bool> onFilled(BuildContext context, String smsCode) async {
    final authController = ref.read(authControllerProvider);
    bool verifyOtp = await authController.verifyOtp(_verificationCode, smsCode);
    if(!verifyOtp){
      showSnackBar(
        content: "OTP Invalid",
        type: SnacBarType.info, context: context,
      );
    }
    return verifyOtp;
  }
}
