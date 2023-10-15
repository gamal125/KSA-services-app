
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:services/register/cubit/state.dart';
import '../../model/UserModel.dart';
import '../../shared/local/cache_helper.dart';




class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);


 String name='';
  String email='';
  String phone='';
  String photo='';
  signInWithGoogle()async{
  final GoogleSignInAccount? guser=await GoogleSignIn().signIn();
  final GoogleSignInAuthentication gAuth= await guser!.authentication;
  final credential= GoogleAuthProvider.credential(
  accessToken: gAuth.accessToken,
  idToken: gAuth.idToken,
  );
  return await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
    CacheHelper.saveData(key: 'uId',value: value.user!.uid);
   name= value.user!.displayName!;
   email=value.user!.email!;
   value.user!.phoneNumber!=null?phone:phone='';
   photo=value.user!.photoURL!;
   createUser2(image: photo, email: email, uId: value.user!.uid, name: name, phone: phone);

  });
  }


  void userRegister({
    required String email,
    required String password,
    required String name,
    required String phone,

  }) {
    emit(CreateUserInitialState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
createUser(
  image: '',
    email: email,
    name: name,
    phone: phone,
    uId: value.user!.uid);
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
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
        male: true,
        available: true,
        state: false,
        user: true,
        bonus: 0,
        cash: 0


    );

    FirebaseFirestore.instance.collection("users").doc(uId).set(model.Tomap()).then((value) {

      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
  void createUser2({
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
        male: true,
        available: true,
        state: false, user: true, bonus: 0, cash: 0

    );

    FirebaseFirestore.instance.collection("users").doc(uId).set(model.Tomap()).then((value) {

      emit(SuccessState(uId));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePassword() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordRegisterState());
  }
  IconData suffix2 = Icons.visibility_outlined;
  bool isPassword2 = true;

  void changePassword2() {
    isPassword2 = !isPassword2;
    suffix2 =
    isPassword2 ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordRegisterState());
  }
}

