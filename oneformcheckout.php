<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class OneFormCheckout extends Module
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
        return parent::install() && $this->registerHook('displaySingleFormCheckout');
    }

    public function uninstall()
    {
        return parent::uninstall();
    }

    public function hookDisplaySingleFormCheckout($params)
    {
        $this->context->smarty->assign(array(
            'formAction' => "", // $this->context->link->getModuleLink('oneformcheckout', 'processForm'),
        ));

        return $this->display(__FILE__, 'views/templates/hook/checkout-form.tpl');
    }
}