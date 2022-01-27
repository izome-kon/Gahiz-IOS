import 'package:cool_alert/cool_alert.dart';
import 'package:denta_needs/Apis/address_repositories.dart';
import 'package:denta_needs/Common/custom_scaffold.dart';
import 'package:denta_needs/Common/shimmer_helper.dart';
import 'package:denta_needs/Helper/applocal.dart';
import 'package:denta_needs/Responses/Address/address_response.dart';
import 'package:denta_needs/Screens/Address/edit_address.dart';
import 'package:denta_needs/Screens/SignUp/doctor_info.dart';
import 'package:denta_needs/Screens/map.dart';
import 'package:denta_needs/Utils/theme.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ViewAddress extends StatefulWidget {
  @override
  _ViewAddressState createState() => _ViewAddressState();
}

class _ViewAddressState extends State<ViewAddress> {
  List<Address> addressResponse;

  getData() async {
    addressResponse = await AddressRepository().getAddressList();
    if (this.mounted) setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getLang(context, "Your clinics"),
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: primaryColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (_) => UserLocation()))
              .then((value) {
            setState(() {
              addressResponse = null;
            });
            getData();
          });
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            addressResponse == null
                ? SliverToBoxAdapter(
                    child: ShimmerHelper().buildListShimmer(),
                  )
                : addressResponse.length == 0
                    ? buildNoClinicsFoundWidget()
                    : buildClinicsListWidget(),
          ],
        ),
      ),
    );
  }

  buildNoClinicsFoundWidget() {
    return SliverToBoxAdapter(
      child: Container(
          padding: EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/location.json',
                        repeat: true, width: 200),
                    Text(
                      getLang(context, 'No clinics added'),
                      style: TextStyle(
                          color: fontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getLang(context, "Get Started by adding your clinic now"),
                      style: TextStyle(color: fontColor.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  buildClinicsListWidget() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (context, index) {
        return buildAddressItemCard(index);
      },
      childCount: addressResponse.length,
    ));
  }

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: accentColor, width: 0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            getLang(context, "Clinic name"),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            addressResponse[index].clinicName,
                            maxLines: 2,
                            style: TextStyle(
                                color: fontColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            getLang(context, "Branch "),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            addressResponse[index].branchName,
                            maxLines: 2,
                            style: TextStyle(
                                color: fontColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            getLang(context, "Address"),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 175,
                          child: Text(
                            addressResponse[index].address,
                            maxLines: 2,
                            style: TextStyle(
                                color: fontColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            getLang(context, "City"),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            addressResponse[index].city,
                            maxLines: 2,
                            style: TextStyle(
                                color: fontColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 75,
                          child: Text(
                            getLang(context, "Country"),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          child: Text(
                            addressResponse[index].country,
                            maxLines: 2,
                            style: TextStyle(
                                color: fontColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
                right: 0.0,
                top: 0.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditAddress(
                                  address: addressResponse[index],
                                )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
                    child: Icon(
                      Icons.edit,
                      color: fontColor,
                      size: 16,
                    ),
                  ),
                )),
            Positioned(
                right: 0,
                top: 40.0,
                child: InkWell(
                  onTap: () {
                    onPressDelete(addressResponse[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: fontColor,
                      size: 16,
                    ),
                  ),
                )),
            Positioned(
              bottom: 2,
              right: 0,
              child: FlatButton(
                  color: addressResponse[index].setDefault != 1
                      ? primaryColor
                      : accentColor,
                  onPressed: () {
                    if (addressResponse[index].setDefault != 1) {
                      int id = addressResponse[index].id;
                      addressResponse = null;
                      setState(() {});
                      AddressRepository()
                          .getAddressMakeDefaultResponse(id)
                          .then((value) {
                        getData();
                        if (value.result) {
                          showTopSnackBar(
                            context,
                            CustomSnackBar.success(
                              message: value.message,
                              backgroundColor: Colors.green,
                            ),
                            displayDuration: Duration(seconds: 1),
                          );
                          Navigator.pop(context);
                        } else {
                          //wrong

                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: value.message,
                            ),
                            displayDuration: Duration(seconds: 1),
                          );
                        }
                      });
                    }
                  },
                  child: Container(
                    child: Text(
                      addressResponse[index].setDefault != 1
                          ? getLang(context, 'Set Default')
                          : getLang(context, 'Default'),
                      style: TextStyle(color: whiteColor),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void onPressDelete(int id) {
    CoolAlert.show(
        context: context,
        type: CoolAlertType.warning,
        text: getLang(context, "Are you sure to this address?"),
        confirmBtnText: 'Delete',
        cancelBtnText: 'Cancel',
        showCancelBtn: true,
        confirmBtnColor: Colors.red,
        onConfirmBtnTap: () {
          AddressRepository().getAddressDeleteResponse(id).then((value) {
            if (value.result) {
              showTopSnackBar(
                context,
                CustomSnackBar.success(
                  message: value.message,
                  backgroundColor: Colors.green,
                ),
                displayDuration: Duration(seconds: 1),
              );

              setState(() {
                addressResponse = null;
              });
              getData();
            } else {
              //wrong

              showTopSnackBar(
                context,
                CustomSnackBar.error(
                  message: value.message,
                ),
                displayDuration: Duration(seconds: 1),
              );
            }
          });
          Navigator.pop(context);
        });
  }
}
