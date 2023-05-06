import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';

import 'package:todo_test/views/auth/components/auth_text_form_field.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTextFormField(
                controller: emailController,
                label: 'メールアドレス',
              ),
              MarginSizedBox.smallHeightMargin,
              AuthTextFormField(
                controller: passController,
                label: 'パスワード',
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //成功
                  } else {
                    //失敗
                  }
                },
                child: const Text('会員登録'),
              ),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    //成功
                  } else {
                    //失敗
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text(
                  'ログイン',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
