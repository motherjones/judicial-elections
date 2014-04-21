docHeight = $(window).height()

$sections = $("section")

#$sections.css("min-height", docHeight)

$('section img').hide(150)

$window = $(window)

$img = $('#pinned-image')

$img.attr('src', $('section').first().find('img').attr('src'))

numberSections = ->
  $sections.each (i, el) ->
    $(el).attr('id', i)

numberSections()    

$(document).ready ->

  scrollorama = $.scrollorama({
    blocks: '.section-panel'
    enablePin: false
    })
  
  scrollorama.onBlockChange ->
      
      # Restrict the function from executing repeatedly within 2s
      # http://underscorejs.org/#debounce
      _.debounce( $img.fadeOut(200, ->
        $img.attr('src', $('#'+scrollorama.blockIndex).find('img').attr('src')).fadeIn(500)
      ), 2000)