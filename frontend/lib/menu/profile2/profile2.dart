import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/menu/profile2/edit_profile2.dart';
import 'package:frontend/utils/authentication.dart';
import 'package:intl/intl.dart';

import '../../model/account.dart';
import '../../model/post.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Account myAccount = Authentication.myAccount!;

  List<Post> postList = [
    Post(
        id: '1',
        content: '初めまして',
        postAccountId: '1',
        createdTime: Timestamp.now()
    ),
    Post(
        id: '2',
        content: '初めまして2',
        postAccountId: '1',
        createdTime: Timestamp.now()
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,  //背景透明
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('', style: TextStyle(color: Colors.black)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(right: 15, left: 15, top: 20),
                  //color: Colors.red.withOpacity(0.3),
                  height: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 32,
                                foregroundImage: NetworkImage(myAccount.imagePath),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(myAccount.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  Text(myAccount.userId, style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                          OutlinedButton(
                              onPressed: () async{
                                var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountPage()));
                                if(result == true){
                                  setState((){
                                    myAccount = Authentication.myAccount!;
                                  });
                                }
                                },
                              child: Text('編集')
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(myAccount.selfIntroduction),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: Colors.blue, width: 3,
                      ))
                  ),
                  child: Text('投稿', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                ),
                Expanded(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(), // 投稿エリア、ノースクロール
                      itemCount: postList.length,
                      itemBuilder: (context, index){
                        return Container(
                          decoration: BoxDecoration(  //一番上の投稿には上下、それ以降は下だけ線で囲う
                            border: index == 0 ? Border(
                              top: BorderSide(color: Colors.grey, width: 0),
                              bottom: BorderSide(color: Colors.grey, width: 0),
                            ) : Border(bottom: BorderSide(color: Colors.grey, width: 0),),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                foregroundImage: NetworkImage(myAccount.imagePath),
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, //左寄り
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        // ↑ 子たちの間に空きスペースを均等に置く。開始/終了にはスペースを設けない。
                                        // 下のRowとTextに適応している。２つしかないため両端に寄る
                                        children: [
                                          Row(
                                            children: [
                                              Text(myAccount.name, style: TextStyle(fontWeight: FontWeight.bold),),
                                              Text(myAccount.userId, style: TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                          Text(DateFormat('M/d/yy').format(postList[index].createdTime!.toDate())),
                                        ],
                                      ),
                                      Text(postList[index].content),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                        // ↑ TimeLinePageのタイムライン表示の部分
                      }
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
