<?php

if (!defined('_PS_VERSION_')) {
    exit;
}
use PrestaShop\PrestaShop\Core\Payment\PaymentOption;

class OneFormCheckout extends PaymentModule
{
    public function __construct()
    {
        $this->name = 'oneformcheckout';
        $this->tab = 'checkout';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;

        parent::__construct();

        $this->displayName = $this->l('One Form Checkout');
        $this->description = $this->l('Custom checkout form with API integration');
    }

    public function install()
    {
        return parent::install() && $this->registerHook('displaySingleFormCheckout') 
                                 && $this->registerHook('displayAfterBeforeBodyClosingTag') 
                                 && $this->registerHook('header')
                                 && $this->registerHook('paymentOptions') 
                                 && $this->registerHook('paymentReturn');
    }

    public function uninstall()
    {
        return parent::uninstall();
    }
    

    public function hookHeader($params)
    {
        Media::addJsDef(array(
            'guest_order_link' => $this->context->link->getModuleLink('oneformcheckout', 'GuestOrder')
        ));
        //
    }
    
    
    public function hookDisplayAfterBeforeBodyClosingTag($params)
    {
      return $this->display(__FILE__, 'views/templates/hook/checkout-form-js.tpl');
    }
    
    public function getSelectedCarrierId($cart,$active_carriers_ids){
        if($cart->delivery_option){
            $selected_carrier_id  = intval(str_replace(',','',current(json_decode($cart->delivery_option,true)))) ;
            if(in_array($selected_carrier_id,$active_carriers_ids)){
                return $selected_carrier_id ;
            }
        }
        return null  ;
    }
    
    public function hookDisplaySingleFormCheckout($params)
    {
  

        $active_carriers = Carrier::getCarriers(1, $active = true, $delete = false, $id_zone = false, $ids_group = null, $modules_filters = 5);
        $active_carriers_ids = array($active_carriers[0]['id_carrier'],$active_carriers[1]['id_carrier']) ;
        $delivery_options_list = $this->context->cart->getDeliveryOptionList();
        $cart = $this->context->cart ;
        
        $carrier_data = array('carriers'=>array(
                                                array('carrier_id'=>$active_carriers_ids[0],
                                                      'name'=>$active_carriers[0]['name'],
                                                      'price'=>current($delivery_options_list)[strval($active_carriers[0]['id_carrier']).',']['total_price_without_tax'],
                                                ),   
                                                array('carrier_id'=>$active_carriers_ids[1],
                                                      'name'=>$active_carriers[1]['name'],
                                                      'price'=>current($delivery_options_list)[strval($active_carriers[1]['id_carrier']).',']['total_price_without_tax'],
                                                )
                                            ),
                              'selected_carrier_id' => $this->getSelectedCarrierId($cart,$active_carriers_ids)   //$cart->delivery_option ? intval(str_replace(',','',current(json_decode($cart->delivery_option,true)))) : null  ,
                        );
  

        $this->context->smarty->assign(array(
            'formAction' => "", // $this->context->link->getModuleLink('oneformcheckout', 'processForm'),
            'valid' => 200,
            'carrier_data'=>$carrier_data
        ));

        return $this->display(__FILE__, 'views/templates/hook/checkout-form.tpl');
    }
}