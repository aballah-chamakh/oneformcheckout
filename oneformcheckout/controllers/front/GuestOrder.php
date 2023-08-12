<?php

use PrestaShop\PrestaShop\Adapter\Presenter\Order\OrderPresenter;
class oneformcheckoutGuestOrderModuleFrontController extends ModuleFrontController
{    
    

    public function initContent()
    {
        parent::initContent();
        

        // RETURN THE ORDER CONFIRMATION PAGE
        if ($_SERVER['REQUEST_METHOD'] == 'GET') {
            
            $id_order = Tools::getValue('id_order') ;
            $order_ref = Tools::getValue('order_ref') ;
            
            if (!$id_order || !$order_ref){
                Tools::redirect(Context::getContext()->link->getPageLink('index'));
            }
    
            $order = new Order($id_order) ;
            
            // CHECK IF THE USER OWN THIS ORDER USING THE ORDER REF
            if($order->reference != $order_ref){
                $response = [
                    'status' => 'success',
                    'message' => "You don't have the access to the confirmation page of this order",
                ] ;
                header("HTTP/1.1 401 Unauthorized");
            }else{
                // RETURN THE CONFIRMATION PAGE OF THE ORDER
                
                $order_presenter = new OrderPresenter();
                $presentedOrder = $order_presenter->present($order);
        
                
                $this->context->smarty->assign(array(
                    'order' => $presentedOrder,
                ));
        

                return $this->setTemplate('module:oneformcheckout/views/templates/front/order-confirmation.tpl') ;   
            }
            
        }else if ($_SERVER['REQUEST_METHOD'] == 'POST') { //UPDATE THE CARRIER OR CREATE THE ORDER
            
            // GET THE JSON DATA OF THE REQUEST BODY
            $data = json_decode(file_get_contents('php://input'), true);
            
            // GET THE guest_order_action OF THE REQUEST QUERY PARAMETERS
            $guest_order_action = Tools::getValue('guest_order_action') ;
            
            
            $cart = $this->context->cart ;
            
            // HANDLE UPDATING THE DELIVERY MODE
            if ($guest_order_action == 'UPDATE_DELIVERY_MODE'){
                $cart->id_carrier = (int)$data['selected_carrier_id'] ;
                $selected_carrier_id = $data['selected_carrier_id'].',' ;
                
                if($cart->id_address_delivery != 0 ){
                    $delivery_option  = json_encode(array(strval($cart->id_address_delivery)=>$selected_carrier_id)) ;
                }else{
                    $delivery_option = '{"0":"'.$selected_carrier_id.'"}' ;
                }
                
                $cart->delivery_option = $delivery_option;
                $cart->save();
                
                $response = [
                    'status' => 'success',
                    'message' => 'selected carrier was updated successfully!',
                    'delivery_option' => $cart->delivery_option,
                    'id_address' => strval($cart->id_address_delivery),
                    'cart_id' =>  $this->context->cart->id,
                ];
    
                header('Content-Type: application/json');
                echo json_encode($response);
                exit ;
            }else if($guest_order_action == 'CREATE_GUEST_ORDER'){ // HANDLE CREATING THE GUEST ORDER


                // CAPTURE THE CUSTOMER BEFORE THE validateOrder METHOD CHANGE IT TO THE GUEST USER , WE DO THAT TO CLEAR THE SESSION IF THE USER LOGGED AFTER ORDER CREATION
                $customer = $this->context->customer ;
                $address = new Address();
                $address->id_customer = 1811; // TODO : ADD THE GUEST CUSTOMER AS A CONFIG
                $address->firstname = $data['firstname_lastname'];
                $address->lastname = "guest" ;
                $address->phone_mobile = (int)$data['phone_1'];
                $address->id_country = (int) Configuration::get('PS_COUNTRY_DEFAULT');
                
                
                if(isset($data['phone_2'])){
                    $address->phone =  $data['phone_2'] ; 
                }
                
                // FILL THE ADDRESS DATA BASED ON DELIVERY MODE
                if($data['delivery_mode'] == 'cod'){
                    $address->alias = "COD GUEST" ;
                    $address->city = $data['city']  ;
                    $address->delegation = $data['delegation']  ;
                    $address->address1 = $data['address']  ;
                    //$address->validateFields();
                    $address->save() ;    
                }else{
                    $address->alias = $data['relay']['Name'] ; ;
                    $address->city = $data['relay']['City']  ;
                    $address->address1 = $data['relay']['Address'] ;
                    //$address->validateFields($errorReturn=true);
                    $address->save() ;   
                }
                
                $guest_customer = new Customer(1811) ;
    
                // FILL THE CART WITH THE NEEDED DATA
                $cart->id_address_delivery = $address->id ; 
                $cart->id_address_invoice = $address->id ;
                $cart->id_customer = 1811;
                $cart->id_carrier = (int)$data['carrier_id'] ;
                $cart->secure_key = $guest_customer->secure_key ;
                $cart->setDeliveryOption(array( $address->id => $data['carrier_id'].',' ) ) ;
                $cart->save() ;

                
                // CREATE THE ORDER USING THE validateOrder OF THE PAYMENT MODULE   
                $this->module->validateOrder(
                    $cart->id,
                    12,
                    $cart->getOrderTotal(true, Cart::BOTH),
                    'COD',//$this->module->displayName,
                    null,
                    [],
                    null,
                    false,
                    $cart->secure_key
                ) ;


                // IF THE DELIVERY MODE IS A RELAY , SUBMIT THE ORDER TO LX
                if($data['delivery_mode'] != 'cod'){
                    $this->submitOrderToLoxbox($address,$data['relay']['Identifier'])   ;
                }
                
                if($customer && $customer->isLogged()){
                    $this->context->customer->logout() ;
                }
                $response = [
                    'status' => 'success',
                    'message' => 'order was created successfully!',
                    'order_ref' => $this->module->order->reference, // You can modify this based on your processing,
                    'id_order' =>  $this->module->order->id,
                    
                ];
          
        
                // Prepare your response JSON data (example: Here, we are sending a sample response)

        
            }else{
                $response = [
                'status' => 'error',
                'message' => 'you must specify the guest_order_action',
               ];
               header("HTTP/1.1 400 Bad Request");
            }
            
        }else{
            $response = [
                'status' => 'error',
                'message' => 'Only POST and GET request are allowed.',
               
            ];
            header("HTTP/1.1 405 Method Not Allowed");
        }
        
        header('Content-Type: application/json');
        echo json_encode($response);
        exit;


    }
    
    public function getCartProductsContent(){
        $content = "" ;
        $cart = $this->context->cart ;
        $cart_products = $cart->getProducts() ;
        $last_product_idx = count($cart_products) - 1 ;
        foreach($cart_products as $index=>$product){
            $content .= $product['quantity'] ." x ".  $product['name'] ;
            if($index != $last_product_idx){
                $content .=', ' ;
            }
        }
        return $content ;
    }
    
    public function submitOrderToLoxbox($address,$relay_id){
        // PREPARE THE PAYLOAD
        $token = Configuration::get('Loxbox');
        $cart = $this->context->cart ;
        $order = $this->module->order ;
        $comment = ($address->phone) ? "Téléphone2 : {$address->phone} --- " : "" ;
        $payload = array(
            "Content"=>$this->getCartProductsContent(),
            "detail"=>"",
            "IsPaid"=>0,
            "Price"=>$cart->getOrderTotal(true, Cart::BOTH),
            "Size"=>1,
            "Weight"=>1,
            "DestRelaypoint"=> (int)$relay_id ,
            "ReceiverName"=>$address->firstname,
            "ReceiverMail"=>'guestguest@mawlety.com',
            "ReceiverNumber"=> $address->phone_mobile,
            "ReceiverAddress"=>$address->address1 ,
            "Comment"=> $comment ."Ref : ".$order->reference,
            "AcceptsCheck"=>true,        
        ) ;
        
        // SEND THE REQUEST TO LOXBOX
        $curl = curl_init();
        // or use https://httpbin.org/ for testing purposes
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, 0);
        curl_setopt($curl, CURLOPT_URL, 'https://www.loxbox.tn/api/NewTransaction/');
        curl_setopt($curl, CURLOPT_FAILONERROR, true);
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, json_encode($payload));
        curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json', 'Accept:application/json','Authorization: Token '.$token.' '));
        $output = curl_exec($curl);
        // HANDLE THE RESPONSE OF THE REQUEST
        if ($output === FALSE) {
            echo 'An error has occurred: ' . curl_error($curl) . PHP_EOL;
        }
        else {
            // PAIR THE LOXBOX TRANSACTION ID AND THE ORDER ID THEN SAVE THEM
            $loxbox_transaction_id = json_decode($output,true)['Transaction_instance'];
            $db = Db::getInstance();
            $request = 'INSERT INTO loxbox_transactions VALUES('.$order->id.', '.$loxbox_transaction_id.')';
            $db->execute($request);
            //echo $output;
        }

    }
}