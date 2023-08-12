<?php


abstract class PaymentModule extends PaymentModuleCore
{
   protected function createOrderFromCart(
        Cart $cart,
        Currency $currency,
        $productList,
        $addressId,
        $context,
        $reference,
        $secure_key,
        $payment_method,
        $name,
        $dont_touch_amount,
        $amount_paid,
        $warehouseId,
        $cart_total_paid,
        $debug,
        $order_status,
        $id_order_state,
        $carrierId = null
    ){
        $orderData = parent::createOrderFromCart(
            $cart,
            $currency,
            $productList,
            $addressId,
            $context,
            $reference,
            $secure_key,
            $payment_method,
            $name,
            $dont_touch_amount,
            $amount_paid,
            $warehouseId,
            $cart_total_paid,
            $debug,
            $order_status,
            $id_order_state,
            $carrierId);
        $this->order = $orderData['order'];
        return $orderData ;
    } 
}