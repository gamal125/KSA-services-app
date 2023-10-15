import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:services/components/components.dart';
import 'package:services/model/UserModel.dart';
import 'package:services/moduels/payment/pages/reference_screen.dart';
import 'package:services/moduels/payment/pages/visa_screen.dart';

import '../../../core/widgets.dart';
import '../../../cubit/AppCubit.dart';
import '../../../cubit/states.dart';


class ToggleScreen extends StatelessWidget {
  static const String routeName = 'ToggleScreen';
  ToggleScreen({required this.model});
  UserModel model;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is PaymentRefCodeLoadingStates) {
            isLoading = true;
          } else if (state is PaymentRefCodeSuccessStates) {
            isLoading = false;

            showSnackBar(
              context: context,
              text: "Success get ref code ",
              color: Colors.amber.shade400,
            );
           navigateTo(context, ReferenceScreen());

          } else if (state is PaymentRefCodeErrorStates) {
            isLoading = false;

            showSnackBar(
              context: context,
              text: "Error get ref code ",
              color: Colors.red,
            );
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // ModalProgressHUD(
                  //   progressIndicator: CircularProgressIndicator(
                  //     color: Colors.white,
                  //   ),
                  //   inAsyncCall: isLoading,
                  //   child: Expanded(
                  //     child: InkWell(
                  //       onTap: () {
                  //         cubit.getRefCode();
                  //       },
                  //       child: Container(
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(15.0),
                  //           border:
                  //               Border.all(color: Colors.black87, width: 2.0),
                  //         ),
                  //         child: const Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image(
                  //               height: 250,
                  //               image: AssetImage("assets/images/refcode.png"),
                  //             ),
                  //             SizedBox(height: 15.0),
                  //             Text(
                  //               'Payment with Ref code',
                  //               style: TextStyle(
                  //                 fontSize: 20.0,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                   navigateTo(context, VisaScreen(model: model));

                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              height: 250,
                              image:
                                  AssetImage("assets/images/credit-card.png"),
                              fit: BoxFit.contain,
                            ),
                            Text(
                              'Payment with visa',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
