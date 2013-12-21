render = ->
  el = d3.select '.js-scatterplot'
  margin = top: 10, right: 10, bottom: 10, left: 10
  width = parseFloat(el.style('width')) - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  x = d3.scale.linear().range [0, width]
  y = d3.scale.linear().range [height, 0]

  xax = d3.svg.axis().scale(x).orient 'bottom'
  yax = d3.svg.axis().scale(y).orient 'left'

  vis = el.append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
  .append('g')
    .attr('transform', "translate(#{margin.left},#{margin.top})")

  dataLoaded = (error, data) ->
    data = data.filter (d) -> d.min >= 20 and d.gp >= 10

    redraw = ->
      stats = refreshStats()

      xext = d3.extent data, (d) -> d[stats.xstat.k]
      yext = d3.extent data, (d) -> d[stats.ystat.k]

      console.log xext, yext

    refreshStats = ->
      xstat = el.attr 'data-x'
      ystat = el.attr 'data-y'

      if not ystat
        ystat = d3.shuffle(__metrics)[0]
        el.attr 'data-y', ystat.k
      else
        ystat = __metrics.filter((v) -> v.k == ystat)[0]

      if not xstat
        xstat = d3.shuffle(__metrics)[0]
        el.attr 'data-x', xstat.k
      else
        xstat = __metrics.filter((v) -> v.k == xstat)[0]

      {xstat, ystat}

    d3.selectAll('.js-stats .js-stat').on 'change', (e) ->
      select = d3.select this
      stat = @options[@selectedIndex].value
      axis = select.attr 'data-axis'

      el.attr "data-#{axis}", stat
      redraw()

    redraw()


  d3.csv('players.csv')
    .row((player) ->
      for key,val of player
        str = parseFloat val
        player[key] = str if !isNaN(str)
      player)
    .get(dataLoaded)

document.addEventListener 'DOMContentLoaded', render
