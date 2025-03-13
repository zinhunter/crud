import ListBase "mo:base/List";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Text "mo:base/Text";
import Result "mo:base/Result";

actor {
  // Record
  type CartItem = {
    product_id : Nat; 
    quantity : Nat; 
    price : Nat;
  };

  // Array -> Lista ordenada 
  type ShoppingCart = [CartItem];

  public func calculateCartTotal(cart : ShoppingCart) : async Nat {
    var total : Nat = 0;

    for (item in cart.vals()) {
      // total := total + (item.price * item.quantity);
      total += item.price * item.quantity;
    };

    return total;
  };

  // 390, 10, 400

  public func applyDiscount(total : Nat, discount_rate : Nat, min_total : Nat) : async Nat {
    var discounted_total : Nat = total;
    var current_discount : Nat = discount_rate;

    while (discounted_total > min_total and current_discount > 0) {
      discounted_total := discounted_total - (discounted_total * current_discount / 100);
      current_discount := current_discount - 5; // Reduce discount rate by 5% each time
    };

    return discounted_total;
  };

  type Product = {
    product_id : Nat;
    name : Text;
    description : Text;
    price : Nat;
    stock_quantity : Nat
  };

  type ProductCatalog = [Product];

  // [Nat]
  // (Nat, Nat)

  // Tuples: Returning product ID and updated stock
  public func updateStock(product : Product, quantity_sold : Nat) : async (Nat, Nat) {
    let new_stock: Nat = product.stock_quantity - quantity_sold;
    return (product.product_id, new_stock);
  };

  type Order = {
    order_id : Nat;
    customer_id : Nat;
    items : ShoppingCart;
    total : Nat
  };

  let history : ListBase.List<Order> = ListBase.nil();

  // Function to add an order to the history
  public func addOrder(order : Order) : async ListBase.List<Order> {
    return ListBase.push(order, history);
  };

  // Representing a customer
  type Customer = {
    customer_id : Nat;
    name : Text;
    email : Text
  };

  let customers = HashMap.HashMap<Nat, Customer>(0, Nat.equal, Hash.hash);

  // Function to create a customer map
  public func createCustomer(customer : Customer) : async () {
    customers.put(customer.customer_id, customer);
  };

  // Variant to represent the result of a payment
  type PaymentResult = {
    #ok : Nat;
    #err : Text;
  };

  type ProcessPaymentResult = Result.Result<Nat, Text>;

  // Function to process payment
  public func processPayment(amount : Nat, card_number : Text) : async ProcessPaymentResult {
    // Simulate payment processing (in reality, you'd integrate with a payment gateway)
    if (Text.size(card_number) > 10) {
      // Simple validation
      return #ok(amount);
    } else {
      return #err("Invalid card number");
    }
  };
};