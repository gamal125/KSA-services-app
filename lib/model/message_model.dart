class messageModel{

  String? date;
  String? S_uId;
  String? R_uId;
  String? text;




  messageModel({

    this.date,
    this.S_uId,
    this.R_uId,
    this.text,


  });


  messageModel.fromjson(Map<String,dynamic>json){

    date=json['date'];
    text=json['text'];
    S_uId=json['S_uId'];
    R_uId=json['R_uId'];





  }
  Map<String,dynamic>Tomap(){
    return{

      'date':date,
      'text':text,
      'S_uId':S_uId,
      'R_uId':R_uId,



    };
  }
}