import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:services/components/components.dart';

import 'package:services/cubit/AppCubit.dart';
import 'package:services/layout/todo_layout.dart';
import 'package:services/model/UserModel.dart';
import '../../cubit/states.dart';
import '../../model/message_model.dart';

class MessageScreen extends StatefulWidget {
  MessageScreen({super.key, required this.R_userdata});

  final UserModel R_userdata;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool payment = false;
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Scroll to the bottom when the widget is built
  }

  @override
  Widget build(BuildContext context) {
    var c = AppCubit.get(context);
    return Builder(
      builder: (BuildContext context) {
        return BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is GetMessageSuccessState) {
              if (c.messages.isNotEmpty) {
                c.messages.last.text == '###payment###'
                    ? payment = true
                    : payment = false;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => scrollToBottom());
              } else {
                c.currentIndex = 0;
                navigateAndFinish(context, Home_Layout());
              }

              if (!c.userdata!.user) {
                if (c.messages.isEmpty) {
                  showToast(text: 'تم إلغاء الطلب', state: ToastStates.error);
                  c.getUsersIdChats();
                  c.currentIndex = 1;
                  navigateAndFinish(context, Home_Layout());
                }
              }
            }

            if (state is SendMessageSuccessState) {}
            if (state is DeleteMessageSuccessState) {}
          },
          builder: (context, state) {
            c.messages.isNotEmpty
                ? c.messages.last.text == '###payment###'
                    ? payment = true
                    : false
                : null;
            return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      c.currentIndex = 0;
                      navigateAndFinish(context, Home_Layout());
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.blue,
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      !c.userdata!.user
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  payment = !payment;
                                });
                                payment
                                    ? c.sendmessage(
                                        text: '###payment###',
                                        R_uId: widget.R_userdata.uId!,
                                        datetime: DateTime.now().toString())
                                    : showToast(
                                        text: 'لقد قمت  بارسال الطلب بالفعل',
                                        state: ToastStates.error);
                              },
                              icon: const Icon(
                                Icons.monetization_on_outlined,
                                color: Colors.blue,
                              ),
                            )
                          : Text(''),
                      Text(
                        widget.R_userdata.name!,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  actions: [
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: widget.R_userdata.image != ''
                                  ? NetworkImage('${widget.R_userdata.image!}')
                                  : const NetworkImage(
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png",
                                    )),
                        )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                  elevation: 0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                  ),
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(color: Colors.blue),
                ),
                body: ConditionalBuilder(
                  condition: c.messages.isNotEmpty,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                              controller: _scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message = c.messages[index];
                                if (c.userdata!.uId == message.S_uId) {
                                  return buildMymessage(message);
                                } else {
                                  return buildmessage(message);
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 15,
                                  ),
                              itemCount: c.messages.length),
                        ),
                        payment
                            ? Text("chat disabled")
                            : Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        height: 40,
                                        width: 45,
                                        child: MaterialButton(
                                          minWidth: 1,
                                          color: Colors.blue,
                                          onPressed: () {
                                            c.sendmessage(
                                                text: textController.text,
                                                R_uId: widget.R_userdata.uId!,
                                                datetime:
                                                    DateTime.now().toString());
                                            textController.text = '';
                                          },
                                          child: SvgPicture.asset(
                                            'assets/icon/Icon material-send.svg',
                                            fit: BoxFit.contain,
                                            height: 18,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 4.0, left: 5),
                                      child: TextFormField(
                                        textAlign: TextAlign.end,
                                        controller: textController,
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '...اكتب رسالتك هنا'),
                                      ),
                                    )),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                  fallback: (context) => Column(
                    children: [
                      Expanded(child: Text('لا توجد رسائل')),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                height: 40,
                                width: 45,
                                child: MaterialButton(
                                  minWidth: 1,
                                  color: Colors.blue,
                                  onPressed: () {
                                    c.sendmessage(
                                        text: textController.text,
                                        R_uId: widget.R_userdata.uId!,
                                        datetime: DateTime.now().toString());
                                    textController.text = '';
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icon/Icon material-send.svg',
                                    fit: BoxFit.contain,
                                    height: 18,
                                    width: 30,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 4.0, left: 5),
                              child: TextFormField(
                                textAlign: TextAlign.end,
                                controller: textController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '...اكتب رسالتك هنا'),
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }

  Widget buildmessage(messageModel model) => model.text == '###payment###'
      ? Align(
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  AppCubit.get(context).deleteAll(
                    id: widget.R_userdata.uId!,
                    allmessages: AppCubit.get(context).messages,
                  );
                  AppCubit.get(context).getUsersIdChats();
                  AppCubit.get(context).currentIndex = 1;
                  navigateAndFinish(context, Home_Layout());
                },
                color: Colors.red,
                child: const Text('إلغاء الطلب'),
              ),
              const SizedBox(
                width: 10,
              ),
              MaterialButton(
                onPressed: () {

                },
                color: Colors.green,
                child: const Text('إدفع'),
              ),
            ],
          ))
      : Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.5),
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text('${model.text}'),
            ),
          ),
        );
  Widget buildMymessage(messageModel model) => model.text != '###payment###'
      ? Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text('${model.text}'),
            ),
          ),
        )
      : Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(10),
                  topEnd: Radius.circular(10),
                  topStart: Radius.circular(10),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Text(
                'تم ارسال طلب مدفوعات',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        );
  void scrollToBottom() {
    _scrollController.jumpTo(
      _scrollController.position.maxScrollExtent,
    );
  }
}
