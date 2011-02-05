// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/* *******************************************************
 * jQUERY 
 ******************************************************* */
function add_fields(link, association, content,new_id) {  
    var new_id = new Date().getTime();  
    var regexp = new RegExp("new_" + association, "g");  
    $(link).parent().before(content.replace(regexp, new_id));  
}

function remove_fields(link) {  
    $(link).prev("input[type=hidden]").val("1");  
    $(link).closest(".fields").hide();  
}  
  
function initialize_hud(label,txt) {
    $('#HUDCONTAINER').html( 
       "<div id='HUD'>"+
         "<div class='centered_spinner'>"+
           "<img src=/images/spinner.gif border=0><br/><br/>"+txt+
         "</div>"+
       "</div>"+
       "<br/><span style='color:white; heigth: 30px; padding: 10px; font-size: 10px;'>"+
         "<a style='color: white;' href='#' onclick='Element.fade(\"HUDCONTAINER\",{duration:0.5});'>"+label+"</a>"+
       "</span>");
    Element.fadeShow();
}

function initialize_loading(update,txt) {
    $(update).html("<img src='/images/spinner.gif'><br/>"+txt)
}

function rerender(from_field,to) {
 var t = $(from_field).val();
 
 /* convert on client-side with textile.js */
 $(to).html( convert(t));
 
 /* or convert on server-side with ajax */
 /* $(to).load('/posting_preview/?text='+escape(t)); */
}

function set_page_opacity(v,d) {
  $('header').fadeTo( d, v );
  $('#page_section').fadeTo( d, v );
  $('#right_sidebar').fadeTo( d, v );
}

function close_popup() {
  cycling(0);
  $('#overlay').fadeOut('slow');
  $('#overlay').html("<!--hidden-->");
  set_page_opacity(1.0,1000);
}

function image_popup(img_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
           "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>"+
       "<div id='overlay_content' class='overlay_content'>"+
          "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='"+img_url+"'>"+
          "</a><br/><a href='"+img_url.replace(regexp,'original')+"'>Download</a>"+
      "</div>"
      );
  $('#overlay').fadeTo(500,1.0);  
}

function swap_picture(hide,show) {
  $("#photo_"+hide).fadeTo(500,0.0);
  $("#photo_"+show).fadeTo(500,1.0);  
  $("#photo_"+hide).hide();
}

function cycling(duration) {
  if ( typeof cycling.online_value == 'undefined' ) {
      cycling.online_value = 0;
  }
  
  if (duration == null) {
    return cycling.online_value;
  }
  cycling.online_value=duration;
  return(cycling.online_value);
}

function cycle_pictures(from,to,actual) {
  
  var duration=cycling(null);
  
  if (actual < 0) { actual = from-1; }
  var next = actual+1;
  if (next >= to) { next = from; }
  
  hide_all_pictures(from,to);
  
  if(duration>0) {
    swap_picture(actual,next);
  } else {
    $("#photo_"+next).show();
  }
  
  if (cycling(null) > 0) {
    setTimeout(function() {
                 cycle_pictures(from,to,next);
               }, duration);
  }
}

function hide_all_pictures(from,to) {
  for(var i=from; i<to; i++) {
    $("#photo_"+i).hide();
  }
}

function gallery_popup(duration,args) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  var photos = args.split(",");
  var rc = new String("");
  
  set_page_opacity(0.2,1500);
  cycling(duration);
  for(var i=0; i<photos.length; i++) {
    var prev="";
    var prev_close="";
    var next="";
    var next_close="";
    var controller="";
    
    if( i > 0 ) {
      prev = "<a href='#' onclick='swap_picture("+i+","+(i-1)+");return false;'>";
      prev_close="<img src='"+photos[i-1]+"' style='width: 64px; height: 48px; margin: 10px; vertical-align: middle;'/></a>";
    }
    if ( i < photos.length-1 ) {
      next = "<a href='#' onclick='swap_picture("+i+","+(i+1)+");return false;'>";
      next_close="<img src='"+photos[i+1]+"' style='width: 64px; margin: 10px; height: 48px; vertical-align: middle;'/></a>";
    }

    controller = "<div id='play'><a href='#' onclick=\"cycling("+duration+");"+
                 "$('#play').hide();$('#pause').show();"+
                 "cycle_pictures("+0+","+photos.length+","+(i+1)+");"+
                 "return false;\"><img src='/images/play.png' /></a></div>"+
                 "<div id='pause'><a id='pause' href='#' onclick=\"cycling(0);"+
                 "$('#pause').hide();cycle_pictures("+0+","+photos.length+","+(i)+");$('#play').show();"+
                 "return false;\"><img src='/images/pause.png' /></a></div>";

    rc += "<div id='photo_"+ i + "' style='display:none;'>"+
             prev+prev_close +
             "<img src='"+photos[i]+ "' style='margin: 10px; vertical-align: middle;'/>" +
             next+next_close +
           "</div>";
  }
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
           "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>"+
       "<div id='overlay_content' class='overlay_content'>"+
          rc+
       "</div>"+
       "<div id='overlay_controller'>"+
         "<div id='gallery_controller'>"+ controller + "</div>"+
      "</div>"
      );
  $('#overlay').fadeTo(500,1.0);
  
  if(duration > 0 ) {
    $('#play').hide();
    cycle_pictures(0,photos.length,-1,duration);
  } else {
    $('#pause').hide();
  }
  
}

function video_popup(img_url,mobile_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>" +
       "<div style='margin-top: 80px; vertical-align: baseline;'>"+
         "<video controls autoplay width=\"640\" height=\"400\" "+
                 " src=\""+img_url+"\""+
                 " type='video/mp4'"+
            ">" +
              "Your browser does not support the video tag."+
            "</video>"+"</div>"+
      "</div>"+       
      "<center>"+
        "<a href='"+img_url+"'>"+img_url+"</a>"+"<br/>"+
        "<a href='"+mobile_url+"'>"+mobile_url+"</a>"+
      "</center>" 
    );
  $('#overlay').fadeTo(500,1.0);  
}

function youtube_popup(img_url) {
  var new_id = new Date().getTime(); 
  var regexp = new RegExp("popup", "g");  
  
  set_page_opacity(0.2,1500);
  
  $('#overlay').html( 
       "<div class='close_icon'>"+
         "<a href='#' onclick='close_popup();return false;'>"+
          "<img src='/images/close.gif?"+new_id+"'>"+
         "</a>"+
       "</div>" +
       "<div style='margin-top: 80px; vertical-align: baseline;'>"+
         "<object width='640' height='480'><param name='movie' value='"+img_url+
         "?fs=1&amp;hl=en_US&amp;rel=0&amp;color1=0x2b405b&amp;color2=0x6b8ab6'>"+
         "</param><param name='allowFullScreen' value='true'></param>"+
         "<param name='allowscriptaccess' value='always'></param><embed src='"+img_url+
         "?fs=1&amp;hl=en_US&amp;rel=0&amp;color1=0x2b405b&amp;color2=0x6b8ab6' "+
         "type='application/x-shockwave-flash' allowscriptaccess='always' "+
         "allowfullscreen='true' width='640' height='480'></embed></object>"+
       "</div>"+
       "<center><a href='"+img_url+"'>YouTube: "+img_url+"</a></center>" 
       );
  $('#overlay').fadeTo(500,1.0);  
}

function insert_load_button(where,txt,path) {
  var target = $("#"+where);
  var id='load_more_link';
  target.html("<div id='"+id+"'><img src='/images/spinner.gif' title='Loading...' /> "+txt+"</div>");
  $.ajax({ url: path, context: where});
}

function toggle_div(what) {
  var content = $("#"+what);
  content.toggle();
}

function restore_comment(where,content) {
  where.html(content);
}
  

