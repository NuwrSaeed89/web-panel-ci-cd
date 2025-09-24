import 'package:brother_admin_panel/data/models/order_model.dart';
import 'package:brother_admin_panel/data/models/address_model.dart';
import 'package:brother_admin_panel/data/models/cart_item_model.dart';
import 'package:brother_admin_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:brother_admin_panel/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OrderRepository extends GetxController {
  static OrderRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = // 'EyTbtgIxRwamzlhsPnSs4lehlcc2';
          AuthenticationRepository.instance.authUser!.uid;
      // if (userId.isEmpty) {
      //   throw 'Unable to find user information. try again later';
      // }
      final result =
          await _db.collection('Users').doc(userId).collection('Orders').get();
      return result.docs.map(OrderModel.fromSnapshot).toList();
    } catch (e) {
      throw 'Something wrong while fetch order data';
    }
  }

  Future<void> saveOrder(OrderModel order, String userId) async {
    try {
      _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .add(order.toJson());
    } catch (e) {
      throw "Something wrong while saving Order data";
    }
  }

  // Fetch all orders from all users (for admin panel)
  Future<List<OrderModel>> fetchAllOrders() async {
    try {
      final usersSnapshot = await _db.collection('Users').get();
      final List<OrderModel> allOrders = [];

      for (final userDoc in usersSnapshot.docs) {
        try {
          final ordersSnapshot =
              await userDoc.reference.collection('Orders').get();
          for (final orderDoc in ordersSnapshot.docs) {
            try {
              // Get the order data and add the correct IDs
              final orderData = orderDoc.data();
              orderData['Id'] = orderDoc.id;
              orderData['UserId'] = userDoc.id;

              // Create OrderModel directly from the data
              final order = OrderModel(
                id: orderDoc.id,
                userId: userDoc.id,
                status: OrderStatus.values.firstWhere(
                  (element) => element.toString() == orderData['Status'],
                  orElse: () => OrderStatus.pending,
                ),
                totalAmount: (orderData['TotalAmount'] as num).toDouble(),
                orderDate: (orderData['OrderDate'] as Timestamp).toDate(),
                paymentMethod: orderData['PaymentMethod'] as String? ?? 'Stripe',
                address: orderData['Address'] != null
                    ? AddressModel.fromMap(orderData['Address'] as Map<String, dynamic>)
                    : null,
                deliveryDate: orderData['DeliveryDate'] != null
                    ? (orderData['DeliveryDate'] as Timestamp).toDate()
                    : null,
                items: (orderData['Items'] as List<dynamic>?)
                        ?.map((itemData) => CartItemModel.fromJason(itemData as Map<String, dynamic>))
                        .toList() ??
                    [],
              );

              allOrders.add(order);
            } catch (e) {
              // Skip this specific order if there's an error
              print('Error processing order ${orderDoc.id}: $e');
              continue;
            }
          }
        } catch (e) {
          // Skip user if there's an error fetching their orders
          print('Error fetching orders for user ${userDoc.id}: $e');
          continue;
        }
      }

      return allOrders;
    } catch (e) {
      throw 'Something wrong while fetch all orders data: $e';
    }
  }

  // Update order status
  Future<void> updateOrderStatus(
      String orderId, String userId, String newStatus) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc(orderId)
          .update({'Status': newStatus});
    } catch (e) {
      throw "Something wrong while updating order status: $e";
    }
  }

  ///clear the selected address for all addresses

  // Future<void> updateSelectedAddress(String addressId, bool selected) async {
  //   try {
  //     final userId = 'EyTbtgIxRwamzlhsPnSs4lehlcc2';
  //     //final userId = AuthenticationRepository.instance.authUser!.uid;
  //     await _db
  //         .collection('Users')
  //         .doc(userId)
  //         .collection('Addresses')
  //         .doc(addressId)
  //         .update({'SelectedAddress': selected});
  //   } catch (e) {
  //     throw 'wwwwwwwwwwwwwwrrrrrrrrrrrrrooooooooonnnnnnnnnnnggggggggg';
  //   }
  // }

  // Future<String> addAddress(AddressModel address) async {
  //   try {
  //     const userId = 'EyTbtgIxRwamzlhsPnSs4lehlcc2';
  //     // AuthenticationRepository.instance.authUser!.uid;
  //     final currentAddress = await _db
  //         .collection('Users')
  //         .doc(userId)
  //         .collection('Addresses')
  //         .add(address.toJson());
  //     if (kDebugMode) {
  //       print('currentAddress $currentAddress.id');
  //     }
  //     return currentAddress.id;
  //   } catch (e) {
  //     throw 'Some thing wrong while saving address';
  //   }
//  }
}
