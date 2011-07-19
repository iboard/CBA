$(document).ready(function(){
  $('#component_sort_box').hide();
  $('#site-menus-list').sortable(
    {
      connectWith: '.list',
      axis: 'y', 
      dropOnEmpty:false, 
      handle: '.handle', 
      cursor: 'crosshair',
      items: 'li',
      opacity: 0.4,
      scroll: true,
      update: function(){
        $.ajax({
            type: 'post', 
            data: $('#site-menus-list').sortable('serialize'), 
            dataType: 'script', 
            complete: function(request){
                $('#site-menus-list').effect('highlight');
              },
            url: '/site_menus/sort_menus'})
      }
    }
  )
});