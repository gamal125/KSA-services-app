class PriceModel{

  String? price;






  PriceModel({

    this.price,




  });


  PriceModel.fromjson(Map<String,dynamic>json){

    price=json['price'];







  }
  Map<String,dynamic>Tomap(){
    return{

      'price':price,





    };
  }
}