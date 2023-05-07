import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/custom_font_size.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';
import 'package:todo_test/views/my_page/components/blue_button.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    String? myUserEmail = FirebaseAuth.instance.currentUser!.email;

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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc('80Tori0iCYjjQd9ecQ0H')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
                    snapshot.data;
                final Map<String, dynamic>? userData = documentSnapshot!.data();

                ///List=[]
                ///Map={}
                ///DocumentSnapshot = ⭐️⭐️
                ///AsyncSnapshot = ⭕️⭕️
                ///⭕️
                ///⭐️
                ///{
                /// 'userName':'yoshida',
                /// 'imageUrl':'ここにUrlが入っている',
                ///}
                ///⭐️,
                ///接続情報を表すデータとか入ってるよ
                ///⭕️
                ///userData ==Map
                /// userData ={
                /// 'userName':'yoshida',
                /// 'imageUrl':'ここにUrlが入っている',
                /// }
                return Column(
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
                    Text(
                      userData!['userName'],
                      style: CustomFontSize.mediumFontSize,
                    ),
                    MarginSizedBox.smallHeightMargin,
                    Text(
                      ///三項演算子
                      (myUserEmail != null) ? myUserEmail : '',
                    ),
                    MarginSizedBox.bigHeightMargin,
                    BlueButton(
                      buttonText: 'メールアドレス変更',
                      onBlueButtonPressed: () {
                        print('メールアドレス変更');
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'パスワード変更',
                      onBlueButtonPressed: () {
                        print('パスワード変更');
                      },
                    ),
                    MarginSizedBox.smallHeightMargin,
                    BlueButton(
                      buttonText: 'プロフィール編集',
                      onBlueButtonPressed: () {
                        print('プロフィール編集');
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
