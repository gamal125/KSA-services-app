abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}
class UpdateProductSuccessStates extends AppStates {}
class UpdateProductErrorStates extends AppStates {
  final String error;

  UpdateProductErrorStates( this.error);
}
class CreateUserSuccessState extends AppStates {}
class CreateUserErrorState extends AppStates {
  final String error;

  CreateUserErrorState( this.error);
}
class LogoutLoadingState extends AppStates {}
class LogoutSuccessState extends AppStates {}

class GetServiceLoadingState extends AppStates {}
class GetServiceSuccessState extends AppStates {}
class DeleteServiceLoadingState extends AppStates {}
class DeleteServiceSuccessState extends AppStates {}
class ImageintStates extends AppStates {}

class ImageErrorStates extends AppStates {
  final String error;

  ImageErrorStates( this.error);
}
class UpdateProductImageErrorStates extends AppStates {
  final String error;

  UpdateProductImageErrorStates( this.error);
}
class UpdateProductImageSuccessStates extends AppStates {}
class SendMessageSuccessState extends AppStates {}
class DeleteMessageSuccessState extends AppStates {}
class GetIdUsersChatsSuccessState extends AppStates {}
class GetUsersHasChatsSuccessState extends AppStates {}
class GetAllUsersSuccessState extends AppStates {}
class GetAllUsersLoadingState extends AppStates {}
class AppChangeBottomSheetState extends AppStates {}
class SendMessageErrorState extends AppStates {
  final String error;

  SendMessageErrorState( this.error);
}
class SetServiceErrorState extends AppStates {
  final String error;

  SetServiceErrorState( this.error);
}
class GetMessageSuccessState extends AppStates {
  final String R_uId;

  GetMessageSuccessState( this.R_uId);
}
class SetServiceSuccessState extends AppStates {}

class ImageSuccessStates extends AppStates {}
class GetOneUsersSuccessStates extends AppStates {}
class GetAllUsersSuccessStates extends AppStates {}
class GetUsersInitStates extends AppStates {}


class PaymentInitialStates extends AppStates {}

class PaymentAuthLoadingStates extends AppStates {}

class PaymentAuthSuccessStates extends AppStates {}

class PaymentAuthErrorStates extends AppStates {
  final String error;

  PaymentAuthErrorStates(this.error);
}

// for order id
class PaymentOrderIdLoadingStates extends AppStates {}

class PaymentOrderIdSuccessStates extends AppStates {}

class PaymentOrderIdErrorStates extends AppStates {
  final String error;

  PaymentOrderIdErrorStates(this.error);
}

// for request token
class PaymentRequestTokenLoadingStates extends AppStates {}

class PaymentRequestTokenSuccessStates extends AppStates {}

class PaymentRequestTokenErrorStates extends AppStates {
  final String error;

  PaymentRequestTokenErrorStates(this.error);
}

// for ref code
class PaymentRefCodeLoadingStates extends AppStates {}

class PaymentRefCodeSuccessStates extends AppStates {}

class PaymentRefCodeErrorStates extends AppStates {
  final String error;

  PaymentRefCodeErrorStates(this.error);
}
