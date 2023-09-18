
class UserModel{
   String? email;
   String? uId;
   String? name;
   String? phone;
   String? image;
   bool male=true;
   bool state=false;
   bool user=false;
   bool available=true;

   UserModel({
     this.name,
     this.phone,
     this.uId,
     this.email,
     this.image,
     required this.male,
     required this.state,
     required this.user,
     required this.available,


});

   UserModel.fromjson(Map<String,dynamic>json){
     name=json['name'];
     phone=json['phone'];
     email=json['email'];
     uId=json['uId'];
     image=json['image'];
     male=json['male'];
     available=json['available'];
     state=json['state'];
     user=json['user'];




   }
   Map<String,dynamic> Tomap(){
     return{
       'name':name,
       'phone':phone,
       'email':email,
       'uId':uId,
       'image':image,
       'male':male,
       'available':available,
       'state':state,
       'user':user,




     };
   }


}