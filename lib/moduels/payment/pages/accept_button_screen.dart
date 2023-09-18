import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../core/component_screen.dart';
import '../../../core/constance/constants.dart';
import '../../../core/widgets.dart';
import '../../../cubit/AppCubit.dart';
import '../../../cubit/states.dart';
import 'auth_screen.dart';

class AcceptButtonScreen extends StatelessWidget {
  static const String routeName = 'AcceptButtonScreen';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is PaymentAuthLoadingStates) {
          isLoading = true;
        } else if (state is PaymentAuthSuccessStates) {
          isLoading = false;
          navigateTo(context, AuthScreen());
        } else if (state is PaymentAuthErrorStates) {
          isLoading = false;
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Scaffold(
          body: ModalProgressHUD(
            progressIndicator: CircularProgressIndicator(
              color: Colors.white,
            ),
            inAsyncCall: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: defaultButton(
                    colorText: Colors.white,
                    background: KPrimaryColor,
                    function: () {
                      cubit.getAuthToken();
                    },
                    text: 'Procced to Payment'),
              ),
            ),
          ),
        );
      },
    );
  }
}
