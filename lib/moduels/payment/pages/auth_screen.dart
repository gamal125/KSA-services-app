import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:services/components/components.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/payment/pages/toggle_screen.dart';

import '../../../core/constance/constants.dart';
import '../../../core/widgets.dart';
import '../../../cubit/AppCubit.dart';
import '../../../cubit/states.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({required this.model,required this.price}  );
  UserModel model;
  String price;
  static const String routeName = 'AuthScreen';
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var priceController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userdata=AppCubit.get(context).userdata;
    List<String> nameParts = userdata!.name!.split(' ');

    String firstName = nameParts[0];
    String lastName = nameParts[1];
    emailController.text=userdata.email!;
    firstNameController.text=firstName;
    lastNameController.text=lastName;
    priceController.text=price;
    phoneController.text=userdata.phone!;
    return BlocProvider(
      create: (context) => AppCubit()..getAuthToken(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton( onPressed: () { Navigator.pop(context) ;}, icon: Icon(Icons.arrow_back_ios),),

          title: const Text(
            "Payment Integration",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: KPrimaryColor,
        ),
        backgroundColor: Colors.white,
        body: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is PaymentOrderIdLoadingStates) {
              isLoading = true;
            } else if (state is PaymentRequestTokenSuccessStates) {
              isLoading = false;

              // showSnackBar(
              //   context: context,
              //   text: 'Success get final token',
              //   color: Colors.green,
              // );
              navigateTo(context, ToggleScreen(model: model));

             // navigateTo(context, ToggleScreen());
            } else if (state is PaymentRequestTokenErrorStates) {
              isLoading = false;
            }
          },
          builder: (context, state) {
            var cubit = AppCubit.get(context);
            return ModalProgressHUD(
              progressIndicator: CircularProgressIndicator(
                color: Colors.white,
              ),
              inAsyncCall: isLoading,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Image(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: double.infinity,
                          image: AssetImage(
                            "assets/images/online-payment.png",
                          ),
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: defaultFormField(
                                    cursorColor: Colors.black,
                                    controller: firstNameController,
                                    type: TextInputType.name,
                                    onChange: () {},
                                    validator: (String? text) {
                                      if (text!.isEmpty) {
                                        return 'Please Enter First Name';
                                      }
                                      return null;
                                    },
                                    label: 'First Name',
                                    prefix: Icons.person),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: defaultFormField(
                                    cursorColor: Colors.black,
                                    controller: lastNameController,
                                    type: TextInputType.name,
                                    onChange: () {},
                                    validator: (String? text) {
                                      if (text!.isEmpty) {
                                        return 'Please Enter Last Name';
                                      }
                                      return null;
                                    },
                                    label: 'Last Name',
                                    prefix: Icons.person),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: defaultFormField(
                              cursorColor: Colors.black,
                              controller: emailController,
                              type: TextInputType.emailAddress,
                              onChange: () {},
                              validator: (String? text) {
                                if (text!.isEmpty) {
                                  return 'Please Enter Email';
                                }
                                return null;
                              },
                              label: 'Email',
                              prefix: Icons.email),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: defaultFormField(
                              cursorColor: Colors.black,
                              controller: phoneController,
                              type: TextInputType.phone,
                              onChange: () {},
                              validator: (String? text) {
                                if (text!.isEmpty) {
                                  return 'Please Enter Phone Number';
                                }
                                return null;
                              },
                              label: 'Phone',
                              prefix: Icons.phone),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        priceController.text==''?
                        defaultFormField(

                            cursorColor: Colors.black,
                            controller: priceController,
                            type: TextInputType.number,
                            onChange: () {},
                            validator: (String? text) {
                              if (text!.isEmpty) {
                                return 'Please Enter Price';
                              }
                              return null;
                            },
                            label: 'Price',
                            prefix: Icons.monetization_on_outlined):      defaultFormField2(

                            cursorColor: Colors.black,
                            controller: priceController,
                            type: TextInputType.number,
                            onChange: () {},
                            validator: (String? text) {
                              if (text!.isEmpty) {
                                return 'Please Enter Price';
                              }
                              return null;
                            },
                            label: 'Price',
                            prefix: Icons.monetization_on_outlined)

                        ,
                        SizedBox(
                          height: 30,
                        ),
                        defaultButton(
                            colorText: Colors.white,
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.getOrderRegistrationID(
                                    price: priceController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    phone: phoneController.text);
                              }
                            },
                            text: 'Register',
                            background: Colors.black),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
