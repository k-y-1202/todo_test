import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/custom_font_size.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('マイページ'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              print('ログアウトしたよ');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.network(
                'https://thumb.photo-ac.com/f1/f15da6cb7984cd43a6b9c3060b64675a_t.jpeg',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            MarginSizedBox.mediumHeightMargin,
            const Text(
              '名前が入ります',
              style: CustomFontSize.mediumFontSize,
            ),
            MarginSizedBox.smallHeightMargin,
            const Text('メールアドレスが入ります'),
          ],
        ),
      ),
    );
  }
}
