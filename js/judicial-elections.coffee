docHeight = $(window).height()

$sections = $("section")

$sections.css("min-height", docHeight)

#$('section img').hide(150)

$window = $(window)

$img = $('#pinned-image-container')

$img.html( $('section').first().find('.section-graphic').html() )

$('section').first().find('p').css('bottom', 'auto').css('top', '300px')

numberSections = ->
  $sections.each (i, el) ->
    $(el).attr('id', i)

numberSections()    

$(document).ready ->

  

  Tabletop.init(
    key: 'https://docs.google.com/spreadsheets/d/1GoRtZDxS0sIcn1zfPW0NR9K5BVFKPjI6EkjWdd1Oog4/pubhtml'
    callback: (data, tabletop) -> console.log(data)
    simpleSheet: true  
  )

  scrollorama = $.scrollorama({
    blocks: '.section-panel'
    enablePin: false
    })
  
  scrollorama.onBlockChange ->
      
      # Restrict the function from executing repeatedly within 2s
      # http://underscorejs.org/#debounce
      _.debounce( $img.fadeOut(200, ->
        $img.html($('#'+scrollorama.blockIndex).find('.section-graphic').html()).fadeIn(500)
      ), 2000)



