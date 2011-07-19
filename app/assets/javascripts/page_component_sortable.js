$(document).ready(function(){
  var current_path = location.pathname;
  var page_id      = current_path.split("/")[2];
  $('#sort_components').sortable(
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
            data: $('#sort_components').sortable('serialize'),
            dataType: 'script',
            complete: function(request){
                $('#sort_components').effect('highlight');
              },
            url: '/pages/'+page_id+'/sort_components'})
      }
    }
  );
  $('#component_sort_box').show();
});