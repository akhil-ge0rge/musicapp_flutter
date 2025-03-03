import 'package:client/core/extensions/mediaquery_extensions.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/auth/view/pages/sign_in_page.dart';
import 'package:client/features/auth/view/widgets/auth_gradient_button.dart';
import 'package:client/core/widget/custom_field.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
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

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          showSnackBar(context, "User created sucessfully");
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => SignInPage()));
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
              : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      (scrHeight * 0.08).height,
                      CustomField(hintText: "Name", controller: nameController),
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
                        text: "Sign Up",
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            await ref
                                .read(authViewmodelProvider.notifier)
                                .signUp(
                                  email: emailController.text,
                                  name: nameController.text,
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              const TextSpan(
                                text: "Sign In",
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
    );
  }
}
