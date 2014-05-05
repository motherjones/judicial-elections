### Section 1 ###
console.log "Section 1"

highlightColor = 'red'

Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1GoRtZDxS0sIcn1zfPW0NR9K5BVFKPjI6EkjWdd1Oog4/pubhtml'
  callback: (_json, tabletop) -> 
    $.each(_json, (key, data) ->
      $('#section1 #'+data.state).css('fill', ->
        if data.judicialelection is 'Y'
          highlightColor
      )
    )
  simpleSheet: true  
)

### Section 2 ###
console.log "Section 2"

Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1nJ1nMh4kLqHRIgGCQMQfx0aJdEZZGrPBYxJlK8gmV90/pubhtml'
  callback: (_json, tabletop) -> 
    $.each(_json, (key, data) ->
      $('#section2 #'+data.state).css('fill', ->
        if data.fail is 'Y'
          highlightColor
      )
    )
  simpleSheet: true  
)

### Section 3 ###
console.log "Section 3"

Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1MzVz_KTvgmxcuC11Z0UIPXYyqb418-6jRjHdPUKZnDo/pubhtml'
  callback: (data, tabletop) ->
    _.each(data, (row) ->
      donation = row.donations.substring(1)
      donation = donation.replace(/,/g , "")
      row.donations = parseInt(donation)
    )
    makeBarChart(data)
  simpleSheet: true  
)

makeBarChart = (data) ->
  console.log "Making a bar chart of ", data

  w = 800
  h = 600
  margin = {
    left: 32
    top: 32
    bottom: 32
    right: 32
  }

  console.log 'margin', margin, margin.top

  data = _.filter(data, (row) ->
    row.donations isnt 0
  )

  max = d3.max(data, (d) -> 
    #console.log d.donations.substring(1), parseInt(d.donations.substring(1))
    d.donations
  )

  y = d3.scale.ordinal()
    .domain(d3.range(data.length))
    .rangeBands([0, h-( margin.top + margin.bottom )], 0.2)

  x = d3.scale.linear()
    .domain([0, max])
    .range([0,w-( margin.left + margin.right )])

  xAxis = d3.svg.axis()
    .scale(x)
    .orient('bottom')
    .tickFormat((d) -> 
      moneyTickFormat = d3.format(".2s")
      '$' + moneyTickFormat(d)
    )

  svg = d3.select('#section3')
  .append('svg')
  .attr('width', w)
  .attr('height', h)
  
  chart = svg.append('g')
  .attr("transform", "translate("+margin.left+","+margin.top+")")

  bars = chart.selectAll('g.rect')
  .data(data)
  .enter()
  .append('g')
  .attr('class', 'rect')

  bars.append('rect')
  .attr({
    width: (d,i) ->
      #console.log 'd', d, 'd.donations', parseInt(d.donations.substring(1)), 'x', x(parseInt(d.donations.substring(1)))
      x(parseInt(d.donations))
    height: y.rangeBand()
    y: (d,i) ->
      parseInt(y(i))
  })

  svg.append("g")
    .attr('class', 'x axis')
    .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
    .call(xAxis)


  labelFontSize = 12

  labels = bars.append("text")
    .text((d) -> d.state)
    .style({
      'text-anchor': 'end'
      'font-size': labelFontSize+'px'
    })
    .attr({
      x: -5
      y: (d,i) -> parseInt(y(i)) + labelFontSize
    })








