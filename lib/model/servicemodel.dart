class ServiceModel{

  String? price;

  String? name;




  ServiceModel({

    this.price,

    this.name,


  });


  ServiceModel.fromjson(Map<String,dynamic>json){

    price=json['price'];
    name=json['name'];






  }
  Map<String,dynamic>Tomap(){
    return{

      'price':price,
      'name':name,




    };
  }
}