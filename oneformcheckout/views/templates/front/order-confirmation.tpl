{extends file='page.tpl'}


{block name='page_content_container' prepend}

<style>
    *{
        font-size : 16px;
    }
   #content-hook_order_confirmation .order-confirmation-header{
       display : flex ;
       justify-content: space-between;
       align-items : center;
       margin-bottom : 10px;
   }
   #content-hook_order_confirmation .order-confirmation-header h3{
       margin-bottom : 0px;
   }
    #content-hook_order_confirmation .order-confirmation-header .invoice-link{
       background-color : #364620 ;
       color : white;
       padding :15px 20px;
       border-radius:5px;
   }
    @media (max-width:768px) {
       #content-hook_order_confirmation .order-confirmation-header{
           display : flex ;
           flex-direction :column;
           align-items : flex-start;
       }
       #content-hook_order_confirmation .order-confirmation-header .invoice-link{
           width: 100%;
       }
       #content-hook_order_confirmation .order-confirmation-header h3{
         margin-bottom : 10px;
       }
       
        
    }
</style>
    <section id="content-hook_order_confirmation" >
   
        <div class="order-confirmation-header">
   
           
            {block name='order_confirmation_header'}
            
              <h3 class="h1 card-title">
                <i class="material-icons rtl-no-flip done">&#xE876;</i>{l s='Your order is confirmed' d='Shop.Theme.Checkout'}
              </h3>
            {/block}

           
           
              {if $order.details.invoice_url}
                 <a class="invoice-link" href={$order.details.invoice_url}&order_ref={$order.details.reference} >Télécharger votre facture</a>
              {/if}
            

  
        

      </div>
    </section>
{/block}

{block name='page_content_container'}
  <section id="content" class="page-content page-order-confirmation card">
    <div class="card-block">
      <div class="row">

        {block name='order_confirmation_table'}
          {include
            file='checkout/_partials/order-confirmation-table.tpl'
            products=$order.products
            subtotals=$order.subtotals
            totals=$order.totals
            labels=$order.labels
            add_product_link=false
          }
        {/block}

        {block name='order_details'}
          <div id="order-details" class="col-md-12">
            <h3 class="h3 card-title" style="border-bottom:1px solid ;padding-bottom:10px;margin-bottom:10px">{l s='Order details' d='Shop.Theme.Checkout'}:</h3>
            
            <ul>
              <li>{l s='Order reference: %reference%' d='Shop.Theme.Checkout' sprintf=['%reference%' => $order.details.reference]}</li>
              <li>{l s='Payment method: %method%' d='Shop.Theme.Checkout' sprintf=['%method%' => $order.details.payment]}</li>
              {if !$order.details.is_virtual}
                <li>
                  {l s='Shipping method: %method%' d='Shop.Theme.Checkout' sprintf=['%method%' => $order.carrier.name]}<br>
                  <em>{$order.carrier.delay}</em>
                </li>
              {/if}
            </ul>
          </div>
        {/block}

      </div>
    </div>
  </section>
  {block name='hook_order_confirmation_2'}
    <section id="content-hook-order-confirmation-footer">
      {hook h='displayOrderConfirmation2'}
    </section>
  {/block}



{/block}
