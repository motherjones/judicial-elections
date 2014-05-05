// Generated by CoffeeScript 1.6.2
var $img, $sections, $window, docHeight, numberSections;

docHeight = $(window).height();

$sections = $("section");

$sections.css("min-height", docHeight);

$window = $(window);

$img = $('#pinned-image-container');

$img.html($('section').first().find('.section-graphic').html());

$('section').first().find('p').css('bottom', 'auto').css('top', '300px');

numberSections = function() {
  return $sections.each(function(i, el) {
    return $(el).attr('id', i);
  });
};

numberSections();

$(document).ready(function() {
  var scrollorama;

  Tabletop.init({
    key: 'https://docs.google.com/spreadsheets/d/1GoRtZDxS0sIcn1zfPW0NR9K5BVFKPjI6EkjWdd1Oog4/pubhtml',
    callback: function(data, tabletop) {
      return console.log(data);
    },
    simpleSheet: true
  });
  scrollorama = $.scrollorama({
    blocks: '.section-panel',
    enablePin: false
  });
  return scrollorama.onBlockChange(function() {
    return _.debounce($img.fadeOut(200, function() {
      return $img.html($('#' + scrollorama.blockIndex).find('.section-graphic').html()).fadeIn(500);
    }), 2000);
  });
});
