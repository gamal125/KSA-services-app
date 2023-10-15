
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
   int bonus=0;
   int cash=0;

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
     required this.bonus,
     required this.cash,


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
     bonus=json['bonus'];
     cash=json['cash'];




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
       'bonus':bonus,
       'cash':cash,




     };
   }


}