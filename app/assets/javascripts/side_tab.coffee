sidetab_timeouts = []
sidetab_focus    = null

# LOCAL FUNCTIONS

hideLinks = ->
  $(".comment-links").hide()
  cancelSideTabTimeouts()
  
hideSideTabs = ->
  $(".side-tab").hide()
  
focusChanged = (new_focus) ->
  return new_focus != sidetab_focus

closeNotFocused = (except)->
  cnt_tabs = $(".side-tab").length
  for idx in [0..(cnt_tabs-1)]
    tab = $(".side-tab:nth-child(#{idx})")
    unless tab.attr('id') == "side-tab-#{except.attr('id')}"
      tab.hide()
    
# GLOBAL FUNCTIONS

this.cancelSideTabTimeouts = ->
  for t in sidetab_timeouts
    clearTimeout(t)
  sidetab_timeouts = []

this.hideWithDelay = (what,time) ->
  sidetab_timeouts.push setTimeout("hideSideTab($(\"#"+what+"\"))", time)

this.showSideTab = (what) ->
  if focusChanged(what)
    closeNotFocused(what)
    sidetab_focus = what
    id = what.attr('id')
    $("#side-tab-#{id}").show()
    cancelSideTabTimeouts()
    style = what.attr('style')
    unless style.match /display: block/    
      what.show('slide', {direction: 'right', class: 'comment-links'},250)
        
    
this.hideSideTab = (what) ->
  try
    sidetab_focus = null
    style = what.attr('style')
    if style.match /display: block/
      this.cancelSideTabTimeouts()
      what.hide('slide',{direction: 'right',class: 'side-tab'}, 250)
  catch e
    # nothing
  hideSideTabs()      
        
# INITIALIZE
$(document).ready ->
  $(".comment-links").hide()
  
  

