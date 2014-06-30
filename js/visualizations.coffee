### Section 1 ###
console.log "Section 1"

highlightColor = '#FDBB64'

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
  key: 'https://docs.google.com/spreadsheets/d/1KgJ8pHxwPvtxLH4bQLsxkpXxt1Gbj5JXVAl8Ho8c2ys/pubhtml'
  callback: (data, tabletop) ->
  
    _.each(data, (row) ->
      amountraised = row.amountraised.substring(1)
      amountraised = amountraised.replace(/,/g , "")

      row.amountraised = parseInt(amountraised)
    )
  
    
    console.log "Making a bar chart of ", data

    w = 800
    h = 300
    margin = {
      left: 48
      top: 32
      bottom: 32
      right: 32
    }
    labelFontSize = 12

    max = d3.max(data, (d) -> d.amountraised )

    y = d3.scale.ordinal()
      .domain(d3.range(data.length))
      .rangeBands([0, h-( margin.top + margin.bottom )], 0.5)

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

    svg = d3.select('#section2')
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
        x(parseInt(d.amountraised))
      height: y.rangeBand()
      y: (d,i) ->
        parseInt(y(i))
    })
    .style({
      fill: highlightColor
    })

    svg.append("g")
      .attr('class', 'x axis')
      .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
      .call(xAxis)

    labels = bars.append("text")
      .text((d) -> d.decade)
      .style({
        'text-anchor': 'end'
        'font-size': labelFontSize+'px'
      })
      .attr({
        x: -5
        y: (d,i) -> parseInt(y(i)) + y.rangeBand() / 2
      })

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
    
    console.log "Making a bar chart of ", data

    w = 800
    h = 600
    margin = {
      left: 32
      top: 32
      bottom: 32
      right: 32
    }
    labelFontSize = 12

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
    .style({
      fill: highlightColor
    })

    svg.append("g")
      .attr('class', 'x axis')
      .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
      .call(xAxis)

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

  simpleSheet: true  
)

### Section 4 ###
console.log "Section 4"

Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/108e0CYLyXIWq7SZgHaQp2MT7qj6SB2mgUMAD4Euz9oI/pubhtml'
  callback: (data, tabletop) ->
    
    _.each(data, (row) ->
      candidatepercent = row.candidatepercent
      candidatepercent = candidatepercent.replace(/%/g , "")
      row.candidatepercent = parseInt(candidatepercent)

      noncandidatepercent = row['non-candidatepercent']
      noncandidatepercent = noncandidatepercent.replace(/%/g , "")
      row['non-candidatepercent'] = parseInt(noncandidatepercent)
    )
    

    console.log "S4: Making a bar chart of ", data

    w = 800
    h = 600
    margin = {
      left: 32
      top: 32
      bottom: 64
      right: 32
    }
    labelFontSize = 12

    data = _.filter(data, (row) ->
      row.donations isnt 0
    )

    ###
    max = d3.max(data, (d) -> 
      #console.log d.donations.substring(1), parseInt(d.donations.substring(1))
      d.donations
    )
    ###
    max = 500

    x = d3.scale.ordinal()
      .domain(d3.range(data.length))
      .rangeBands([0, w-( margin.left + margin.right )], 0.2)

    y = d3.scale.linear()
      .domain([0, max])
      .range([h-( margin.top + margin.bottom ), 0])

    xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

    candidateLine = d3.svg.line()
      .x (d,i) -> 
        console.log "x(i)", x(i)
        x(i)
      .y (d,i) ->
        console.log "D!", d
        console.log "y(d.candidatepercent)", y(d.candidatepercent)
        y(d.candidatepercent)

    nonCandidateLine = d3.svg.line()
      .x (d,i) -> 
        x(i)
      .y (d,i) -> 
        y(d['non-candidatepercent'])

    svg = d3.select('#section4')
    .append('svg')
    .attr('width', w)
    .attr('height', h)
    
    chart = svg.append('g')
    .attr("transform", "translate("+margin.left+","+margin.top+")")

    svg.append("g")
      .attr('class', 'x axis')
      .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
      .call(xAxis)

    chart.append('path')
      .datum(data)
      .attr('class', 'line')
      .attr('id', 'candidateLine')
      .attr('d', candidateLine)
      .style({
        'fill': 'none'
        'stroke': '#EC553F'
        'stroke-width': '6px'
      })

    
    chart.append('path')
      .datum(data)
      .attr('class', 'line')
      .attr('id', 'nonCandidateLine')
      .attr('d', nonCandidateLine)
      .style({
        'fill': 'none'
        'stroke': highlightColor
        'stroke-width': '6px'
      })
    



  simpleSheet: true  
)

### Section 5 ###
console.log "Section 5"

Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1nJ1nMh4kLqHRIgGCQMQfx0aJdEZZGrPBYxJlK8gmV90/pubhtml'
  callback: (_json, tabletop) -> 
    $.each(_json, (key, data) ->
      $('#section5 #'+data.state).css('fill', ->
        if data.fail is 'Y'
          highlightColor
      )
    )
  simpleSheet: true  
)

### Section 7 ###
console.log "Section 7"
Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1J9uKeRIrcN7qCiFmUf8kvVsh2vvHpQZICFB-klor-2M/pubhtml'
  callback: (data, tabletop) ->
    
    _.each(data, (row) ->
      totalspending = row['totalspending2000-09'].substring(1)
      totalspending = totalspending.replace(/,/g , "")
      row.totalspending = parseInt(totalspending)
      row['totalspending2000-09'] = row.totalspending
    )
    
    
    console.log "Making a bar chart of ", data

    w = 800
    h = 600
    margin = {
      left: 72
      top: 32
      bottom: 32
      right: 32
    }
    labelFontSize = 12

    max = d3.max(data, (d) -> d['totalspending2000-09'] )

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

    svg = d3.select('#section7')
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
        x(parseInt(d.totalspending))
      height: y.rangeBand()
      y: (d,i) ->
        parseInt(y(i))
    })
    .style({
      fill: highlightColor
    })

    svg.append("g")
      .attr('class', 'x axis')
      .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
      .call(xAxis)

    labels = bars.append("text")
      .text((d) -> d.state)
      .style({
        'text-anchor': 'end'
        'font-size': labelFontSize+'px'
      })
      .attr({
        x: -5
        y: (d,i) -> parseInt(y(i)) + y.rangeBand() / 2
      })

  simpleSheet: true  
)

### Section 9 ###
console.log "Section 9"
Tabletop.init(
  key: 'https://docs.google.com/spreadsheets/d/1E_Km7bRqzuzF3Z5PEaBAyxVHuLT6bgwW9Tujj_imeUo/pubhtml'
  callback: (data, tabletop) ->
    
    
    _.each(data, (row) ->
      amount = row.amount.replace(/,/g , "")
      row.amount = parseInt(amount)
    )
    
    
    console.log "Making a bar chart of ", data

    w = 800
    h = 600
    margin = {
      left: 64
      top: 32
      bottom: 32
      right: 32
    }
    labelFontSize = 12

    max = d3.max(data, (d) -> d.amount )

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

    svg = d3.select('#section9')
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
        x(parseInt(d.amount))
      height: y.rangeBand()
      y: (d,i) ->
        parseInt(y(i))
    })
    .style({
      fill: highlightColor
    })

    svg.append("g")
      .attr('class', 'x axis')
      .attr('transform', 'translate('+margin.left+','+(h-margin.bottom)+')')
      .call(xAxis)

    labels = bars.append("text")
      .text((d) -> d.cycle)
      .style({
        'text-anchor': 'end'
        'font-size': labelFontSize+'px'
      })
      .attr({
        x: -5
        y: (d,i) -> parseInt(y(i)) + y.rangeBand() / 2
      })

  simpleSheet: true  
)