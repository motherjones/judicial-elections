// Generated by CoffeeScript 1.6.2
var $img, $sections, $window, docHeight, numberSections;

docHeight = $(window).height();

$sections = $("section");

$sections.css("min-height", docHeight);

$('section img').hide(150);

$window = $(window);

$img = $('#pinned-image');

$img.attr('src', $('section').first().find('img').attr('src'));

$('section').first().find('p').css('bottom', 'auto').css('top', '300px');

numberSections = function() {
  return $sections.each(function(i, el) {
    return $(el).attr('id', i);
  });
};

numberSections();

$(document).ready(function() {
  var scrollorama;

  scrollorama = $.scrollorama({
    blocks: '.section-panel',
    enablePin: false
  });
  return scrollorama.onBlockChange(function() {
    return _.debounce($img.fadeOut(200, function() {
      return $img.attr('src', $('#' + scrollorama.blockIndex).find('img').attr('src')).fadeIn(500);
    }), 2000);
  });
});
