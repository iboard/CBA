$('document').ready ->
  $('a.open-location').click ->
    location = $(this).html()
    openMapForLocation(location)
  $('a.open-place').click ->
    place =  $(this).html()
    openMapForPlace(place)
    

geocoder = null
map = null
overlayContent = null
initializeOverlay = ->
  overlayContent = "<div id='map-container'><h1 id='label'></h1><div id='map'></div>"+
                   "<br/><a href='#' class='button close' onclick='$(\"#overlay\").hide();return false;'>close</a></div>"
  $("#overlay").html( overlayContent ).fadeTo(1.0,500)
  unless geocoder
    geocoder = new google.maps.Geocoder()
  myOptions = {
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map"), myOptions)
    
openMapForLocation = (pos) ->
  initializeOverlay()
  unless pos == ""
    lat = parseFloat(pos.split(",")[0])
    lng = parseFloat(pos.split(",")[1])
  else
    lat = 0.0
    lng = 0.0
  $('#label').html(pos)
  center_pos = new google.maps.LatLng(lat,lng)
  map.setCenter(center_pos)
  marker = new google.maps.Marker({ map: map, position: center_pos })  
  insertLinkToGoogleMaps(center_pos)
  
openMapForPlace = (place) ->
  initializeOverlay()
  $('#label').html(place)
  results = geocoder.geocode { address: place }, (results, status) ->
    if status == google.maps.GeocoderStatus.OK
      if results.length > 0
        map.setCenter(results[0].geometry.location)
        _z = 16 - results.length
        _z = 0 if _z < 0
        map.setZoom( _z )
        marker = new google.maps.Marker({
            map: map,
            position: results[0].geometry.location
        })
        insertLinkToGoogleMaps(results[0].geometry.location)

insertLinkToGoogleMaps = (position) ->
  url = "http://maps.google.com/?ll=" + position.lat()+","+position.lng()
  $('#map-container a').after( "&nbsp;<a href='" + url + "' target='_blank' class='button open'>Google maps...</a>")
