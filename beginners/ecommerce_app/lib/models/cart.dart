import 'package:ecommerce_app/models/shoe.dart';
import 'package:flutter/widgets.dart';

class Cart extends ChangeNotifier {
  // list of shoe for sale

  List<Shoe> shoeShop = [
    Shoe(
      name: 'Zoom FREAK',
      price: '236',
      imagePath: 'lib/images/shoe.jpg',
      description: 'The forward thinking design of his latest signature shoe.',
    ),
    Shoe(
      name: 'Air Jordan',
      price: '220',
      imagePath: 'lib/images/shoe1.jpg',
      description: 'The forward thinking design of his latest signature shoe.',
    ),
    Shoe(
      name: 'KID TRAY',
      price: '240',
      imagePath: 'lib/images/shoe2.jpg',
      description: 'The forward thinking design of his latest signature shoe.',
    ),
    Shoe(
      name: 'KYRIE 6',
      price: '190',
      imagePath: 'lib/images/shoe3.jpg',
      description: 'The forward thinking design of his latest signature shoe.',
    ),
  ];

  // list of item user put in the cart

  List<Shoe> userCart = [];

  // get list of shoes for sale

  List<Shoe> getShoeList() {
    return shoeShop;
  }

  // get cart
  List<Shoe> getUserCart() {
    return userCart;
  }

  // add items to the cart
  void addItemToCart(Shoe shoe) {
    userCart.add(shoe);
    notifyListeners();
  }

  // remove item from the cart
  void removeItemFromCart(Shoe shoe) {
    userCart.remove(shoe);
    notifyListeners();
  }
}
