import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';

class ProductCard extends StatefulWidget {
  int id;
  String image;
  String name;
  String main_price;
  String stroked_price;
  bool has_discount;

  ProductCard(
      {Key key,
      this.id,
      this.image,
      this.name,
      this.main_price,
      this.stroked_price,
      this.has_discount})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  dynamic  getdiscount(){

      var  main_price=widget.main_price.replaceAll(RegExp(r'SR'), '');
      var stroked_price=widget.stroked_price.replaceAll(RegExp(r'SR'), '');
      if(widget.stroked_price.contains(",")){

        var main_price2=main_price.replaceAll(RegExp(r','), '');
        var stroked_price2=stroked_price.replaceAll(RegExp(r','), '');

        return (((double.parse(stroked_price2)-double.parse(main_price2))/double.parse(stroked_price2))*100).round();
      }else{
        return (((double.parse(stroked_price)-double.parse(main_price)) / double.parse(stroked_price))*100).round();
      }
  }

  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48) / 2);

    return InkWell(
      onTap: () {
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: Duration(milliseconds:400),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation=CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
            return ScaleTransition(
                alignment: Alignment.bottomCenter,
                child: child,
                scale: animation);
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            return ProductDetails(
              id: widget.id,
            );
          },));
      },
      child: Stack(
        children: [
          Card(
            //clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 4.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        //height: 158,
                        height: ((MediaQuery.of(context).size.width - 28) / 2) + 2,
                        child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16), bottom: Radius.zero),
                            child: FadeInImage.assetNetwork(
                              placeholderErrorBuilder: (context, error, stackTrace) {
                                    return Image.asset("assets/placeholder.png", fit: BoxFit.fill,);
                              },
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: 'assets/placeholder.png',
                              image:  widget.image==null ||widget.image==""?"https://yeshtry.com/public/assets/img/placeholder.jpg":widget.image,
                              fit:BoxFit.fill,
                            ))),
                  ),
                  Container(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Text(
                            widget.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                color: MyTheme.font_grey,
                                fontSize: 14,
                                height: 1.2,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                          child: Text(
                            widget.main_price,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        widget.has_discount
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                                child: Text(
                                  widget.stroked_price,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: MyTheme.medium_grey,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ]),
          ),
          if(widget.has_discount&&widget.main_price.startsWith("SR"))
          Positioned(
            top: 25,
            left: 0,
            child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(6)),
                ),
                color: MyTheme.accent_color,
               elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: !app_language_rtl.$ ?
                  Text("${getdiscount()} %",style: TextStyle(color: MyTheme.white,fontWeight: FontWeight.bold),)
                      :  Text("% ${getdiscount()}",style: TextStyle(color: MyTheme.white,fontWeight: FontWeight.bold),),
                )),
          )
        ],
      ),
    );
  }
}
