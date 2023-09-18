// ignore_for_file: file_names, use_key_in_widget_constructors, camel_case_types
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/AppCubit.dart';
import '../cubit/states.dart';
import '../shared/local/cache_helper.dart';



class Home_Layout extends StatefulWidget {


  @override
  State<Home_Layout> createState() => _Home_LayoutState();
}

class _Home_LayoutState extends State<Home_Layout> with WidgetsBindingObserver {
  String uid=CacheHelper.getData(key: 'uId');

  @override
  void initState(){
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    setStatus('online');
  }

  void setStatus(String state) {

    if(uid!=''){
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state==AppLifecycleState.resumed){
      setStatus('online');
    }else{
      setStatus('offline');

    }
  }
  @override
  Widget build(BuildContext context) {


    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,  state) {
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        String uid=CacheHelper.getData(key: 'uId');
        return  uid=='8DxVS7sTApPRE3oD1SZvLEjHXNg1'? cubit.Adminscreens[cubit.currentIndex]:cubit.screens[cubit.currentIndex];


      },
    );
  }
}
