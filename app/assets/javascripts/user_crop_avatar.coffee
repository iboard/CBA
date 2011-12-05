jQuery ->
  new AvatarCropper()

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio: 1
      setSelect: [10, 10, 100, 100]
      minSize: [100,100]
      onSelect: @update
      onChange: @update
  
  update: (coords) =>
    $('#crop_x').val(coords.x)
    $('#crop_y').val(coords.y)
    $('#crop_w').val(coords.w)
    $('#crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
          $('#preview').css
                  width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
                  height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
                  marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
                  marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'
                  overflow: 'hidden'