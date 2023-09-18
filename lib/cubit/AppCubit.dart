import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/components/components.dart';
import 'package:services/cubit/states.dart';
import 'package:services/model/servicemodel.dart';
import 'package:services/moduels/chatsScreens/ChatsScreen.dart';
import 'package:services/moduels/servicesScreens/ServiceScreen.dart';

import '../core/constance/Apicontest.dart';
import '../core/dio_helper.dart';
import '../model/UserModel.dart';
import '../model/message_model.dart';
import '../moduels/chatsScreens/AdminChatsScreen.dart';
import '../moduels/payment/models/authentication_request_model.dart';
import '../moduels/payment/models/order_registration_model.dart';
import '../moduels/payment/models/payment_reqeust_model.dart';
import '../moduels/profileScreens/Adminprofile.dart';
import '../moduels/profileScreens/profile.dart';
import '../moduels/servicesScreens/AdminServiceScreen.dart';
import '../shared/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }
  int currentIndex = 0;
  List<Widget> screens = [
     ServicesScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];
  List<Widget> Adminscreens = [
    AdminServicesScreen(),
    AdminChatsScreen(),
    AdminProfileScreen(),
  ];
  List<String> titles = [
    'Services',
    'Chats',
    'profile',
  ];
  List<BottomNavigationBarItem> BottomItems = [
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.auto_awesome_mosaic_outlined,
        ),
        label: 'Services'),
    const BottomNavigationBarItem(
        icon: Icon(
          Icons.wechat_sharp,
        ),
        label: 'Chats'),
    const BottomNavigationBarItem(
        icon:   Icon(  Icons.person,),
        label: 'profile'),

  ];
  void changeIndex(int index) {
    currentIndex = index;
    if (currentIndex==0){

      getavailablty();
    }
    if (currentIndex==1){
      if(CacheHelper.getData(key: 'uId')!='8DxVS7sTApPRE3oD1SZvLEjHXNg1'){
      getavailablty();

      getUsersIdChats();}else{

      }

    }
    if (currentIndex==2){
      getUser(CacheHelper.getData(key: 'uId'));
    }


    emit(AppChangeBottomNavBarState());
  }
  void signout(){
    emit(LogoutLoadingState());
    FirebaseAuth.instance.signOut().then((value) {
      emit(LogoutSuccessState());
    });
  }
  UserModel? userdata;
  List<UserModel> AllUsers=[];
  List<UserModel> onlineUsers=[];
  List<UserModel> onlineUsers2=[];
  List<UserModel> onlineUsers3=[];

  Future<void> getusers({required bool male}) async{

    AllUsers.clear();
    onlineUsers.clear();
    onlineUsers2.clear();
    onlineUsers3.clear();
   await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {

        AllUsers.add(UserModel.fromjson(element.data()));

      }
      AllUsers.forEach((element) {
        if(element.state&&element.uId!=ud&&!element.user) {

          if (element.male == male) {
            if (element.available) {
              onlineUsers.add(element);
            }
            else {
              onlineUsers2.add(element);
            }
          }else{
            onlineUsers3.add(element);
          }

        }

      });

    });
    emit(GetAllUsersSuccessStates());
  }
  void getavailablty(){
    String id =CacheHelper.getData(key: 'uId');
  FirebaseFirestore.instance.collection('users').doc(id).collection('chats').get().then((value){
    if(value.docs.isNotEmpty){
      FirebaseFirestore.instance.collection("users").doc(id).update({'available':false});

    }else{
      FirebaseFirestore.instance.collection("users").doc(id).update({'available':true});
  }
  });
  }
  void getUser(uid) {
    emit(GetUsersInitStates());
    FirebaseFirestore.instance.collection('users').doc(uid.toString())
        .get()
        .then((value) {
      userdata = UserModel.fromjson(value.data()!);
      getavailablty();
      emit(GetOneUsersSuccessStates());
    });
  }
  void updateProfile({
    required String image,
    required String name,
    required String phone,
    required String email,}) {
    UserModel model = UserModel(
        image: image,
        name: name,
        uId: ud,
        phone: phone,
        email: email,
        available: true,
        male: true, state: false, user: true
    );
    emit(ImageintStates());
    FirebaseFirestore.instance.collection('users').doc(ud).update(model.Tomap()).then((value) {
      emit(UpdateProductSuccessStates());
    }).catchError((error) {
      emit(UpdateProductErrorStates(error.toString()));
    });
  }
  String ImageUrl2 = '';

  void uploadProfileImage({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ImageintStates());
    FirebaseStorage.instance.ref().child('users/${Uri
        .file(PickedFile2!.path)
        .pathSegments
        .last}').putFile(PickedFile2!).
    then((value) {
      value.ref.getDownloadURL().then((value) {
        ImageUrl2 = value;
        print(ImageUrl2);
        createUser(
            image: ImageUrl2,
            name: name,
            email: email,
            phone: phone,
            uId: ud);
        PickedFile2 = null;

        emit(ImageSuccessStates())
        ;
      }).catchError((error) {
        emit(ImageErrorStates(error));
      });
    }).catchError((error) {
      emit(ImageErrorStates(error));
    });
  }
  void createUser({
    required String image,
    required String email,
    required String uId,
    required String name,
    required String phone,
  }) {
    UserModel model=UserModel(
        email: email,
        name: name,
        phone: phone,
        uId: uId,
        image: image,
        available: true, male: true, state: false, user: true

    );

    FirebaseFirestore.instance.collection("users").doc(uId).set(model.Tomap()).then((value) {

      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

/////////////////////////iamge///////////
  final ImagePicker picker2 = ImagePicker();
  File? PickedFile2;
  Future<void> getImage2() async {
    final imageFile = await picker2.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      PickedFile2 = File(imageFile.path);
      emit(UpdateProductImageSuccessStates());
    }
    else {
      var error = 'no Image selected';
      emit(UpdateProductImageErrorStates(error.toString()));
    }
  }
  final ImagePicker picker = ImagePicker();
  File? PickedFile;
  Future<void> getImage() async {
    final imageFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      PickedFile = File(imageFile.path);
      emit(UpdateProductImageSuccessStates());
    }
    else {
      var error = 'no Image selected';
      emit(UpdateProductImageErrorStates(error.toString()));
    }
  }
  ////////////////////upload workshop/////////////
  String ImageUrl = '';
  String ud =  CacheHelper.getData(key: 'uId');

  List<messageModel> messages=[];
  void getmessages(
      {

        required String R_uId,
      }
      ){
    FirebaseFirestore.instance.collection('users').doc(ud).collection('chats').doc(R_uId).collection('messages').orderBy('date').
    snapshots().listen((event) {
      messages=[];
      event.docs.forEach((element) {
        messages.add(messageModel.fromjson(element.data()));
      });
      emit(GetMessageSuccessState(R_uId));

    });

  }
  void setService({required String name,required String price}){
    ServiceModel model=ServiceModel(
      name: name,
      price: price
    );
    FirebaseFirestore.instance.collection('services').doc(name).set(model.Tomap()).then((value){
      emit(SetServiceSuccessState());
    }).catchError((error){
      showToast(text: 'check your network', state: ToastStates.error);
      emit(SetServiceErrorState(error.toString()));
    });
  }
  List<ServiceModel> serviceList=[];
  void getService(){
    emit(GetServiceLoadingState());
    serviceList.clear();
    FirebaseFirestore.instance.collection('services').get().then((value) {
      value.docs.forEach((element) {
        serviceList.add(ServiceModel.fromjson(element.data()));
      });
      emit(GetServiceSuccessState());
    });
  }
  void deleteService({required String name}){
    emit(DeleteServiceLoadingState());
    FirebaseFirestore.instance.collection("services").doc(name).delete().then((value) {
      getService();
emit(DeleteServiceSuccessState());

    });
  }
  void sendmessage(
      {required String text,
        required String R_uId,
        required String datetime
      }
      ){
    messageModel model=messageModel(
      date: datetime,
      R_uId: R_uId,
      text: text,
      S_uId: userdata!.uId,
    );

    FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection('chats').doc(R_uId).collection('messages').add(
        model.Tomap()).then((value) {
      FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection('chats').doc(R_uId).set({'id':R_uId});
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });

    FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats').doc(userdata!.uId).collection('messages').add(
        model.Tomap()).then((value) {
      FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats').doc(userdata!.uId).set({'id':userdata!.uId});
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
  }
  void deleteAll({required List<messageModel> allmessages,required String id}){

    allmessages.forEach((element) {deletemessage(m: element, id: id); });
  }
  void deletemessage (
      {required messageModel m,
        required String id,
      }
      ){
    messageModel model=messageModel(
      date: m.date,
      R_uId: m.R_uId,
      text: m.text,
      S_uId: userdata!.uId,
    );
    deleteDocumentWithSubcollection2('users',userdata!.uId!,'chats',id);

    FirebaseFirestore.instance.collection("users").doc(id).collection('archats').doc(userdata!.uId).collection('messages').add(
        model.Tomap()).then((value) {
      FirebaseFirestore.instance.collection("users").doc(id).collection('archats').doc(userdata!.uId).set({'id':id});
      emit(DeleteMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
    deleteDocumentWithSubcollection2('users',id,'chats',userdata!.uId!);
    FirebaseFirestore.instance.collection("users").doc(userdata!.uId).collection('archats').doc(id).collection('messages').add(
        model.Tomap()).then((value) {

      FirebaseFirestore.instance.collection("users").doc(userdata!.uId).collection('archats').doc(id).set({'id':userdata!.uId});
      emit(DeleteMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState(error.toString()));
    });
  }
  void deleteDocumentWithSubcollection(String documentPath) async {
    final documentRef = FirebaseFirestore.instance.doc(documentPath);

    // Delete the main document
    await documentRef.delete();

    // Delete the subcollection
    final subcollectionSnapshot = await documentRef.collection('messages').get();
    for (var subDocument in subcollectionSnapshot.docs) {
      await subDocument.reference.delete();
    }
  }
  void deleteDocumentWithSubcollection2(String collectionpath,String documentPath,String collectionpath2,String documentPath2) async {
    final documentRef = FirebaseFirestore.instance.collection(collectionpath).doc(documentPath).collection(collectionpath2).doc(documentPath2);

    // Delete the main document
    await documentRef.delete();

    // Delete the subcollection
    final subcollectionSnapshot = await documentRef.collection('messages').get();
    for (var subDocument in subcollectionSnapshot.docs) {
      await subDocument.reference.delete();
    }
  }

// Usage

  void deleteCollection(String collectionPath) async {
    final collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    const batchSize = 10;

    // Retrieve and delete documents in batches
    QuerySnapshot querySnapshot;
    do {
      querySnapshot = await collectionRef.limit(batchSize).get();
      final batch = FirebaseFirestore.instance.batch();
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
      }
      await batch.commit();
    } while (querySnapshot.size > 0);
  }
  List<String> ids=[];
  Future<void> getUsersIdChats()async{
    ids.clear();
    usersHasChats.clear();
    print(ud);
   await FirebaseFirestore.instance.collection('users').doc(ud).collection('chats').get().then((value) {
     print(value.docs.length);
      value.docs.forEach((doc) {

        ids.add(doc.id);
      });

      emit(GetIdUsersChatsSuccessState());
    });

  }
  List<UserModel> usersHasChats=[];
  void getAllUsersHaschats()async{

    usersHasChats.clear();
    ids.toSet().toList();
    ids.forEach((element) {
      getoneuser(id: element);
    });
    await Future.delayed(Duration(milliseconds: 2000));
    usersHasChats.toSet().toList();
    emit(GetUsersHasChatsSuccessState());
  }
    List<UserModel> users=[];
  Future<void> getoneuser({required String id})async{
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
print(value.data()!);
      usersHasChats.add(UserModel.fromjson(value.data()!));
    });

  }
  Future<void> getAllusers()async{
    users.clear();
    String id=CacheHelper.getData(key: 'uId');
    emit(GetAllUsersLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if(element.id!=id){
          users.add(UserModel.fromjson(element.data()));
          } });
        emit(GetAllUsersSuccessState());
    });

  }







  AuthenticationRequestModel? authTokenModel;

  Future<void> getAuthToken() async {
    // i send my api key to get the paymentFirstToken
    // then i get to send the auth request with the first and last name and stuff
    emit(PaymentAuthLoadingStates());
    DioHelper.PostData(url: ApiContest.getAuthToken, data: {
      'api_key': ApiContest.paymentApiKey,
    }).then((value) {
      authTokenModel = AuthenticationRequestModel.fromJson(value.data);
      ApiContest.paymentFirstToken = authTokenModel!.token;
      print('The token 🍅 ${ApiContest.paymentFirstToken}');
      emit(PaymentAuthSuccessStates());
    }).catchError((error) {
      print('Error in auth token 🤦‍♂️');
      emit(
        PaymentAuthErrorStates(error.toString()),
      );
    });
  }

  Future getOrderRegistrationID({
    required String price,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    emit(PaymentOrderIdLoadingStates());
    DioHelper.PostData(url: ApiContest.getOrderId, data: {
      'auth_token': ApiContest.paymentFirstToken,
      "delivery_needed": "false",
      "amount_cents": price,
      "currency": "EGP",
      "items": [],
    }).then((value) {
      OrderRegistrationModel orderRegistrationModel =
      OrderRegistrationModel.fromJson(value.data);
      ApiContest.paymentOrderId = orderRegistrationModel.id.toString();
      getPaymentRequest(price, firstName, lastName, email, phone);
      print('The order id 🍅 =${ApiContest.paymentOrderId}');
      emit(PaymentOrderIdSuccessStates());
    }).catchError((error) {
      print('Error in order id 🤦‍♂️');
      emit(
        PaymentOrderIdErrorStates(error.toString()),
      );
    });
  }

  Future<void> getPaymentRequest(
      String priceOrder,
      String firstName,
      String lastName,
      String email,
      String phone,
      ) async {
    emit(PaymentRequestTokenLoadingStates());
    DioHelper.PostData(
      url: ApiContest.getPaymentRequest,
      data: {
        "auth_token": ApiContest.paymentFirstToken,
        "amount_cents": priceOrder,
        "expiration": 3600,
        "order_id": ApiContest.paymentOrderId,
        "billing_data": {
          "apartment": "NA",
          "email": email,
          "floor": "NA",
          "first_name": firstName,
          "street": "NA",
          "building": "NA",
          "phone_number": phone,
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": lastName,
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": ApiContest.integrationIdCard,
        "lock_order_when_paid": "false"
      },
    ).then((value) {
      PaymentRequestModel paymentRequestModel =
      PaymentRequestModel.fromJson(value.data);
      ApiContest.finalToken = paymentRequestModel.token;
      print('Final token 🚀 ${ApiContest.finalToken}');
      emit(PaymentRequestTokenSuccessStates());
    }).catchError((error) {
      print('Error in final token 🤦‍♂️');
      emit(
        PaymentRequestTokenErrorStates(error.toString()),
      );
    });
  }

  Future getRefCode() async {
    DioHelper.PostData(
      url: ApiContest.getRefCode,
      data: {
        "source": {
          "identifier": "AGGREGATOR",
          "subtype": "AGGREGATOR",
        },
        "payment_token": ApiContest.finalToken,
      },
    ).then((value) {
      ApiContest.refCode = value.data['id'].toString();
      print('The ref code 🍅${ApiContest.refCode}');
      emit(PaymentRefCodeSuccessStates());
    }).catchError((error) {
      print("Error in ref code 🤦‍♂️");
      emit(PaymentRefCodeErrorStates(error.toString()));
    });
  }



}