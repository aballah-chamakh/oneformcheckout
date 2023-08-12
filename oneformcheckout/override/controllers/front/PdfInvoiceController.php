<?php


class PdfInvoiceController extends PdfInvoiceControllerCore {
        public function postProcess()
    {
        


        if (!(int) Configuration::get('PS_INVOICE')) {
            die($this->trans('Invoices are disabled in this shop.', [], 'Shop.Notifications.Error'));
        }
        
        
        $id_order = (int) Tools::getValue('id_order');
        if (Validate::isUnsignedId($id_order)) {
            $order = new Order((int) $id_order);
        }


        if (!isset($order) || !Validate::isLoadedObject($order)) {
            die($this->trans('The invoice was not found.', [], 'Shop.Notifications.Error'));
        }
        
        if (Tools::getValue('order_ref') != $order->reference ) {
            die("You don't have the permission to access the invoice of this order");
        }

        if (!OrderState::invoiceAvailable($order->getCurrentState()) && !$order->invoice_number) {
            die($this->trans('No invoice is available.', [], 'Shop.Notifications.Error'));
        }

        $this->order = $order;
    }
}