$(document).ready ->
  if $("#users-location-map")
    $("#users-location-map").html('<img src="/images/spinner.gif" alt="Loading ..." style="box-shadow: none">')
    lnglat = $('#user-location-token').html()
    lng = lnglat.split(",")[0]
    lat = lnglat.split(",")[1]
    loadUserMap(parseFloat(lng),parseFloat(lat))
        
loadUserMap = (lng,lat) ->
  latlng = new google.maps.LatLng(lng,lat);
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
  beachMarker = new google.maps.Marker(marker)  
