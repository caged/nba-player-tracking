render = ->
  margin = top: 10, right: 10, bottom: 10, left: 10
  width = 1000 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  dataLoaded = (error, data) ->
    d3.selectAll('.js-stats-x .js-x').on 'change', (e) ->
      stat = @options[@selectedIndex].value



  d3.csv('players.csv')
    .row((player) ->
      for key,val of player
        str = parseFloat val
        player[key] = str if !isNaN(str)
      player)
    .get(dataLoaded)

document.addEventListener 'DOMContentLoaded', render
