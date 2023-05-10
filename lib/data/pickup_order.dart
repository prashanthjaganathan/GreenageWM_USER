String disposalSize = "";
Map<String, double> disposalSizeRates = {
  "Small": 10,
  "Medium": 20,
  "Large": 100,
  "": 0
};
double pickupFee =
    disposalSize == "" ? 0.0 : (disposalSizeRates[disposalSize]!);
double totalBillAmount = 0;
double tipAmount = 0;
double gstRate = 0.18;
double taxAmount = 0;
late String pickupAddressName = "";
late String pickupAddressBrief = "";
int estimatePickupTime = 15;
late String pickupAddress = "";
int pointsEarned = 0;
