// Generated by CoffeeScript 1.6.2
/* Section 1
*/

var highlightColor, makeBarChart;

console.log("Section 1");

highlightColor = 'red';

Tabletop.init({
  key: 'https://docs.google.com/spreadsheets/d/1GoRtZDxS0sIcn1zfPW0NR9K5BVFKPjI6EkjWdd1Oog4/pubhtml',
  callback: function(_json, tabletop) {
    return $.each(_json, function(key, data) {
      return $('#section1 #' + data.state).css('fill', function() {
        if (data.judicialelection === 'Y') {
          return highlightColor;
        }
      });
    });
  },
  simpleSheet: true
});

/* Section 2
*/


console.log("Section 2");

Tabletop.init({
  key: 'https://docs.google.com/spreadsheets/d/1nJ1nMh4kLqHRIgGCQMQfx0aJdEZZGrPBYxJlK8gmV90/pubhtml',
  callback: function(_json, tabletop) {
    return $.each(_json, function(key, data) {
      return $('#section2 #' + data.state).css('fill', function() {
        if (data.fail === 'Y') {
          return highlightColor;
        }
      });
    });
  },
  simpleSheet: true
});

/* Section 3
*/


console.log("Section 3");

Tabletop.init({
  key: 'https://docs.google.com/spreadsheets/d/1MzVz_KTvgmxcuC11Z0UIPXYyqb418-6jRjHdPUKZnDo/pubhtml',
  callback: function(data, tabletop) {
    _.each(data, function(row) {
      var donation;

      donation = row.donations.substring(1);
      donation = donation.replace(/,/g, "");
      return row.donations = parseInt(donation);
    });
    return makeBarChart(data);
  },
  simpleSheet: true
});

makeBarChart = function(data) {
  var bars, chart, h, labelFontSize, labels, margin, max, svg, w, x, xAxis, y;

  console.log("Making a bar chart of ", data);
  w = 800;
  h = 600;
  margin = {
    left: 32,
    top: 32,
    bottom: 32,
    right: 32
  };
  console.log('margin', margin, margin.top);
  data = _.filter(data, function(row) {
    return row.donations !== 0;
  });
  max = d3.max(data, function(d) {
    return d.donations;
  });
  y = d3.scale.ordinal().domain(d3.range(data.length)).rangeBands([0, h - (margin.top + margin.bottom)], 0.2);
  x = d3.scale.linear().domain([0, max]).range([0, w - (margin.left + margin.right)]);
  xAxis = d3.svg.axis().scale(x).orient('bottom').tickFormat(function(d) {
    var moneyTickFormat;

    moneyTickFormat = d3.format(".2s");
    return '$' + moneyTickFormat(d);
  });
  svg = d3.select('#section3').append('svg').attr('width', w).attr('height', h);
  chart = svg.append('g').attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  bars = chart.selectAll('g.rect').data(data).enter().append('g').attr('class', 'rect');
  bars.append('rect').attr({
    width: function(d, i) {
      return x(parseInt(d.donations));
    },
    height: y.rangeBand(),
    y: function(d, i) {
      return parseInt(y(i));
    }
  });
  svg.append("g").attr('class', 'x axis').attr('transform', 'translate(' + margin.left + ',' + (h - margin.bottom) + ')').call(xAxis);
  labelFontSize = 12;
  return labels = bars.append("text").text(function(d) {
    return d.state;
  }).style({
    'text-anchor': 'end',
    'font-size': labelFontSize + 'px'
  }).attr({
    x: -5,
    y: function(d, i) {
      return parseInt(y(i)) + labelFontSize;
    }
  });
};
