class ApiContest {
  static const String baseUrl = 'https://accept.paymob.com/api';
  static const String paymentApiKey =
      "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2T1RBeE16TTJMQ0p1WVcxbElqb2lhVzVwZEdsaGJDSjkuTVlxZnVtbEU2cWh5NzJpRVBkRkFBbVV5WE5YSl9PYUc5QTJ5cFk5ZW0zZXRJU3MyeTZjZDdHd3NiSlE1cDFfQXF3M3o0aXJKQTdvYlZNVGlhYzAyUnc=";
  static const String getAuthToken = '/auth/tokens';
  static const getOrderId = '/ecommerce/orders';
  static const getPaymentRequest = '/acceptance/payment_keys';
  static const getRefCode = '/acceptance/payments/pay';
  static String visaUrl =
      '$baseUrl/acceptance/iframes/787887?payment_token=$finalToken';
  static String paymentFirstToken = '';

  static String paymentOrderId = '';

  static String finalToken = '';

  static const String integrationIdCard = '4207259';
  static const String integrationIdKiosk = '4207343';

  static String refCode = '';
}
