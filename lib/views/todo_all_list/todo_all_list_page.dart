import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_test/common_widget/confirm_dialog.dart';
import 'package:todo_test/common_widget/margin_sizedbox.dart';
import 'package:todo_test/data_models/todo/todo.dart';
import 'package:todo_test/data_models/user_data/userdata.dart';
import 'package:todo_test/functions/global_functions.dart';
import 'package:todo_test/views/todo_all_list/add_task/add_task_page.dart';

class TodoAllListPage extends StatelessWidget {
  const TodoAllListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('みんなのタスク')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTaskPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('todos')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            ///AsyncSnapshot = ⭕️ ~ ⭕️
            //////QuerySnapshot = 💎 ~ 💎
            //////QueryDocumentSnapshot = 🐶 ~ 🐶
            //////DocumentSnapshot = ⭐️⭐️
            //////Map={ 'key':value,'key':value,'key':value,}
            ///⭕️ //接続情報などを付随してあげてる
            ///💎 QuerySnapshot<Map<String, dynamic>
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///},
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///},
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///💎,
            ///⭕️

            if (snapshot.hasData == false) {
              return const SizedBox.shrink();
            }

            final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                snapshot.data!;

            ///💎
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///},
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///},
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///💎,
            final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData =
                querySnapshot.docs;

            /// [
            ///🐶
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///🐶,
            ///🐶
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///🐶,
            ///🐶
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///🐶,
            ///🐶
            ///{
            /// 'taskName':'タスク',
            /// 'userId':'投稿者ID',
            ///}
            ///🐶,
            /// ],
            ///
            /// //目標は下の形
            /// [{},{},{},{}]
            /// [
            /// 🐶{}🐶,
            /// 🐶{}🐶,
            /// 🐶{}🐶,
            /// 🐶{}🐶,
            /// ]
            return ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot<Map<String, dynamic>>
                      queryDocumentSnapshot = listData[index];

                  ///🐶{}🐶
                  Map<String, dynamic> mapData = queryDocumentSnapshot.data();
                  Todo todo = Todo.fromJson(mapData);

                  ///required String taskName,
                  // required String userId, //投稿者のユーザーID
                  // @TimestampConverter() required Timestamp createdAt,
                  // @TimestampConverter() required Timestamp updatedAt,

                  ///{
                  /// 'taskName':'タスク',
                  /// 'userId':'投稿者ID',
                  ///}
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(todo.userId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                userSnapshot) {
                          if (userSnapshot.hasData == false) {
                            return Container();
                          }
                          final DocumentSnapshot<Map<String, dynamic>>
                              documentSnapshot = userSnapshot.data!;
                          final Map<String, dynamic> userMap =
                              documentSnapshot.data()!;
                          final UserData postUser = UserData.fromJson(userMap);
                          return ListTile(
                            onTap: () {},
                            leading: (postUser.imageUrl != '')
                                ? ClipOval(
                                    child: Image.network(
                                      postUser.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                :
                                //imageUrlが空文字だったら
                                ClipOval(
                                    child: Image.asset(
                                      'assets/images/default_user_icon.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            title: Text(todo.taskName),
                            subtitle: Row(
                              children: [
                                Text(postUser.userName),
                                MarginSizedBox.smallWidthMargin,
                                Text(
                                  todo.createdAt
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                ),
                              ],
                            ),
                            trailing: (todo.userId ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? IconButton(
                                    onPressed: () {
                                      showConfirmDialog(
                                          context: context,
                                          text: '本当に削除しますか？',
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await FirebaseFirestore.instance
                                                .collection('todos')
                                                .doc(todo.todoId)
                                                .delete();
                                            showToast('削除成功');
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          );
                        }),
                  );
                });
          }),
    );
  }
}
