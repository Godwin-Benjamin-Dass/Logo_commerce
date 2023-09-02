import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logo_commerce/Model/product.dart';
import 'package:logo_commerce/View_Model/Product_Provider.dart';
import 'package:logo_commerce/screens/pages/uploadLogoFlow/CheckoutPage.dart';
import 'package:provider/provider.dart';
import 'package:widget_mask/widget_mask.dart';

List<String> t_shirt = <String>["S", "M", "L", "XL", "XXL"];
List<String> bottle = <String>["250ml", "500ml", "1L", "1.5L"];
List<String> hoodie = <String>["S", "M", "L", "XL", "XXL"];
List<String> note = <String>["80pg", "100pg", "150pg", "200pg", "250pg"];
List<String> collar = <String>["S", "M", "L", "XL", "XXL"];

class PreviewPage extends StatefulWidget {
  final File logoImage;

  const PreviewPage({required this.logoImage});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  List<product> products = [];

  String Tdv = t_shirt.first;
  String Bdv = bottle.first;
  String Hdv = hoodie.first;
  String Ndv = note.first;
  String Cdv = collar.first;

  TextEditingController t_shirtController = TextEditingController();
  TextEditingController bottleController = TextEditingController();
  TextEditingController hoodieController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController collarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    addProduct(product pro) {
      int c = 0;
      for (int i = 0; i < products.length; i++) {
        if (products[i].name == pro.name) {
          c = 1;
          break;
        }
      }
      if (c == 0) {
        products.add(pro);
        setState(() {});
      } else {
        return showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Already Added'),
                  content: ElevatedButton(
                      onPressed: () {
                        products.removeWhere((element) => element.id == pro.id);
                        setState(() {});

                        Navigator.pop(context);
                      },
                      child: const Text("Remove")),
                ));
      }
    }

    double subtotal(List<product> pro) {
      double sum = 0;
      for (int i = 0; i < pro.length; i++) {
        sum += double.parse(pro[i].price);
      }
      return sum;
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("ALERT"),
        content: const Text("The cart cant be empty!!!"),
        actions: [
          cancelButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    AddDataAlert(BuildContext context) {
      // set up the buttons
      Widget cancelButton = TextButton(
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: const Text("ALERT"),
        content: const Text("Enter a valid quantity"),
        actions: [
          cancelButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    var _Products = Provider.of<ProductProvider>(context);
    t_shirtController.text = "1";
    bottleController.text = "1";
    hoodieController.text = "1";
    noteController.text = "1";
    collarController.text = "1";
    double total() {
      double sum = 0;
      for (int i = 0; i < _Products.products.length; i++) {
        sum += double.parse(_Products.products[i].price) *
            int.parse(_Products.products[i].qty);
      }
      return sum;
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text('Preview'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pinkAccent, Colors.red],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'T-Shirt',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    SizedBox(
                      child: WidgetMask(
                        mask: Stack(
                          children: [
                            Positioned(
                              top: 80,
                              left: 130,
                              child: SizedBox(
                                height: 40,
                                width: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    widget.logoImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        blendMode: BlendMode.screen,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                                height: 250,
                                child: Image.asset(
                                    "assets/images/BlackShirt.png"))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Other T-Shirt details'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Quantity: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: t_shirtController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                                height: 50,
                                child: DropdownButton<String>(
                                  value: Tdv,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      Tdv = value!;
                                    });
                                  },
                                  items: t_shirt.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (t_shirtController.text != "" &&
                            int.parse(t_shirtController.text) > 0) {
                          _Products.AddProduct(product(
                              name: "T-Shirt",
                              price: "200",
                              id: _Products.products.length.toString(),
                              qty: t_shirtController.text.trim(),
                              size: Tdv));
                        } else {
                          AddDataAlert(context);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(173, 233, 30, 98),
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Water Bottle',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: WidgetMask(
                        mask: Stack(
                          children: [
                            Positioned(
                              top: 100,
                              left: 95,
                              child: SizedBox(
                                height: 40,
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    widget.logoImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        blendMode: BlendMode.screen,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                                height: 250,
                                child: Image.asset(
                                    "assets/images/BlackBottle.png"))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Other Water Bottle details'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Quantity: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: bottleController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                                height: 50,
                                child: DropdownButton<String>(
                                  value: Bdv,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      Bdv = value!;
                                    });
                                  },
                                  items: bottle.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (bottleController.text != "" &&
                            int.parse(bottleController.text) > 0) {
                          _Products.AddProduct(product(
                              name: "Bottle",
                              price: "120",
                              id: _Products.products.length.toString(),
                              qty: bottleController.text.trim(),
                              size: Bdv));
                        } else {
                          AddDataAlert(context);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(173, 233, 30, 98),
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hoodie',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: WidgetMask(
                        mask: Stack(
                          children: [
                            Positioned(
                              top: 90,
                              left: 85,
                              child: SizedBox(
                                height: 60,
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    widget.logoImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        blendMode: BlendMode.screen,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                                height: 250,
                                child: Image.asset(
                                    "assets/images/BlackHoodie.png"))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Other Hoodie details'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Quantity: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: hoodieController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                                height: 50,
                                child: DropdownButton<String>(
                                  value: Hdv,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      Hdv = value!;
                                    });
                                  },
                                  items: hoodie.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (hoodieController.text != "" &&
                            int.parse(hoodieController.text) > 0) {
                          _Products.AddProduct(product(
                              name: "Hoodie",
                              price: "450",
                              id: _Products.products.length.toString(),
                              qty: hoodieController.text.trim(),
                              size: Hdv));
                        } else {
                          AddDataAlert(context);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(173, 233, 30, 98),
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Note Book',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: WidgetMask(
                        mask: Stack(
                          children: [
                            Positioned(
                              top: 70,
                              left: 29,
                              child: SizedBox(
                                height: 90,
                                width: 110,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    widget.logoImage,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        blendMode: BlendMode.screen,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: SizedBox(
                                height: 250,
                                child: Image.asset(
                                    "assets/images/BlackNote.png"))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Other Note Book details'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Quantity: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: noteController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Size: ",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                                height: 50,
                                child: DropdownButton<String>(
                                  value: Ndv,
                                  elevation: 16,
                                  underline: Container(
                                    height: 2,
                                  ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      Ndv = value!;
                                    });
                                  },
                                  items: note.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (noteController.text != "" &&
                            int.parse(noteController.text) > 0) {
                          _Products.AddProduct(product(
                              name: "Note",
                              price: "80",
                              id: _Products.products.length.toString(),
                              qty: noteController.text.trim(),
                              size: Ndv));
                        } else {
                          AddDataAlert(context);
                        }
                      },
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(173, 233, 30, 98),
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Collar Shirt',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: WidgetMask(
                          mask: Stack(
                            children: [
                              Positioned(
                                top: 80,
                                left: 35,
                                child: SizedBox(
                                  height: 60,
                                  width: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      widget.logoImage,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          blendMode: BlendMode.screen,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                  height: 250,
                                  child: Image.asset(
                                      "assets/images/BlackShirtCollar.png"))),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Other Collar Shirt details'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Quantity: ",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: collarController,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Size: ",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                  height: 50,
                                  child: DropdownButton<String>(
                                    value: Cdv,
                                    elevation: 16,
                                    underline: Container(
                                      height: 2,
                                    ),
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        Cdv = value!;
                                      });
                                    },
                                    items: collar.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (collarController.text != "" &&
                              int.parse(collarController.text) > 0) {
                            _Products.AddProduct(product(
                                name: "Collar",
                                price: "250",
                                id: _Products.products.length.toString(),
                                qty: t_shirtController.text.trim(),
                                size: Cdv));
                          } else {
                            AddDataAlert(context);
                          }
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(173, 233, 30, 98),
                              borderRadius: BorderRadius.circular(8)),
                          alignment: Alignment.center,
                          child: const Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Column(
            children: [
              Text(
                "NO OF PRODUCTS: ${_Products.products.length}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    if (_Products.products.isNotEmpty) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                    logoImage: widget.logoImage,
                                    shipping: 5.00,
                                    subtotal: total(),
                                    total: 5 + total(),
                                    products: products,
                                  )));
                    } else {
                      showAlertDialog(context);
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      height: 60,
                      child: const Text(
                        "PROCEED TO CHECKOUT",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
