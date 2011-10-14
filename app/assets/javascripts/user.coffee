$(document).ready ->
  if $("#users-location-map")
    $("#users-location-map").html('<img src="/images/spinner.gif" alt="Loading ..." style="box-shadow: none">')
    lnglat = $('#user-location-token').html()
    if lnglat
      lng = lnglat.split(",")[0]
      lat = lnglat.split(",")[1]
      loadUserMap(parseFloat(lng),parseFloat(lat))
           
loadUserMap = (lng,lat) ->
  latlng = new google.maps.LatLng(lng,lat)
  myOptions = {
    zoom: 8,
    center: latlng,
    width: 300,
    height: 300,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("users-location-map"),myOptions)
  $('#users-location-map').height("300px").width("300px")
  marker = {
    position: latlng,
    map: map
  }
  userMarker = new google.maps.Marker(marker)  

this.loadUserLocation = (target,lnglat) ->
  lng = lnglat.split(",")[0]
  lat = lnglat.split(",")[1]
  userPosition = new google.maps.LatLng(parseFloat(lng),parseFloat(lat))
  myOptions = {
    zoom: 4,
    center: userPosition,
    width: 150,
    height: 150,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById(target),myOptions)
  $('#'+target).height("150px").width("150px")
  marker = {
    position: userPosition,
    map: map
  }
  userMarker = new google.maps.Marker(marker)

jQuery ->
  $('#address').keyup ->
    searchLocation()
      
# Update Map when searching for address or place
geocoder = null
map = null
$(document).ready ->
  if $('#location-preview')
    geocoder = new google.maps.Geocoder();
    pos = $("#user_location_token").val()
    unless pos == ""
      lat = parseFloat(pos.split(",")[0])
      lng = parseFloat(pos.split(",")[1])
      initial_zoom = 10
    else
      lat = 0.0
      lng = 0.0
      initial_zoom = 0
    userPosition = new google.maps.LatLng(lat,lng)
    myOptions = {
      zoom: initial_zoom,
      center: userPosition
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById("location-preview"), myOptions)
    $("#location-preview").height(200).width(200)
    unless pos == ""
      marker = new google.maps.Marker({
          map: map,
          position: userPosition
      })
  
searchLocation = ->
  search_term = $('#address').val()
  if search_term.length < 10
    # don't start searching if term is short
  else
    $('#user_location_token').val(search_term)
    results = geocoder.geocode { address: search_term }, (results, status) ->
      if status == google.maps.GeocoderStatus.OK
        if results.length > 0
          map.setCenter(results[0].geometry.location)
          map.setZoom( 16 - results.length )
          marker = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location
          })
          $('#user_location_token').val(results[0].geometry.location)
