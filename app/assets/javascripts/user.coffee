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
