d3.csv('../data/section1.csv', (err, _json) ->
  $.each(_json, (key, data) ->
    #console.log 'k', key, 'd', data
    $('#section1 #'+data.State).css('fill', ->
      if data['Judicial Election?'] is 'Y'
        'red'
    )
  )
)

d3.csv('../data/section2.csv', (err, _json) ->
  console.log 'json', _json
  $.each(_json, (key, data) ->
    console.log 'k', key, 'd', data, data.State
    $('#section2 #'+data.State).css('fill', ->
      if data['Fail?'] is 'Y'
        'red'
    )
  )
)