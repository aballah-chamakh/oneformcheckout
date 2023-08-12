{literal}
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
    <style>
        /* MAKE THE CONTENT OF THE RELAY POINT LIST ITEM IN A COLUMN DISTRUBTION */
        .oneformcheckout .list-group-item {
            display : flex;
            flex-direction : column;
             padding : 5px !important;
             padding-left : 10px !important;
        }
        
        .oneformcheckout .leaflet-popup-content{
               width : 100%;
        }
        
        @media (max-width:768px) {
            /* ADJUST THE POPUP OF THE MARKERS OF THE MAP  FOR MOBILE*/
            .oneformcheckout .leaflet-popup-content{
                width : 180px !important ;
                overflow-x :scroll;
            }
            .oneformcheckout .leaflet-popup-content h4{
                font-size : 16px;
                font-weight: bold;
            }
            .oneformcheckout .leaflet-popup-content h5{
                font-size : 15px;
            }
            .oneformcheckout .leaflet-popup-content-wrapper{
                max-height : 240px;
                overflow-y : scroll;
            }
            .oneformcheckout .leaflet-popup-content{
             margin : 13px 5px ;
            }
            
            /* ADJUST THE RELAY POINT LIST ITEM FOR MOBILE */
            .oneformcheckout .list-group-item {
                padding : 5px;
            }
        }
        /* SET THE COLOR OF THE LOADER OF THE LX WIDGET*/
        .oneformcheckout  .lx-loading.dot-elastic,.oneformcheckout .lx-loading.dot-elastic::before,.oneformcheckout .lx-loading.dot-elastic::after{
              color: #364620;
              background-color:#364620;
        }
    </style>
    <script>
        var loading = true;
        var selectedLxRelayPoint = null ;
    </script>
{/literal}
    <div class="loxbox-widget">
        {if  {$valid}==200 }

            <div class="relay-content" style="display:none">
            </div>
            {literal}

                <script>
                 console.log("starting ...")
                var map;
                var list;
                var markers = {};
                    var SELECTED = false;
                    var LASTSELECTED = "";

                    function loadHtml() {
                        $(".relay-content").html(
                        `<div class="results" >
                        	<div class="lx-list">
                        	    <div class="lx-list-header">
                            	
                            		<div class="form-group">
                            			<select class="form-control" id="city" >
                            			    <option disabled selected >Filtrez les points relais par délégation</option>
                            				<option value="Tous">Toutes les Délégation</option>
                            			</select>
                            		</div>
                        		</div>
            					<ul class="list-group" id="myList">
            						<div class="panel-group" id="accordion"></div>
            					</ul>
                        	</div>
                        	<div id="map"></div>
                        </div>`
                        );
                    }



                    function loadMap() {
                         map = L.map("map", {
                                zoom: 10,
                            })
                            .on('popupclose',function() {
                              if(!($(window).length<=768)  )   mapSelect(map);
                            })
                            .on("click", function() {
                                mapSelect(map);
                            })
                            //center popup
                            .on("popupopen", function(e) {
                                var px = map.project(e.target._popup
                                    ._latlng); // find the pixel location on the map where the popup anchor is
                                px.y -= e.target._popup._container.clientHeight /
                                    2; // find the height of the popup container, divide by 2, subtract from the Y axis of marker location
                                map.panTo(map.unproject(px), { animate: true });
                              
                            });
                        //loading tile layer
                        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
                        attribution:
                            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                    }).addTo(map);
                    
                    //we need map instance to create markups
                    fetchData(map, L);
                    }

                    function loadPlugin(L) {
                        loadHtml();
                        loadMap(L);

                    }

                    function hidePlugin() {
                        $(".relay-content").html("");
                    }

                    function fetchData(map, L) {
                        $.ajax({
                            type: "GET",
                            url: "https://www.loxbox.tn/api/Relaypoints/",

                            data: "json",
                            dataType: "json",
                            headers: {
                                Authorization: "Token " + Loxbox_TOKEN,
                            },
                            success: function(response) {
                                handleResponse(response, map, L);
                            },
                        });
                    }

                    function getDiv(element) {
                        var chosenRelay = element;
                        var html = "";
                        if (element.WorkingHours != null) {
                            element.WorkingHours[0].timing.forEach((day) => {
                                if (day.isClosed == 0) {
                                    if (day.hours.size == 1) {
                                        html+= `<tr> <td> ${day.day} </td> <td> ${day.hours[0].open}</td> <td> ${day.hours[0].close}</td> </tr>`;

                                    } else {
                                        html+= `<tr> <td> ${day.day} </td> <td> ${day.hours[0].open} - ${day.hours[0].close} </td> <td>${day.hours[1].open} - ${day.hours[1].close} </td> </tr>`;

                                    }

                                } else {
                                    html+= `<tr> <td> ${day.day} </td> <td style="text-align:center;"> - </td> <td style="text-align:center;"> - </td> </tr>`;

                                }
                            })
                        } else {
                            html += "Pas d'informations disponible"
                        };
                        return `<table class="table table-striped">
   <thead>
<h4>${chosenRelay.Name} </h4>
<h5>${chosenRelay.City+' '}<p>${chosenRelay.Zipcode}</p></h5> 
<p>${chosenRelay.Address}</p>
<span><a style="font-style:italic;font-size:16;text-decoration:underline" href="${chosenRelay.MapLocation}" target="_blank">Localiser sur Google maps</a> </span>
   </h4>
   </thead>

  <tbody>
${html}


  </tbody>
</table>`;
                    }

                    function handleResponse(response, map, L) {
                        list = response;
                        getUserLocation(map,list);

                        console.log(list);
                        renderListToUl(list);
                        renderMarkUp(list, map, L);
                        //setMapToFirstLocation(list[0], map);
                        loadCitiesToDropDown(list);
                        filterEvent(list);
                        listClickEvent(list, map, L);
                        //panelEvent(list,map,L);
                        //panelAllEvent(list);
                      
                    }



                    function getUserLocation(map,list)
                    {
                        navigator.geolocation.getCurrentPosition((position)=>loadUserLocation(position,map,list),notAllow(map,list));
                           
                    }
                    function measure(lat1, lon1, lat2, lon2){  // generally used geo measurement function
    var R = 6378.137; // Radius of earth in KM
    var dLat = lat2 * Math.PI / 180 - lat1 * Math.PI / 180;
    var dLon = lon2 * Math.PI / 180 - lon1 * Math.PI / 180;
    var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    var d = R * c;
    return d * 1000; // meters
}

                   function loadUserLocation(position,map,list)
                    {
                        let coords = position.coords;
                        var obj = {'latitude':list[0].latitude,'longitude':list[0].Longitude};

                        var min = measure(coords.latitude,coords.longitude,obj.latitude,obj.longitude);
                        let minIndex = 0;
                       
                        for(let i=0;i<list.length;i++)
                        {
                            var obj = {'latitude':list[i].latitude,'longitude':list[i].Longitude};
                            if(measure(coords.latitude,coords.longitude,obj.latitude,obj.longitude) < min)
                            {
                                min = measure(coords.latitude,coords.longitude,obj.latitude,obj.Longitude);
                                minIndex=i;
                            }

                        }
                        console.log(minIndex,min);
                        setMapToFirstLocation(list[minIndex], map);

                        
                    }
                    function notAllow(map,list)
                    {
                        setMapToFirstLocation(list[0], map);
                    }

                    function panelAllEvent(list)
                    {
                        list.forEach((element)=> {
                            $('#'+element.Identifier).on('hide.bs.collapse',function(){
                               
                            
                            });
                        });
                       
                    }


                    function panelEvent(list,map,L) {
                        
                           
                      
                        $('.card.loxbox').click(function(element) {
                            $('html, body').animate({
                                scrollTop: $(".relay-content").offset().top
                            }, 1000);
                            // alert(element.target);
                            var url = this.id;
                            url = url.replace('%C3%A9', 'é');

                            // alert(url.length);
                            const _relay = url;
                            SELECTED = true;
                            const relay = list.find(
                                (_element) => _element.Name == _relay
                            );
                            console.log("from panelEvent"+relay);
                            LASTSELECTED=relay.Identifier;

                            // alert(relays[0].City)
                            //ajax call
                            $.ajax({
                                type: "POST",
                                url: front_link,
                                data: "address1=" +
                                    relay.Name + ',' + relay.Address +
                                    "&ajax=1" +
                                    "&City=" +
                                    relay.City +
                                    "&Zipcode=" +
                                    relay.Zipcode +
                                    "&Name=" +
                                    relay.Name+
                                    "&idRelay="+relay.Identifier,
                                success: function() {
                                if(LASTSELECTED==null) return;
                                markers[relay.Identifier].openPopup();
                 
                                },
                            });

                            $("#selected-relay-valid").show();
                            $("#selectedRelay").text(relay.Name);


                        });
                    }

                    function resetHeaderColor()
                    {
                      $('.oneformcheckout .delivery-mode-item-body  .card-header').removeClass('active');
                    }
                    function renderListToUl(list) {
                        var html = "";
                        list.forEach((element) => {
                                var template = `<li data-idrelay="${element.Identifier}" class="list-group-item" id="${element.Name}" value="${element.Name}"><span style="font-weight:bold;" class="avoid-clicks"'>${element.Name} </span> ${element.City} ${element.Zipcode}<br/>${element.Address}</li>`;
                                html += template;
                            });
                        $("#myList").html(html);
                    }

                    function renderMarkUp(list, map, L) {

                      
                        list.forEach((element) => {
                            //create popup
                            var popup = L.popup({ autoPan: true })
                                .setLatLng([element.latitude, element.Longitude])
                            .setContent(popupContent(element)); //setContent of the popup
                            //create marker
                            markers[element.Identifier] =     L.marker([element.latitude, element.Longitude], {
                                    icon: L.icon({
                                        iconUrl: "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png",
                                        shadowUrl: "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
                                        iconSize: [25, 41],
                                        iconAnchor:[12,41],
                                        shadowSize: [41, 41],
                                    }),
                                })
                                .addTo(map) //add markers to map
                                .bindPopup(popup)
                                .on("click", function(e) {
                                    collapsePanel(element);
                                    selectMarker(element);
                                    console.log(element)
                                    selectedLxRelayPoint = element
                                    $(".oneformcheckout .lx-relay-point-alert").css('display','none')
                                }); //bind poups to marker
                        });
                    }
                function collapsePanel(element)
                {
                   LASTSELECTED=element.Identifier;
                   $(`button[data-target="#${element.Identifier}"]`).click();

                    var container = $('.lx-list'),
                        scrollTo = $(`button[data-target="#${element.Identifier}"]`);
                   
                    $("#selected-relay-valid").show();
                    $("#selectedRelay").text(element.Name);

                    container.animate({
                        scrollTop: scrollTo.offset().top - container.offset().top + container.scrollTop()
                    });
                    
                }
                    function popupContentMobile(element)
                    {
                        
                        return `${element.Name}`;
                    }


                    function popupContent(element) {
                        var chosenRelay = element;
                        var html = "";
                        if (element.WorkingHours != null) {
                            element.WorkingHours[0].timing.forEach((day) => {
                                if (day.isClosed == 0) {
                                    if (day.hours.size == 1) {
                                        html += `<tr> <td class="text-nowrap"> ${day.day} </td> <td class="text-nowrap"> ${day.hours[0].open}</td> <td class="text-nowrap"> ${day.hours[0].close}</td> </tr>`;
                                    } else {
                                        html += `<tr> <td class="text-nowrap"> ${day.day} </td> <td class="text-nowrap"> ${day.hours[0].open} &#8209; ${day.hours[0].close} </td> <td class="text-nowrap">${day.hours[1].open} - ${day.hours[1].close} </td> </tr>`;
                                    }
                                } else {
                                    html += `<tr> <td class="text-nowrap"> ${day.day} </td> <td style="text-align:center;"> - </td> <td style="text-align:center;"> - </td> </tr>`;
                                }
                            });
                        } else {
                            html += "Pas d'informations disponible";
                        }
                        return `
                        <table class="table table-striped" id='lx-relay-point-popup'>
                   <thead>
                    <h4>${chosenRelay.Name} </h4>
                    <h5>${chosenRelay.City + " "  }<p style="color:black">${chosenRelay.Zipcode}</p> </h5> 
                <div>
                <p style="color:black">${chosenRelay.Address}</p>
                </div>
                    <span ><a style="font-style:italic;font-size:16;text-decoration:underline" href="${chosenRelay.MapLocation}" target="_blank">Localiser sur Google maps</a> </span>
                   </thead>
                  <tbody>${html}</tbody>
                    </table>`;
                    }

                    function setMapToFirstLocation(element, map) {
                        if (element != "undefined") {
                            map.setView([element.latitude, element.Longitude], 11);
                        }
                    }

                    function loadCitiesToDropDown(list) {
                        var cities = [];
                        list.forEach((e) => cities.push(e.City));

                        var u_cities = [...new Set(cities)];

                        u_cities.forEach((e) => {
                            $("#city").append(` <option>${e}</option>`);
                        });
                    }

                    function filterEvent(list) {
                        $("#city").change(function(e) {
                            this.style.color  = "black" ;
                            var city = this.value;
                            if (city === "Tous") {
                                $("#myList > li").each(function() {
                                    $(this).show();
                                });
                                $(".card.loxbox").each(function(index, element) {
                                    // element == this
                                    $(this).show();
                                });

                                return;
                            } else {
                                $("#myList > li").each(function() {
                                    var element = list.find((element) => element.Name === this.id);
                                    if (element.City.toLowerCase() === city.toLowerCase()) {
                                        $(this).show();
                                    } else {
                                        $(this).hide();
                                    }
                                });
                                $(".card.loxbox").each(function(element) {
                                    
                                    var element = list.find((element) => element.Name === this.id);
                                    if (element.City.toLowerCase() === city.toLowerCase()) {
                                        $(this).show();
                                    } else {
                                        $(this).hide();
                                    }

                                });
                            }
                        });
                    }

                    function listClickEvent(list, map, L) {
                        $(".oneformcheckout .delivery-mode-item-body li").on("click", function(element) {
 
                            resetList();
                            $(this).addClass("active");
                            $("#selected-relay-valid").show();
                            SELECTED = true;

                            $("#selectedRelay").text(element.target.id);
                            var relay = list.find((_element) => _element.Name == element.target.id);
                            selectedLxRelayPoint = relay
                            $(".oneformcheckout .lx-relay-point-alert").css('display','none')
                            //ajax call
                            /*
                            $.ajax({
                                type: "POST",
                                url: front_link,
                                data: "address1=" +
                                    relay.Name + ',' + relay.Address +
                                    "&ajax=1" +
                                    "&City=" +
                                    relay.City +
                                    "&Zipcode=" +
                                    relay.Zipcode +
                                    "&Name=" +
                                    relay.Name+
                                    "&idRelay="+relay.Identifier,
                                success: function() {
                                },
                            });*/
                            showItemOnMap(relay, map, L);
                        });
                    }

                    function resetList() {
                        $(".oneformcheckout .delivery-mode-item-body li").each(function(indexInArray, valueOfElement) {
                            $(this).removeClass("active");
                        });
                    }

                    function showItemOnMap(element, map, L) {
                        L.popup()
                            .setLatLng([element.latitude, element.Longitude])
                            .setContent(popupContent(element))
                            .openOn(map); 
                    }

                    function selectMarker(element) {
                    
                        resetList();
                        $("#selected-relay-valid").show();
                        
                        // HIGHLIGHT TO THE EQUIVALENT LIST ITEM OF THE MARKER
                        $(".oneformcheckout .delivery-mode-item-body li").each(function() {
                            if ($(this)[0].id == element.Name) {
                                $(this).addClass("active");
                                $("#selectedRelay").text(element.Name);
                                SELECTED=true;
                            }
                        });
                        
                        // MOVE TO THE EQUIVALENT LIST ITEM OF THE MARKER
                        const listGroup = document.querySelector('.list-group');
                        
                        const listGroupItem = document.querySelector(`.list-group .list-group-item[data-idrelay="${element.Identifier}"]`);
                        
                        listGroup.scrollTop = listGroupItem.offsetTop - listGroupItem.scrollHeight ;
                        
                        /*
                        $.ajax({
                                type: "POST",
                                url: front_link,
                                data: "address1=" +
                                    element.Name + ',' + element.Address +
                                    "&ajax=1" +
                                    "&City=" +
                                    element.City +
                                    "&Zipcode=" +
                                    element.Zipcode +
                                    "&Name=" +
                                    element.Name+
                                    "&idRelay="+element.Identifier,
                                success: function() {
                                },
                            });*/
                    }

                    function mapSelect(map) {

                  
                     //   $(`button[data-target="#${LASTSELECTED}"]`).click();
                      //  LASTSELECTED=null;

                        resetList();
                        $("#selected-relay-valid").hide();
                        SELECTED = false;
                        selectedLxRelayPoint = null
                        $(".oneformcheckout .lx-relay-point-alert").css('display','block')

                    }

                    function setLoader() {
                        loading = true;

                    }

                    function removeLoader() {
                        $('.lx-loading.dot-elastic').hide()
                        $('.relay-content').show()
                        loading = false;
                    }
                  
                    window.onload = function() 
                    {
                
                        var lastSelected="";
                        setLoader();
                        //check if mobile render other html
                        loadHtml();
                        loadMap(L);
        
    
                        fetchData(map, L);
                        removeLoader();
                        
                        
                      
                        
                    }
                </script>
                <div class="lx-loading dot-elastic" style="color:green;backgroud-color:green"></div>


            {/literal}
        {elseif {$valid}!=200 }
            {literal}
                <script>
                    SELECTED = true;
                </script>
            {/literal}
            <div class="alert alert-warning" role="alert">
                <p class="alert-text">
                    Le module LoxBox n'est pas activé. Pour plus d'informations contacter : <a
                        href="mailto:contact@loxbox.tn">contact@loxbox.tn</>
                </p>
            </div>
        {else}

            {literal}
                <script>
                    SELECTED = true;
                </script>
            {/literal}
        {/if}
    </div>
