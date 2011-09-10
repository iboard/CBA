# -*- encoding : utf-8 -*-
# 
# Open a side-tab when the mouse moves over a headline of a posting
# Used in BlogsController::show 
#

sidetab_timeouts = []
sidetab_focus    = null

# LOCAL FUNCTIONS

hideLinks = ->
  $(".comment-links").hide()
  cancelSideTabTimeouts()
  
self.hideSideTabs = ->
  $(".side-tab").hide()
  
focusChanged = (new_focus) ->
  return new_focus != sidetab_focus

closeNotFocused = (except) ->
  cnt_tabs = $(".side-tab").hide() 
      
# GLOBAL FUNCTIONS

this.cancelSideTabTimeouts = ->
  for t in sidetab_timeouts
    clearTimeout(t)
  sidetab_timeouts = []

this.hideWithDelay = (what,time) ->
  sidetab_timeouts.push setTimeout("hideSideTab($(\"#"+what+"\"))", time)

this.showSideTab = (what) ->
  if what.attr('id')
    if focusChanged(what)
      cancelSideTabTimeouts()
      closeNotFocused(what)
      sidetab_focus = what
      id = what.attr('id')
      $("#side-tab-#{id}").show()
      style = what.attr('style')
      unless style.match /display: block/    
        what.show('slide', {direction: 'right', class: 'comment-links'},250)
        
    
this.hideSideTab = (what) ->
  try
    sidetab_focus = null
    style = what.attr('style')
    if style.match /display: block/
      this.cancelSideTabTimeouts()
      what.hide('slide',{direction: 'right'}, 250)
  catch e
    # nothing
  sidetab_timeouts.push setTimeout("hideSideTabs()",260)
        
# INITIALIZE
$(document).ready ->
  if $(".comment-links")
    $(".comment-links").hide()
  
  
