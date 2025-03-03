import 'dart:developer';

import 'package:client/core/extensions/mediaquery_extensions.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/auth/view/pages/sign_up_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widget/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrHeight = context.mediaQueryHeight;
    final isLoading = ref.watch(
      authViewmodelProvider.select((value) => value?.isLoading == true),
    );
    log("SIGN IN");
    ref.listen(authViewmodelProvider, (_, next) {
      log("authViewmodelProvider listen to SignIN");
      next?.when(
        data: (data) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (_) => false,
            );
          });
        },
        error: (error, stackTrace) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });
    return Scaffold(
      appBar: AppBar(),
      body:
          isLoading
              ? const LoaderWidget()
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sign In.",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        (scrHeight * 0.03).height,
                        CustomField(
                          hintText: "Email",
                          controller: emailController,
                        ),
                        (scrHeight * 0.03).height,
                        CustomField(
                          hintText: "Password",
                          controller: passwordController,
                          isObscure: true,
                        ),
                        (scrHeight * 0.03).height,
                        AuthGradientButton(
                          text: "Sign In",
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              await ref
                                  .read(authViewmodelProvider.notifier)
                                  .login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                            } else {
                              showSnackBar(context, "Missing Fields");
                            }
                          },
                        ),
                        (scrHeight * 0.02).height,
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                const TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Pallete.gradient2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
