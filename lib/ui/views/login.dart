import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../data/source/pocketbase/client.dart';

class Login extends StatelessWidget {
  const Login({
    super.key,
    this.authCollection = 'users',
    this.title = 'Login',
  });

  final String authCollection;
  final String title;

  @override
  Widget build(BuildContext context) {
    final pb = pocketbase$();
    final auth = pb.collection(authCollection);
    return Scaffold(
      body: FlutterLogin(
        title: title,
        theme: LoginTheme(
          pageColorLight: Theme.of(context).colorScheme.surface,
          accentColor: Theme.of(context).colorScheme.primary,
          errorColor: Theme.of(context).colorScheme.error,
          buttonStyle: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          buttonTheme: LoginButtonTheme(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        onSubmitAnimationCompleted: () {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //   builder: (context) => const DashboardScreen(),
          // ));
        },
        additionalSignupFields: const [
          UserFormField(keyName: 'name', displayName: 'Name'),
        ],
        loginAfterSignUp: true,
        initialAuthMode: AuthMode.login,
        userType: LoginUserType.email,
        onLogin: (data) async {
          try {
            final result = await auth.authWithPassword(
              data.name,
              data.password,
            );
            final user = result.record;
            auth$.value = user;
          } catch (e) {
            if (e is ClientException) {
              return e.response['message'] ?? 'Error logging in: $e';
            }
            return 'Error: $e';
          }
          return null;
        },
        onSignup: (data) async {
          try {
            final user = await auth.create(body: {
              'name': data.additionalSignupData?['name'],
              'email': data.name,
              'password': data.password,
              'passwordConfirm': data.password,
              'emailVisibility': true,
            });
            auth$.value = user;
          } catch (e) {
            if (e is ClientException) {
              return e.response['message'] ?? 'Error logging in: $e';
            }
            return 'Error: $e';
          }
          return null;
        },
        onConfirmRecover: (code, LoginData data) async {
          try {
            await auth.confirmPasswordReset(
              code,
              data.password,
              data.password,
            );
          } catch (e) {
            if (e is ClientException) {
              return e.response['message'] ?? 'Error confirming password: $e';
            }
            return 'Error: $e';
          }
          return null;
        },
        onRecoverPassword: (email) async {
          try {
            await auth.requestPasswordReset(email);
          } catch (e) {
            if (e is ClientException) {
              return e.response['message'] ??
                  'Error sending password reset: $e';
            }
            return 'Error: $e';
          }
          return null;
        },
      ),
    );
  }
}
