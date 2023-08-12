{literal}

<style>
    /* HIDE THE PROMO CODE IN THE ONE FORM CHECKOUT PAGE */
    .block-promo .collapse-button.promo-code-button,.block-promo .cart-summary-line a {
        display : none;
    }
    /* END HIDE THE PROMO CODE IN THE ONE FORM CHECKOUT PAGE */
    
    .oneformcheckout{
        width : 100% ;
        border : 1px solid #ddd;
        padding : 10px ;
    }
    .oneformcheckout p{
        margin : 0px;
        padding : 0px;
    }
    .oneformcheckout .lx-relay-point-alert{
        background-color : #FFF0ED;
        color :#EC9782;
        padding : 5px;
        padding-left : 10px;
        border-radius : 5px;
        border : 1px solid #EC9782;
        margin-top : 10px;
        display : none;
      
    }
    .oneformcheckout .oneformcheckout-header{
        border-bottom : 1px solid #ddd;
        margin-bottom : 5px;
    }
    .oneformcheckout .oneformcheckout-header p{
        text-transform :uppercase;
        
    }
    .oneformcheckout #oneformcheckout-submit-btn{
        border : none;
        background-color : #364620;
        width : 100%;
        color : white;
        border-radius : 5px;
        margin-top : 0px;
        padding : 5px;
        display : flex;
        justify-content :center;
        
        text-transform : uppercase;
    }

    /* START STYLING THE SUBMIT BTN LOADER */
    .oneformcheckout  .dot-elastic {
      position: relative;
      margin  :9px auto;
      width: 10px;
      height: 10px;
      border-radius: 5px;

      animation: dot-elastic 1s infinite linear;
    }
    .oneformcheckout  .dot-elastic::before, .dot-elastic::after {
      content: "";
      display: inline-block;
      position: absolute;
      top: 0;
    }
    .oneformcheckout .dot-elastic::before {
      left: -15px;
      width: 10px;
      height: 10px;
      border-radius: 5px;


      animation: dot-elastic-before 1s infinite linear;
    }
    .oneformcheckout .dot-elastic::after {
      left: 15px;
      width: 10px;
      height: 10px;
      border-radius: 5px;


      animation: dot-elastic-after 1s infinite linear;
    }
    
    .oneformcheckout  .submit-btn.dot-elastic,.oneformcheckout .submit-btn.dot-elastic::before,.oneformcheckout .submit-btn.dot-elastic::after{
      color: white;
      background-color:white;
    }
    
    @keyframes dot-elastic-before {
      0% {
        transform: scale(1, 1);
      }
      25% {
        transform: scale(1, 1.5);
      }
      50% {
        transform: scale(1, 0.67);
      }
      75% {
        transform: scale(1, 1);
      }
      100% {
        transform: scale(1, 1);
      }
    }
    @keyframes dot-elastic {
      0% {
        transform: scale(1, 1);
      }
      25% {
        transform: scale(1, 1);
      }
      50% {
        transform: scale(1, 1.5);
      }
      75% {
        transform: scale(1, 1);
      }
      100% {
        transform: scale(1, 1);
      }
    }
    @keyframes dot-elastic-after {
      0% {
        transform: scale(1, 1);
      }
      25% {
        transform: scale(1, 1);
      }
      50% {
        transform: scale(1, 0.67);
      }
      75% {
        transform: scale(1, 1.5);
      }
      100% {
        transform: scale(1, 1);
      }
    }
    /* END STYLING THE SUBMIT BTN LOADER */
    
    .oneformcheckout form {
         width : 100% ;
         margin-top: 10px;
    }
    
    .oneformcheckout form input,select{
       width : 100% ;
       outline: none;
       border : 1px solid #ddd;
       padding-left : 5px ;
       border-radius : 5px;
       margin-bottom : 10px;
    }
    .oneformcheckout form input[name='phone1'],.oneformcheckout form input[name='phone2'],.oneformcheckout form input[name='address']{
        margin-bottom : 0px;
    }
    
    .oneformcheckout form select{
        padding-left : 0px ;
        font-size : 15px;
        padding :5px 0px 5px 0px;
      
     
    }
    .oneformcheckout form select{
        color : #999;
    }

    .oneformcheckout .form-group{
        width : 100%;
        margin : 0px;

       
    }

    .oneformcheckout .form-group #show-phone2-field,#hide-phone2-field{
        color : green;
        font-weight : 600; 
        font-size : 11px;
        margin : 0px;
        margin-left : 5px;
        cursor : pointer;
    }
    .oneformcheckout .form-group #show-phone2-field:hover{
       
         border-bottom : 1px solid green;
    }
    .oneformcheckout .form-group #hide-phone2-field:hover{
        border-bottom : 1px solid green;
    }
    
    .oneformcheckout  .delivery-mode-container{
        width : 100%;
    }
    .oneformcheckout  .delivery-mode-item{
        width : 100%;
        margin-bottom : 10px;
    }
    /* START STYLING THE DELIVERY MODE ITEM HEADER */
     .oneformcheckout .delivery-mode-item .delivery-mode-item-header{
         display : flex;
         justify-content : space-between;
         background-color : #F7FAF6;
         border-radius : 5px;
         width : 100%;
         padding :5px;
         align-items : center;
         border : 1px solid #ddd;
        
     }

     
     .oneformcheckout .delivery-mode-item .delivery-mode-item-header .delivery-mode-item-header-start{
         display : flex;
         align-items : center;
     }
     .oneformcheckout .delivery-mode-item .delivery-mode-item-header .delivery-mode-item-header-start p{
        position : relative;
        left : 20px;

     }


 
    /* END STYLING THE DELIVERY MODE ITEM HEADER */
    
    /* START STYLING THE DELIVERY MODE ITEM BODY */
    .oneformcheckout .delivery-mode-item .delivery-mode-item-body {
       
        border : 1px solid #ddd;
        border-top: none;
        
        padding :10px ;
    
    }
    
    
    /* END STYLING THE DELIVERY MODE ITEM BODY */
    
    
    
    /* START STYLING AND CREATING THE CUSTOM CHECKBOX OF THE DELIVER MODE */
    .oneformcheckout .delivery-mode-item .checkbox-container{
        display: block;
        position: relative;
        cursor: pointer;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
        margin : auto 0px auto 0px;
       
       
    }
    
    .oneformcheckout .delivery-mode-item .checkbox-container input{
       
        opacity:  0;
    }
    
   .oneformcheckout .delivery-mode-item .checkbox-container .fake-checkbox{
        position: absolute;
        left: 0px;
        top: 0px;
        width: 25px;
        height: 25px;
        background-color: #F9F9F9;
        border: 1px solid #D0D0D0 ;
        border-radius: 5px;
        top: 50%;
        transform: translateY(-50%);
    }
    
    .oneformcheckout .delivery-mode-item .checkbox-container .fake-checkbox::after{
        content: "";
        position: absolute;
        left: 7px;
        top: 2px;
        width: 10px;
        height: 15px;
        border: solid #364620;
        border-width: 0 2px 2px 0;
        -webkit-transform: rotate(45deg);
        -ms-transform: rotate(45deg);
        transform: rotate(45deg);
        display: none;
    }
    
    .oneformcheckout .delivery-mode-item .checkbox-container .fake-checkbox:hover{
        background-color: #E8E8E8;
    }
    
    .oneformcheckout .delivery-mode-item .checkbox-container input:checked  ~ .fake-checkbox::after {
        display: block;
    }
    
    /* END STYLING AND CREATING THE CUSTOM CHECKOUT */
    
    /* START STYLING VALID AND INVALID FORMS */
    .fail-alert{
        margin-bottom : Opx;
         direction: ltr;
    }
    .success-alert{
         direction: ltr;
    }
    .oneformcheckout label.fail-alert{
       color:red;
       margin-bottom :0px;
      
    }
    .oneformcheckout input.fail-alert,select.fail-alert{
       border-color:red ;
       margin-bottom :0px;
    }
    .oneformcheckout input.success-alert , select.success-alert{
        border : 1px solid green;
        
    }

    /* END STYLING VALID AND INVALID FORMS */
    @media (max-width:768px) {
        .oneformcheckout .form-group{
            margin-bottom : 0px !important;
        }
        
    }

    
</style>

{/literal}

<div class="oneformcheckout">
      <div class="oneformcheckout-header"><p>Entrez vos information</p></div>

      <form id="oneformcheckout" autocomplete="off">
        <div class="form-group" >
            <input type="text" id="firstname_lastname" name="firstname_lastname" placeholder="Nom et Prénom" >
        </div>
        <div class="form-group" >
            <input type="text" id="phone1" name="phone1" placeholder="Numéro du téléphone 1" >
            <small id="show-phone2-field">ajouter un autre numéro du téléphone</small>
        </div>
        <div class="form-group" style="display:none;">
            <input type="text" id="phone2" name="phone2" placeholder="Numéro du téléphone 2" >
            <small id="hide-phone2-field">il suffit le numéro du téléphone 1</small>
        </div>
        <div class="delivery-mode-container">
            {foreach $carrier_data.carriers as $index => $carrier}
                {if strpos($carrier.name, 'domicile') !== false}
                    <div class="delivery-mode-item">
                        <div class="delivery-mode-item-header" style="border-bottom-left-radius:0px;border-bottom-right-radius:0px">
                            <div class="delivery-mode-item-header-start">
                                <label class="checkbox-container">
                                    <input type="checkbox" name="cod_mode" id="cod_mode" data-carrier-id={$carrier.carrier_id}  data-carrier-price={$carrier.price} 
                                    {if $carrier_data.selected_carrier_id == null || $carrier_data.selected_carrier_id == $carrier.carrier_id }  checked{/if} />
                                    <span class="fake-checkbox"></span>
                                </label>
                                <p>Livraison à domicile <p>
                            </div>
                            <p >{if $carrier.price == 0} gratuit {else} {$carrier.price|string_format:"%.3f"} TND  {/if}</p>
                        </div>
                        <div class="delivery-mode-item-body" style={if $carrier_data.selected_carrier_id != null and $carrier_data.selected_carrier_id != $carrier.carrier_id } "display:none" {/if} >
                                <select id="city_name" name="city_name" >
                                          <option value="" disabled selected >Choisissez votre ville</option>
                                          <option value="Ariana" >Ariana</option>
                                          <option value="Beja">Beja</option>
                                          <option value="Ben Arous">Ben Arous</option>
                                          <option value="Bizerte">Bizerte</option>
                                          <option value="Gabes">Gabes</option>
                                          <option value="Gafsa">Gafsa</option>
                                          <option value="Jendouba">Jendouba</option>
                                          <option value="Kairouan">Kairouan</option>
                                          <option value="Kasserine">Kasserine</option>
                                          <option value="Kebili">Kebili</option>
                                          <option value="Kef">Kef</option>
                                          <option value="Mahdia">Mahdia</option>
                                          <option value="Mannouba">Mannouba</option>
                                          <option value="Medenine">Medenine</option>
                                          <option value="Monastir">Monastir</option>
                                          <option value="Nabeul">Nabeul</option>
                                          <option value="Sfax">Sfax</option>
                                          <option value="Sidi Bouzid">Sidi Bouzid</option>
                                          <option value="Siliana">Siliana</option>
                                          <option value="Sousse">Sousse</option>
                                          <option value="Tataouine">Tataouine</option>
                                          <option value="Tozeur">Tozeur</option>
                                          <option value="Tunis">Tunis</option>
                                          <option value="Zaghouan">Zaghouan</option>
                                  </select>
                                <select id="delegation_name" name="delegation_name" disabled>
                                    <option value="" disabled selected >Choisissez votre délégation</option>
                                </select>
                                <input type="text" id="address" name="address" placeholder="Address" >
                        </div>
                    </div>
                {else}
                    <div class="delivery-mode-item" >
                        <div class="delivery-mode-item-header">
                            <div class="delivery-mode-item-header-start">
                                <label class="checkbox-container">
                                    <input type="checkbox"  name="relay_mode" id="relay_mode" data-carrier-id={$carrier.carrier_id} data-carrier-price={$carrier.price}
                                    {if $carrier_data.selected_carrier_id == $carrier.carrier_id} checked{/if}/>
                                    <span class="fake-checkbox"></span>
                                </label>
                                <p>Livraison aux point relais<p>
                            </div>
                            <p >{if $carrier.price == 0} gratuit {else} {$carrier.price|string_format:"%.3f"} TND{/if}</p>
                        </div>
                        <div class="delivery-mode-item-body" style={if $carrier_data.selected_carrier_id != $carrier.carrier_id} "display:none" {/if}>
                           {include file='module:oneformcheckout/views/templates/hook/loxbox_widget.tpl'}
                            <div class="lx-relay-point-alert" >
                                <p>Il faut sélectionner un point relais.</p>
                            </div>
                        </div>
                    </div>
                {/if}
            {/foreach}
        </div>

        <button class="submit" type="submit" id="oneformcheckout-submit-btn">
               
                
                <span>commandez</span>
                <div class="submit-btn dot-elastic" style="display:none"></div>
                
        </button>




   <form>


</div>
