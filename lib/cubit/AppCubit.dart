import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:services/components/components.dart';
import 'package:services/cubit/states.dart';
import 'package:services/model/priceModel.dart';
import 'package:services/model/servicemodel.dart';
import 'package:services/moduels/chatsScreens/ChatsScreen.dart';
import 'package:services/moduels/servicesScreens/ServiceScreen.dart';
import '../core/constance/Apicontest.dart';
import '../core/dio_helper.dart';
import '../model/UserModel.dart';
import '../model/message_model.dart';
import '../moduels/chatsScreens/Adminchats/AdminChatsScreen.dart';
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
   bool isDark=true;
   void changemode(){
     isDark=!isDark;
     emit(AppchangeState());
   }
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
    const ChatsScreen(),
    const ProfileScreen(),
  ];
  List<Widget> Adminscreens = [
    const AdminServicesScreen(),
    const AdminChatsScreen(),
    const AdminProfileScreen(),
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
      getService();
    }
    if (currentIndex==1){
      String x=CacheHelper.getData(key: 'uId');
      if(x!='8DxVS7sTApPRE3oD1SZvLEjHXNg1'){
        getavailablty();
       getUsersIdChats();
      }
      else{
        getusersid();
      }


    }
    if (currentIndex==2){
      getavailablty();
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

  Future<void> getusers({required bool male,}) async{

    AllUsers.clear();
    onlineUsers.clear();
    onlineUsers2.clear();
    onlineUsers3.clear();
   await FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {

        AllUsers.add(UserModel.fromjson(element.data()));

      }
      for (var element in AllUsers) {
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

      }

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
  List<String> idlist=[];
  List<String> idlisthasarchats=[];
  void getusersid(){

    idlist.clear();
    FirebaseFirestore.instance.collection('users').get().then((value)  async {
      for (var element in value.docs) {
        idlist.add(element.id);
      }
      await getusersidarchats();

    });
  }
  Future<void> getusersidarchats() async {
    idlisthasarchats.clear();
    for (var element in idlist) {
      FirebaseFirestore.instance.collection('users').doc(element).collection('archats').get().then((value) {
        if(value.docs.isNotEmpty){
          idlisthasarchats.add(element);
        }
      });
    }
    await Future.delayed(const Duration(milliseconds: 2000));
    emit(GetUserHasArchatsLoadingState());

  }
  List<UserModel> userhasarchats=[];
  Future<void> getUserHasArchats() async {
    userhasarchats.clear();
    for (var element in idlisthasarchats) {
      FirebaseFirestore.instance.collection('users').doc(element).get().then((value) {
        userhasarchats.add(UserModel.fromjson(value.data()!));
      });
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    emit(GetUserHasArchatsSuccessState());
  }
  List<String>customerSeviceid=[];
  void getcustomerSeviceid({required String id}){
    customerSeviceid.clear();
    FirebaseFirestore.instance.collection('users').doc(id).collection('archats').get().then((value) {
      for (var element in value.docs) {customerSeviceid.add(element.id);}

      getcustomerSevices();
    });
  }
  List<UserModel> customerSevice=[];
  Future<void> getcustomerSevices() async {
    customerSevice.clear();
    for (var element in customerSeviceid) {
   h(element);
    }
    await Future.delayed(const Duration(milliseconds: 2000));
    emit(Done());
  }
  void h(String element){
     FirebaseFirestore.instance.collection('users').doc(element).get().then((value) {
      customerSevice.add(UserModel.fromjson(value.data()!));
    });
  }
  void getUser(uid) {
    emit(GetUsersInitStates());

    uid!=''&&uid!=null? FirebaseFirestore.instance.collection('users').doc(uid.toString())
        .get()
        .then((value) {
      userdata = UserModel.fromjson(value.data()!);
      getavailablty();
      emit(GetOneUsersSuccessStates());
    }):null;
  }
  void setBonus({required int cash,required String uId,required double bonus}){
    try{
      emit(SetUserBonusLoadingStates());
      int integerPart = bonus.toInt(); // Obtaining the integer part
      double fractionalPart = bonus - integerPart;
      fractionalPart=double.parse(fractionalPart.toStringAsFixed(1));
      FirebaseFirestore.instance.collection('users').doc(uId).update({"bonus":(fractionalPart*1000).toInt()});
      int x=integerPart+cash;
      FirebaseFirestore.instance.collection('users').doc(uId).update({"cash":x}).then((value) {
      emit(SetUserBonusSuccessStates((fractionalPart*1000).toInt(),x));
    });

    }catch(e){
      log(e.toString());
    }
  }
  void getWalletUser(uid) {

    emit(GetUserswalletStates());

    uid!=''&&uid!=null? FirebaseFirestore.instance.collection('users').doc(uid.toString())
        .get()
        .then((value) {
      userdata = UserModel.fromjson(value.data()!);
      getavailablty();
      emit(GetUserWalletSuccessStates(userdata!));
    }):null;
  }
  void updateProfile({
    required String image,
    required String name,
    required String phone,
    required String email,
    required bool user,
  }) {

    emit(ImageintStates());
    FirebaseFirestore.instance.collection('users').doc(ud).update({
      'name':name,
      'phone':phone,
      'email':email,
      'image':image,

    }).then((value) {
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


    FirebaseFirestore.instance.collection("users").doc(uId).set({
      'name':name,
      'phone':phone,
      'email':email,
      'image':image,

    }).then((value) {

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
  String ud =  CacheHelper.getData(key: 'uId')??'';

  List<messageModel> messages=[];
  List<messageModel> commessages=[];
  void getmessages(
      {

        required String R_uId,
      }
      ){
    FirebaseFirestore.instance.collection('users').doc(ud).collection('chats').doc(R_uId).collection('messages').orderBy('date').
    snapshots().listen((event) {
      messages=[];
      for (var element in event.docs) {
        messages.add(messageModel.fromjson(element.data()));
      }
      emit(GetMessageSuccessState(R_uId,));

    });

  }

  void getcomplaintmessages(
      {

        required String R_uId,
      }
      ){
    FirebaseFirestore.instance.collection('users').doc(R_uId).collection('complaint').doc(ud).collection('messages').orderBy('date').
    snapshots().listen((event) {
      commessages=[];
      for (var element in event.docs) {
        commessages.add(messageModel.fromjson(element.data()));
      }
      emit(GetComplaintMessageSuccessState(R_uId,));

    });

  }
  void getarmessages(
      {
        required String R_uId,
      }
      ){
    FirebaseFirestore.instance.collection('users').doc(R_uId).collection('archats').get().then((value) {
     String x= value.docs.first.id;
     FirebaseFirestore.instance.collection('users').doc(R_uId).collection('archats').doc(x).collection('messages').orderBy('date').
     snapshots().listen((event) {
       messages=[];
       for (var element in event.docs) {
         messages.add(messageModel.fromjson(element.data()));
       }
       emit(GetMessageSuccessState(R_uId,));

     });
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
void getService() async {
    emit(GetServiceLoadingState());
    serviceList.clear();
   await FirebaseFirestore.instance.collection('services').get().then((value) {
      for (var element in value.docs) {
        serviceList.add(ServiceModel.fromjson(element.data()));
      }
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
  void sendstartmessag(
      {required String text,
        required String R_uId,
        required String datetime,
        required String price,
      }
      ){
    messageModel model=messageModel(
      date: datetime,
      R_uId: R_uId,
      text: text,
      S_uId: userdata!.uId,
    );


     FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection(
            'chats').doc(R_uId).set({'price': price});

    FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection(
        'chats').doc(R_uId).collection('messages').doc('start').set(
        model.Tomap());

    FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats')
        .doc(userdata!.uId).collection('messages').doc('start').set(
        model.Tomap());

         FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats').doc(userdata!.uId).set({'price': price});





  }
  void sendmessage(
      {required String text,
        required String R_uId,
        required String datetime,
        required String price,
      }
      ){
    messageModel model=messageModel(
      date: datetime,
      R_uId: R_uId,
      text: text,
      S_uId: userdata!.uId,
    );
if(text!='###payment###') {
  FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection(
      'chats').doc(R_uId).collection('messages').add(
      model.Tomap()).then((value) {
    price!=''? FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection(
        'chats').doc(R_uId).set({'price': price}):null;
    emit(SendMessageSuccessState());
  }).catchError((error) {
    emit(SendMessageErrorState(error.toString()));
  });

}else{
  FirebaseFirestore.instance.collection("users").doc(model.S_uId!).collection(
      'chats').doc(R_uId).collection('messages').doc('payment').set(
      model.Tomap()).then((value) {
    emit(SendMessageSuccessState());
  }).catchError((error) {
    emit(SendMessageErrorState(error.toString()));
  });
}
if(text!='###payment###') {
  FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats')
      .doc(userdata!.uId).collection('messages').add(
      model.Tomap())
      .then((value) {
    emit(SendMessageSuccessState());
  }).catchError((error) {
    emit(SendMessageErrorState(error.toString()));
  });
}else{
  FirebaseFirestore.instance.collection("users").doc(R_uId).collection('chats')
      .doc(userdata!.uId).collection('messages').doc('payment').set(
      model.Tomap())
      .then((value) {
    emit(SendMessageSuccessState());
  }).catchError((error) {
    emit(SendMessageErrorState(error.toString()));
  });
}
  }
  void sendcomplaintmessage(
      {required String text,
        required String R_uId,
        required String datetime,
        required String price,
      }
      ){
    messageModel model=messageModel(
      date: datetime,
      R_uId: R_uId,
      text: text,
      S_uId: userdata!.uId,
    );

      FirebaseFirestore.instance.collection('users').doc(ud).collection('complaint').doc(R_uId).collection('messages').add(
          model.Tomap()).then((value) {
        FirebaseFirestore.instance.collection('users').doc(ud).collection('complaint').doc(R_uId).set({'id':R_uId});
        emit(SendMessageSuccessState());
      }).catchError((error) {
        emit(SendMessageErrorState(error.toString()));
      });




      FirebaseFirestore.instance.collection('users').doc(R_uId).collection('complaint').doc(ud).collection('messages').add(
          model.Tomap())
          .then((value) {
        FirebaseFirestore.instance.collection('users').doc(R_uId).collection('complaint').doc(ud).set({'id':ud});
        emit(SendMessageSuccessState());
      }).catchError((error) {
        emit(SendMessageErrorState(error.toString()));
      });


  }
  List<messageModel> ComplaintMessage=[];
  void getcomplaintMessage({required String R_uId}){
    FirebaseFirestore.instance.collection('users').doc(ud).collection('complaint').doc(R_uId).collection('messages').orderBy('date').
    snapshots().listen((event) {
      ComplaintMessage=[];
      for (var element in event.docs) {
        ComplaintMessage.add(messageModel.fromjson(element.data()));
      }
      emit(GetComplaintMessageSuccessState(R_uId));

    });
  }
  PriceModel price=PriceModel(price: '');
 void getprice({required String R_uId}){
    FirebaseFirestore.instance.collection("users").doc(R_uId).collection("chats").doc(userdata!.uId).get().then((value) {
      price=PriceModel.fromjson(value.data()!);
 emit(GetPriceMessageSuccessState(price.price!));
    });

  }

  void deleteAll({required List<messageModel> allmessages,required String id}){

    for (var element in allmessages) {deletemessage(m: element, id: id); }
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

   await FirebaseFirestore.instance.collection('users').doc(ud).collection('chats').get().then((value) {

      for (var doc in value.docs) {

        ids.add(doc.id);
      }

      emit(GetIdUsersChatsSuccessState());
    });

  }

List<String> ComplaintIds=[];
  List<UserModel> UsersComplaint=[];
Future<void> getComplaintUsersid() async {
  emit(GetComplaintUsersLoadingState());
  ComplaintIds.clear();
  UsersComplaint.clear();
  await  FirebaseFirestore.instance.collection('users').doc(ud).collection('complaint').get().then((value) {
      for (var element in value.docs) {
        ComplaintIds.add(element.id.toString());

      }
      emit(GetComplaintUsersSuccessState());
    });


}
Future<void> getComplaintUsers() async {
  for (var element in ComplaintIds) {
    getComplaintUserdata(id:element);
  }
  await Future.delayed(const Duration(milliseconds: 2000));
  emit(GetComplaintUsersSuccessState2());
}
void getComplaintUserdata({required String id}){
  FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
    UsersComplaint.add(UserModel.fromjson(value.data()!));

  });
}
  List<UserModel> usersHasChats=[];
  void getAllUsersHaschats()async{

    usersHasChats.clear();
    ids.toSet().toList();
    ids.forEach((element) {

      getoneuser(id: element);
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    usersHasChats.toSet().toList();
    emit(GetUsersHasChatsSuccessState());
  }
    List<UserModel> users=[];
  Future<void> getoneuser({required String id})async{
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((value) {
      usersHasChats.add(UserModel.fromjson(value.data()!));
    });

  }
  Future<void> getAllusers()async{
    users.clear();
    String id=CacheHelper.getData(key: 'uId');
    emit(GetAllUsersLoadingState());
    await FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if(element.id!=id){
          users.add(UserModel.fromjson(element.data()));
          } }
        emit(GetAllUsersSuccessState());
    });

  }


void deletepayment(String id){
FirebaseFirestore.instance.collection('users').doc(ud).collection('chats').doc(id).collection('messages').doc('payment').delete();
FirebaseFirestore.instance.collection('users').doc(id).collection('chats').doc(ud).collection('messages').doc('payment').delete();

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