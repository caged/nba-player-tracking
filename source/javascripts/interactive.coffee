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

    getUpdatedStats = ->
      xcat  = el.attr 'data-xcat'
      ycat  = el.attr 'data-ycat'
      xstat = el.attr 'data-x'
      ystat = el.attr 'data-y'

      categories = Object.keys __metrics

      if xcat and xstat
        xstat = __metrics[xcat].filter((v) -> v.k == xstat)[0]

      if ycat and ystat
        ystat = __metrics[ycat].filter((v) -> v.k == ystat)[0]

      if not xcat
        xcat = d3.shuffle(categories)[0]
        xstat = d3.shuffle(__metrics[xcat])[0]
        el.attr 'data-xcat': xcat, 'data-x': xstat.k

      if not ycat
        ycat = d3.shuffle(categories)[0]
        ystat = d3.shuffle(__metrics[ycat])[0]
        el.attr 'data-ycat': ycat, 'data-y': ystat.k

      {xstat, ystat}

    getUpdatedStats()

    d3.selectAll('.js-stats .js-stat').on 'change', (e) ->
      select = d3.select this
      stat = @options[@selectedIndex].value
      cat = select.attr 'name'
      axis = select.attr 'data-axis'

      el.attr "data-#{axis}cat", cat
      el.attr "data-#{axis}", stat
      console.log getUpdatedStats()


  d3.csv('players.csv')
    .row((player) ->
      for key,val of player
        str = parseFloat val
        player[key] = str if !isNaN(str)
      player)
    .get(dataLoaded)

document.addEventListener 'DOMContentLoaded', render
