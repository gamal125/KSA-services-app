
abstract class RegisterState {}

class RegisterInitialState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {
  // final LoginModel  loginModel;
  //
  // RegisterSuccessState(this.loginModel);
}
class LoadingState extends RegisterState {}

class SuccessState extends RegisterState {
  final String  uId;

  SuccessState(this.uId);
}

class RegisterErrorState extends RegisterState {
  final String error;

  RegisterErrorState( this.error);
}
class CreateUserInitialState extends RegisterState {

}
class CreateUserSuccessState extends RegisterState {}

class CreateUserErrorState extends RegisterState {
  final String error;

  CreateUserErrorState( this.error);
}

class ChangePasswordRegisterState extends RegisterState {}
