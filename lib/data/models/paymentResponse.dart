class PaymentResponse{
  final String? url;
  final String? success_url;
  final String? fail_url;

  PaymentResponse(this.url, this.success_url, this.fail_url);

  factory PaymentResponse.fromJson(Map<String,dynamic> json){
    return PaymentResponse(json['url'],json['success_url'] ,json['fail_url'] );
  }
}