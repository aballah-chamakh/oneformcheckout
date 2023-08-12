<script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>
{literal}
<script>
 let removeFromValidationRules = (inputs_ids)=>{
     inputs_ids.map(input_id=>{
         let inputEl = $('.oneformcheckout #'+input_id);
         
         // REMOVE THE THE INPUT OR THE SELECT FROM THE RULES 
         inputEl.rules('remove');
         
         // RESET THE INPUT AND THE SELECT TAG
         inputEl.removeClass('error fail-alert success success-alert');
         inputEl.val('');
         if(input_id=='city_name' ){
            inputEl.css('color', '#999');    
         }
         if(input_id == 'delegation_name') {
            inputEl.prop('disabled', true);
            inputEl.css('color', '#999'); 
         }
         if (inputEl.next('label').length){
             inputEl.next('label').css('display','none')
         }
         
     })
 }
 let oneFormCheckoutValidation = {
    firstname_lastname: {
      required: true,
      maxlength: 255
    },
    phone1: {
      required: true,
      digits: true,
      minlength: 8,
      maxlength: 8
    },
    city_name:{
        required : true,
    },
    delegation_name : {
        required : true,
    },
    address : {
        required : true,
        maxlength: 128
    }
};

let oneFormCheckoutErrorMessages = {
    firstname_lastname:{
      required: 'Ce champ est obligatoire.',
      maxlength: 'Ce champ ne doit pas dépasser 255 caractères.'
    },
    phone1: {
      required: 'Ce champ est obligatoire.',
      digits: 'Ce champ ne doit contenir que des chiffres.',
      minlength : "Ce champ doit être composé d'au moins 8 chiffres.",
      maxlength : 'Ce champ ne doit pas dépasser 8 chiffres.'
    },
    phone2: {
      required: 'Ce champ est obligatoire.',
      digits: 'Ce champ ne doit contenir que des chiffres.',
      minlength : "Ce champ doit être composé d'au moins 8 chiffres.",
      maxlength : 'Ce champ ne doit pas dépasser 8 chiffres.'
    },
    city_name : {
      required: 'Ce champ est obligatoire.',
    },
    delegation_name : {
      required: 'Ce champ est obligatoire.', 
    },
    address : {
        required : 'Ce champ est obligatoire.',
        maxlength: 'Ce champ ne doit pas dépasser 128 caractères.'
    }
  };
  console.log($('.oneformcheckout form'))
 $('#oneformcheckout').validate({
    errorClass: "error fail-alert",
    validClass: "valid success-alert",
    rules: oneFormCheckoutValidation,
    messages: oneFormCheckoutErrorMessages,
    submitHandler: function(form) {
        
        // DISABLE THE FORM 
        let codCheckBox = $('.oneformcheckout #cod_mode')[0]
        codCheckBox.disabled = true ;
        $('.oneformcheckout #relay_mode')[0].disabled = true ;
        
        let submitBtn = $('.oneformcheckout #oneformcheckout-submit-btn')[0]
        submitBtn.disabled= true 
        submitBtn.firstElementChild.style.display='none' ;
        submitBtn.lastElementChild.style.display='block';
        
        
        // SHOW THE RELAY POINT ALERT IF THERE IS NO RELAY POINT IS SELECTED 
        let isCodMode = $('.oneformcheckout #cod_mode')[0].checked
        if(!isCodMode){
            if(!selectedLxRelayPoint){
                $('.oneformcheckout .lx-relay-point-alert').css('display','block')
                return 
            }else if($('.oneformcheckout .lx-relay-point-alert').css('display') == 'block'){
               $('.oneformcheckout .lx-relay-point-alert').css('display','none')
            }
        }
        
        
        // CONSTRUST THE DATA THAT WE WILL SEND
        let data = {}
        data['firstname_lastname'] = $('.oneformcheckout #firstname_lastname').val()
        data['phone_1'] = $('.oneformcheckout #phone1').val()
        
        if($('.oneformcheckout #phone2').val()){
            data['phone_2'] = $('.oneformcheckout #phone2').val()
        }
        
        if(isCodMode){
            data['delivery_mode'] = 'cod'
            data['city'] = $('.oneformcheckout #city_name').val()
            data['delegation'] = $('.oneformcheckout #delegation_name').val()
            data['address'] = $('.oneformcheckout #address').val()
            data['carrier_id'] = $('.oneformcheckout #cod_mode').attr('data-carrier-id')
        }else{
            data['delivery_mode'] = 'relay'
            data['relay'] = selectedLxRelayPoint
            data['carrier_id'] = $('.oneformcheckout #relay_mode').attr('data-carrier-id')
        }
        
        let query_params = '?guest_order_action=CREATE_GUEST_ORDER'
        fetch(guest_order_link+query_params, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
            credentials: 'include'
        })
        .then(response => response.json())
        .then(data => {
           console.log(data);
           window.location.href = guest_order_link+'?id_order='+data['id_order']+'&order_ref='+data['order_ref']
        })
        .catch(error => {
            console.error('Error:', error);
        });
        
    
      
    },
    highlight : (element)=>{
        console.log(element)
        console.log("------------")
        $(element).removeClass('success success-alert')
        $(element).addClass('error fail-alert')

        if (element.name == 'phone1' && element.style.marginBottom == '10px'){
            element.style.marginBottom = '0px' ;
            console.log("remove the margin (highlight)")
        }
    },
    unhighlight : (element)=>{

       $(element).removeClass('error fail-alert')
       $(element).addClass('success success-alert')
       console.log("unhighlight ",element.parentElement.querySelector("#show-phone2-field"))
       if (element.name == 'phone1' && element.parentElement.querySelector("#show-phone2-field").style.display == 'none'){
            element.style.marginBottom = '10px'
            console.log(element)
            console.log("add the margin (unhighlight)")
       }
    }
 });


// EVENT LISTENER RELATED TO TOGGLING THE SECOND PHONE
document.querySelector('.oneformcheckout #show-phone2-field').addEventListener('click',()=>{
    let showPhone2FieldToggle = document.querySelector('.oneformcheckout #show-phone2-field')
    showPhone2FieldToggle.style.display = 'none' ;
    !showPhone2FieldToggle.parentElement.querySelector('label.fail-alert') || showPhone2FieldToggle.parentElement.querySelector('label.fail-alert').style.display == 'none' ? showPhone2FieldToggle.parentElement.firstElementChild.style.marginBottom = '10px'  : null ;
    document.querySelector('.oneformcheckout #phone2').parentElement.style.display='block' ;

    // ADD THE VALIDATIONS FOR THE THE PHONE2 FIELDs
    $('.oneformcheckout #phone2').rules('add',{required:true})
})

document.querySelector('.oneformcheckout #hide-phone2-field').addEventListener('click',()=>{
    let showPhone2FieldToggle = document.querySelector('.oneformcheckout #show-phone2-field')
    showPhone2FieldToggle.style.display = '' ;
    showPhone2FieldToggle.parentElement.firstElementChild.style.marginBottom = '0px' ;
    document.querySelector('.oneformcheckout #phone2').parentElement.style.display='none' ;
    
    // REMOVE THE VALIDATIONS FOR THE THE PHONE2 FIELD
    removeFromValidationRules(['phone2'])
    
})

// EVENT LISTENER RELATED TO TOGGLING BODY OF THE DELIVERY MODE ITEMS

let deliveryModeCheckBoxes = document.querySelectorAll('.oneformcheckout .delivery-mode-item input[type="checkbox"]')
let updateSelectedCarrierIdInServer = (currentCheckbox,otherCheckbox,submitFormBtn)=>{
    
    let query_params = '?guest_order_action=UPDATE_DELIVERY_MODE'
    let data = {selected_carrier_id:currentCheckbox.getAttribute('data-carrier-id')}
    fetch(guest_order_link+query_params, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
            credentials: 'include'
    })
    .then(response =>{
            otherCheckbox.disabled = false
            submitFormBtn.disabled=false
            
            let deliveryPrice = parseFloat(currentCheckbox.getAttribute('data-carrier-price'))
            let cartPrice = parseFloat($('#cart-subtotal-products.cart-summary-subtotals .value')[0].innerText.replace(',','.'))
            let reduction = parseFloat($('.block-promo .cart-summary-line > div')[0].innerText.replace(',','.')) ;
            let cartTotalPrice = cartPrice + deliveryPrice  + reduction
            
            $('#cart-subtotal-shipping.cart-summary-subtotals .value').text(deliveryPrice == 0 ? 'gratuit' : deliveryPrice.toFixed(3)+' TND')
            
            $('.cart-total .value:nth(1)').text(cartTotalPrice.toFixed(3)+' TND')
            
            

    })
    .catch(error => {
        console.error('Error:', error);
    });
}
let deliveryModeCheckBoxHandler = (e)=>{
    // HELPER OBJECT TO EASILY KNOW THE ID OF THE OTHER CHECKBOX 
    let otherCheckboxId = {'cod_mode':'relay_mode','relay_mode':'cod_mode'}
    
    let currentCheckbox = e.target
    let otherCheckbox = document.querySelector('.oneformcheckout #'+otherCheckboxId[currentCheckbox.id])
    let submitFormBtn = document.querySelector('.oneformcheckout #oneformcheckout-submit-btn')
    

    

    let checked = currentCheckbox.checked // NOTE : checked = true MEAN THAT HE WAS UNCHECKED AND checked = false MEAN THAT HE WAS CHECKED
    let deliveryItemHeader = currentCheckbox.parentElement.parentElement.parentElement
    let deliveryItemBody = deliveryItemHeader.nextElementSibling
    if(checked){
        // DISABLE THE OTHERCHECKBOX AND THE SUBMITFORM BTN
        otherCheckbox.disabled = true
        submitFormBtn.disabled=true
        // UPDATE THE SELECTED CARRIER IN THE BACKEND
        updateSelectedCarrierIdInServer(currentCheckbox,otherCheckbox,submitFormBtn)
    
        // TOGGLE THE VALIDATIONS FOR THE COD MODE INPUTS FORM
        if(currentCheckbox.name == 'cod_mode'){
            $('.oneformcheckout #city_name').rules('add',{required:true})
            $('.oneformcheckout #delegation_name').rules('add',{required:true})
            $('.oneformcheckout #address').rules('add',{required:true,maxlength: 128})
            
        }else{
            removeFromValidationRules(['city_name','delegation_name','address'])
        }
       
        // UNCHECK,STYLE AND HIDE THE OTHER OPTIONS (OTHER THEN THE CURREN OPTION)
        otherCheckbox.checked = false
        let otherDeliveryItemHeader = otherCheckbox.parentElement.parentElement.parentElement
        let otherDeliveryItemBody = otherDeliveryItemHeader.nextElementSibling
        otherDeliveryItemBody.style.display = 'none'
        otherDeliveryItemHeader.style.borderBottomLeftRadius = "5px";
        otherDeliveryItemHeader.style.borderBottomRightRadius = "5px";

        // UPDATE THE STYLE OF THE CURRENT CHECKBOX
        deliveryItemBody.style.display = ''
        deliveryItemHeader.style.borderBottomLeftRadius = "0px";
        deliveryItemHeader.style.borderBottomRightRadius = "0px";
        map.invalidateSize()
        
        

    

        
    }else{
        currentCheckbox.checked = true
    }
    
    // SCROLL TO THE DELIVERY MODE HEADER
    
    // get the navbar offset for either the phone or the pc
    let navbarOffset = 0
    if($('.header-nav.fixed').length){
        navbarOffset = $('.header-nav.fixed').height()
    }else if($('.header-top.fixed').length){
        navbarOffset = $('.header-top.fixed').height()
    }
    
    let rect = deliveryItemHeader.getBoundingClientRect()
    window.scrollTo(0,window.scrollY+rect.top-navbarOffset)
    
    // END SCROLL TO THE DELIVERY MODE HEADER
    
    

    
 
    
}

deliveryModeCheckBoxes.forEach((checkbox)=>{
    checkbox.addEventListener('change',deliveryModeCheckBoxHandler)
})



// HANDLE THE CHANGE OF THE SELECT OF THE CITY 
document.querySelector(".oneformcheckout form select[name='city_name']").addEventListener('change',(e)=>{
    let cityDelegations = {"Ariana": ["Ariana Ville", "Ennasr", "Ettadhamen", "Kalaat Landlous", "La Soukra", "Mnihla", "Raoued", "Sidi Thabet"], "Beja": ["Amdoun", "Beja Nord", "Beja Sud", "Goubellat", "Mejez El Bab", "Nefza", "Teboursouk", "Testour", "Thibar"], "Ben Arous": ["Ben Arous", "Bou Mhel El Bassatine", "El Mourouj", "Ezzahra", "Fouchana", "Hammam Chatt", "Hammam Lif", "Megrine", "Mohamadia", "Mornag", "Nouvelle Medina", "Rades"], "Bizerte": ["Bizerte Nord", "Bizerte Sud", "El Alia", "Ghar El Melh", "Ghezala", "Jarzouna", "Joumine", "Mateur", "Menzel Bourguiba", "Menzel Jemil", "Ras Jebel", "Sejnane", "Tinja", "Utique"], "Gabes": ["El Hamma", "El Metouia", "Gabes Medina", "Gabes Ouest", "Gabes Sud", "Ghannouche", "Mareth", "Matmata", "Menzel Habib", "Nouvelle Matmat"], "Gafsa": ["Belkhir", "El Guettar", "El Ksar", "El Mdhilla", "Gafsa Nord", "Gafsa Sud", "Metlaoui", "Moulares", "Redeyef", "Sidi Aich", "Sned"], "Jendouba": ["Ain Draham", "Balta Bou Aouene", "Bou Salem", "Fernana", "Ghardimaou", "Jendouba", "Jendouba Nord", "Oued Mliz", "Tabarka"], "Kairouan": ["Bou Hajla", "Chebika", "Cherarda", "El Ala", "Haffouz", "Hajeb El Ayoun", "Kairouan Nord", "Kairouan Sud", "Nasrallah", "Oueslatia", "Sbikha"], "Kasserine": ["El Ayoun", "Feriana", "Foussana", "Haidra", "Hassi El Frid", "Jediliane", "Kasserine Nord", "Kasserine Sud", "Mejel Bel Abbes", "Sbeitla", "Sbiba", "Thala"], "Kebili": ["Douz", "El Faouar", "Kebili Nord", "Kebili Sud", "Souk El Ahad"], "Kef": ["Dahmani", "El Ksour", "Jerissa", "Kalaa El Khasba", "Kalaat Sinane", "Le Kef Est", "Le Kef Ouest", "Le Sers", "Nebeur", "Sakiet Sidi Youssef", "Tajerouine", "Touiref"], "Mahdia": ["Bou Merdes", "Chorbane", "El Jem", "Hbira", "Ksour Essaf", "La Chebba", "Mahdia", "Melloulech", "Ouled Chamakh", "Sidi Alouene", "Souassi"], "Mannouba": ["Borj El Amri", "Douar Hicher", "El Battan", "Jedaida", "Mannouba", "Mornaguia", "Oued Ellil", "Tebourba"], "Medenine": ["Ajim", "Ben Guerdane", "Beni Khedache", "Houmet Essouk", "Medenine Nord", "Medenine Sud", "Midoun", "Sidi Makhlouf", "Zarzis"], "Monastir": ["Bekalta", "Bembla", "Beni Hassen", "Jemmal", "Ksar Helal", "Ksibet El Medioun", "Moknine", "Monastir", "Ouerdanine", "Sahline", "Sayada Lamta Bou Hjar", "Teboulba", "Zeramdine"], "Nabeul": ["Beni Khalled", "Beni Khiar", "Bou Argoub", "Dar Chaabane Elfe", "El Haouaria", "El Mida", "Grombalia", "Hammam El Ghez", "Hammamet", "Kelibia", "Korba", "Menzel Bouzelfa", "Menzel Temime", "Nabeul", "Soliman", "Takelsa"], "Sfax": ["Agareb", "Bir Ali Ben Khelifa", "El Amra", "El Hencha", "Esskhira", "Ghraiba", "Jebeniana", "Kerkenah", "Mahras", "Menzel Chaker", "Sakiet Eddaier", "Sakiet Ezzit", "Sfax Est", "Sfax Sud", "Sfax Ville"], "Sidi Bouzid": ["Ben Oun", "Bir El Haffey", "Cebbala", "Jilma", "Maknassy", "Menzel Bouzaiene", "Mezzouna", "Ouled Haffouz", "Regueb", "Sidi Bouzid Est", "Sidi Bouzid Ouest", "Souk Jedid"], "Siliana": ["Bargou", "Bou Arada", "El Aroussa", "Gaafour", "Kesra", "Le Krib", "Makthar", "Rohia", "Sidi Bou Rouis", "Siliana Nord", "Siliana Sud"], "Sousse": ["Akouda", "Bou Ficha", "Enfidha", "Hammam Sousse", "Hergla", "Kalaa El Kebira", "Kalaa Essghira", "Kondar", "Msaken", "Sidi Bou Ali", "Sidi El Heni", "Sousse Jaouhara", "Sousse Riadh", "Sousse Ville"], "Tataouine": ["Bir Lahmar", "Dhehiba", "Ghomrassen", "Remada", "Smar", "Tataouine Nord", "Tataouine Sud"], "Tozeur": ["Degueche", "Hezoua", "Nefta", "Tameghza", "Tozeur"], "Tunis": ["Aouina", "Bab Bhar", "Bab Souika", "Carthage", "Cite El Khadra", "El Hrairia", "El Kabbaria", "El Kram", "El Menzah", "El Omrane", "El Omrane Superi", "El Ouerdia", "Essijoumi", "Ettahrir", "Ezzouhour", "Jebel Jelloud", "La Goulette", "La Marsa", "La Medina", "Lac", "Le Bardo", "Sidi El Bechir", "Sidi Hassine", "Tunis centre"], "Zaghouan": ["Bir Mcherga", "El Fahs", "Ennadhour", "Hammam Zriba", "Saouef", "Zaghouan"]}

    let deleteExistingOptions = (selectElement)=>{
        let optionsLen = selectElement.options.length 
        for(let i=optionsLen-1;i>0;i--){
            selectElement.remove(i)
        }
    }
    // MAKE IT ACTIVE , BECAUSE ANY CHANGE WILL BE A VALID CITY
    e.target.style.color  = 'black'
    
    let delegationSelect= document.querySelector(".oneformcheckout form select[name='delegation_name']")
    delegationSelect.disabled = false
    let newCityValue = e.target.value 
    let newDelegationList = cityDelegations[newCityValue]
    
    deleteExistingOptions(delegationSelect)

    newDelegationList.forEach((delegation)=>{
        let option = document.createElement("option");
        option.value = delegation;
        option.text = delegation;
        delegationSelect.appendChild(option)
    })
    
})

// HANDLE THE CHANGE OF THE SELECT OF THE DELEGATION 
document.querySelector(".oneformcheckout form select[name='delegation_name']").addEventListener('change',(e)=>{
    // MAKE IT ACTIVE , BECAUSE ANY CHANGE WILL BE A VALID CITY
    e.target.style.color  = 'black'
})


</script>
{/literal}

