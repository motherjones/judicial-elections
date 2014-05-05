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
    makeBarChart(data)
  simpleSheet: true  
)

makeBarChart = (data) ->
  console.log "Making a bar chart of ", data

  w = 600
  h = 400
  margin = 50

  max = d3.max(data, (d) -> 
    console.log d.donations, parseInt(d.donations.substring(1))
    parseInt(d.donations.substring(1))
  )

  y = d3.scale.ordinal()
    .domain(d3.range(data.length))
    .rangeBands([0, h-margin], 0.2)

  x = d3.scale.linear()
    .domain([0, max])
    .range([0,w-margin])

  svg = d3.select('#section3')
  .append('svg')
  .attr('width', w)
  .attr('height', h)
  .append('g')
  .attr("transform", "translate("+margin+","+margin+")")

  bars = svg.selectAll('rect')
  .data(data)
  .enter()
  .append('rect')
  .attr({
    width: (d,i) ->
      console.log 'd', d, 'd.donations', parseInt(d.donations.substring(1)), 'x', x(parseInt(d.donations.substring(1)))
      x(parseInt(d.donations.substring(1)))
    height: y.rangeBand()
    y: (d,i) ->
      y(i)
  })
