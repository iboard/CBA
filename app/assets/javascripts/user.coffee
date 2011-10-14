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
  $('#user_location_token').keyup ->
    previewLocation()
  $('#address').keyup ->
    searchLocation()
    
previewLocation = ->
  pos = $("#user_location_token").val()
  $('#location-preview').html("Loading..." + pos)
  lng = pos.split(",")[0]
  lat = pos.split(",")[1]
  if lng != "" && lat != ""
    loadUserLocation('location-preview', pos)
  
  
# Update Map when searching for address or place
geocoder = null
map = null
$(document).ready ->
  if $('#location-preview')
    geocoder = new google.maps.Geocoder();
    userPosition = new google.maps.LatLng(0.0,0.0)
    myOptions = {
      zoom: 0,
      center: userPosition
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    map = new google.maps.Map(document.getElementById("location-preview"), myOptions)
    $("#location-preview").height(200).width(200)
  
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
