import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/close_only_dialog.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';
import 'package:todo_test/main.dart';

import 'package:todo_test/views/auth/components/auth_text_form_field.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Form(
        key: formKey,
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
              MarginSizedBox.smallHeightMargin,
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'パスワードを忘れた方はこちら >',
                  style: TextStyle(color: Colors.blue),
                  textAlign: TextAlign.end,
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() == false) {
                    //失敗したときに処理ストップ
                    return;
                  }
                  //成功
                  try {
                    final User? user = (await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passController.text))
                        .user;
                    if (user != null) {
                      print("ユーザ登録しました");
                    } else {
                      showCloseOnlyDialog(
                          context, '予期せぬエラーがでました、再度やりなおしてください。');
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error.code);
                    if (error.code == 'invalid-email') {
                      print('メールアドレスの形式ではありません');
                      showCloseOnlyDialog(context, 'メールアドレスの形式ではありません');
                    }
                    if (error.code == 'email-already-in-use') {
                      print('既に使われているメールアドレスです');
                      showCloseOnlyDialog(context, '既に使われているメールアドレスです');
                    }
                    if (error.code == 'weak-password') {
                      print('パスワードが弱すぎるぜ');
                      showCloseOnlyDialog(context, 'パスワードが弱すぎるぜ');
                    }
                  } catch (error) {
                    print('予期せぬエラー');
                    showCloseOnlyDialog(context, '予期せぬエラーが起きたよ。やり直してね');
                  }
                },
                child: const Text('会員登録'),
              ),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    //失敗
                    return;
                  }
                  //成功したときはログイン処理を走らせる
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final User? user = (await auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passController.text,
                    ))
                        .user;
                    if (user != null) {
                      print('ログイン成功');
                    } else {
                      showCloseOnlyDialog(
                          context, '予期せぬエラーがでました、再度やりなおしてください。');
                    }
                  } on FirebaseAuthException catch (error) {
                    if (error.code == 'user-not-found') {
                      showCloseOnlyDialog(context, 'ユーザーが見つかりません');
                    } else if (error.code == 'invalid-email') {
                      showCloseOnlyDialog(context, 'メールアドレスの形式ではありません');
                    }
                  } catch (error) {
                    showCloseOnlyDialog(context, '予期せぬエラーがきたよ。$error');
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
