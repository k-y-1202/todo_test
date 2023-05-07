import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/close_only_dialog.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';
import 'package:todo_test/data_models/user_data/userdata.dart';
import 'package:todo_test/functions/global_functions.dart';
import 'package:todo_test/main.dart';

import 'package:todo_test/views/auth/components/auth_text_form_field.dart';
import 'package:todo_test/views/auth/password_reminder_page.dart';
import 'package:todo_test/views/bottom_navigation/bottom_navigation_page.dart';

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
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    // （1） 指定した画面に遷移する
                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(
                        // （2） 実際に表示するページ(ウィジェット)を指定する
                        builder: (context) {
                      return const PassWordReminderPage();
                    }));
                  },
                  child: const Text(
                    'パスワードを忘れた方はこちら >',
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.end,
                  ),
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
                      showToast('ユーザー登録しました！');
                      //FireStoreにuserドキュメントを作成
                      final UserData createUserData = UserData(
                        userName: '',
                        imageUrl: '',
                        userId: user.uid,
                        createdAt: Timestamp.now(),
                        updatedAt: Timestamp.now(),
                      );
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .set(createUserData.toJson());
                    } else {
                      showCloseOnlyDialog(
                          context, '予期せぬエラーがでました、再度やりなおしてください。', '会員登録失敗');
                    }
                  } on FirebaseAuthException catch (error) {
                    print(error.code);
                    if (error.code == 'invalid-email') {
                      print('メールアドレスの形式ではありません');
                      showCloseOnlyDialog(
                          context, 'メールアドレスの形式ではありません', '会員登録失敗');
                    }
                    if (error.code == 'email-already-in-use') {
                      print('既に使われているメールアドレスです');
                      showCloseOnlyDialog(
                          context, '既に使われているメールアドレスです', '会員登録失敗');
                    }
                    if (error.code == 'weak-password') {
                      print('パスワードが弱すぎるぜ');
                      showCloseOnlyDialog(context, 'パスワードが弱すぎるぜ', '会員登録失敗');
                    }
                  } catch (error) {
                    print('予期せぬエラー');
                    showCloseOnlyDialog(
                        context, '予期せぬエラーが起きたよ。やり直してね', '会員登録失敗');
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
                      //FireStoreにuserドキュメントを作成

                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update(
                        {
                          'updatedAt': Timestamp.now(),
                        },
                      );
                      // BottomNavigationPage(),
                    } else {
                      // ignore: use_build_context_synchronously
                      showCloseOnlyDialog(
                          context, '予期せぬエラーがでました、再度やりなおしてください。', 'ログイン失敗');
                    }
                  } on FirebaseAuthException catch (error) {
                    if (error.code == 'user-not-found') {
                      showCloseOnlyDialog(context, 'ユーザーが見つかりません', 'ログイン失敗');
                    } else if (error.code == 'invalid-email') {
                      showCloseOnlyDialog(
                          context, 'メールアドレスの形式ではありません', 'ログイン失敗');
                    }
                  } catch (error) {
                    showCloseOnlyDialog(
                        context, '予期せぬエラーがきたよ。$error', 'ログイン失敗');
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
