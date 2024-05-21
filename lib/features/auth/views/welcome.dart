import 'package:chatapp/features/auth/views/phone_verification_widget.dart';
import 'package:chatapp/features/auth/views/user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatapp/shared/widgets/buttons.dart';
import 'package:chatapp/theme/theme.dart';
import '../../../shared/models/user.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _navigateToLoginPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (builder) =>  PhoneVerification(
        isFirstPage: true,
        enableLogo: false,
        themeColor: Colors.blueAccent,
        backgroundColor: Colors.black,
        initialPageText: "Verify Phone Number",
        initialPageTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textColor: Colors.white,
        onVerification: (Phone? phone) {
          if (phone != null) {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserProfileCreationPage(
                    phone: phone,
                  ),
                ),);
          }
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).custom.colorTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
          systemNavigationBarColor: colorTheme.navigationBarColor,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/landing_img.png',
              package: 'chatapp',
              color: colorTheme.greenColor,
              width: MediaQuery.of(context).size.width * 0.70,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const SizedBox(height: 32),
            Text(
              'Welcome to Messenger',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: colorTheme.textColor2,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 52,
                vertical: 25,
              ),
              child: GreenElevatedButton(
                onPressed: () => _navigateToLoginPage(context),
                text: 'Agree and continue',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
