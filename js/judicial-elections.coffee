docHeight = $(window).height()

$sections = $("section")

#$sections.css("min-height", docHeight)

#$('section img').hide(50)

$window = $(window)

$img = $('#pinned-image')

$img.attr('src', $('section').first().find('img').attr('src'))



checkInView = ->
  docHeight = $(window).height()
  winTop = $(window).scrollTop()
  winBottom = winTop + $(window).height()
  scrollTop = $(document).scrollTop()

  console.log "check in view"
  console.log scrollTop

  $sections.each (i, el) ->
    elTop = $(el).offset().top
    elBottom = elTop + $(el).height()

    if elTop >= winTop and elTop <= winBottom
      $('#section-nav').text($(el).find('img').attr('src')+ " winTop: "+winTop+" elTop: "+elTop)

      $img.attr('src', $(el).find('img').attr('src'))


$window.on 'scroll', (e) ->
  _.throttle(checkInView(), 750)