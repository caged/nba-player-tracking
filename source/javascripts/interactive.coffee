# Drive and Kick      - http://localhost:4567/interactive?y=pts_crt&x=dpp
# And One Assists     - http://localhost:4567/interactive?y=pts_crt&x=ast_ft
# Always Be Passig    - http://localhost:4567/interactive?y=pass&x=top
# Going for the steal - http://localhost:4567/interactive?y=dist_pg&x=stl
# Old Guys Driving    - http://localhost:4567/interactive?y=dvs&x=age
render = ->
  el = d3.select '.js-scatterplot'
  margin = top: 20, right: 20, bottom: 50, left: 60
  width = parseFloat(el.style('width')) - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  x = d3.scale.linear().nice().range [0, width]
  y = d3.scale.linear().nice().range [height, 0]

  xax = d3.svg.axis()
    .scale(x)
    .tickPadding(10)
    .tickSize(height)
    .orient 'bottom'

  yax = d3.svg.axis()
    .scale(y)
    .tickPadding(10)
    .tickSize(width)
    .orient 'left'

  tip = d3.tip()
    .attr('class', 'd3-tip')
    .offset([-2, 0])
    .html (d) -> "#{d.team_abbreviation}: #{d.player} (#{d.position})"

  vis = el.append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
  .append('g')
    .attr('transform', "translate(#{margin.left},#{margin.top})")
    .call(tip)

  dataLoaded = (error, data) ->
    #data = data.filter (d) -> d.min >= 20 and d.gp >= 10
    data = data.filter (d) -> d.team_abbreviation and d.min > 10

    xag = vis.append('g')
      .attr('class', 'x axis')
      .call(xax)

    yag = vis.append('g')
      .attr('transform', "translate(#{width},0)")
      .attr('class', 'y axis')
      .call(yax)

    points = vis.selectAll('.player')
      .data(data, (d) -> d.player_id)

    xal = xag.append('text')
      .attr('class', 'label')
      .attr('text-anchor', 'end')
      .attr('x', width + 10)
      .attr('y', height + 40)

    yal = yag.append('text')
      .attr('class', 'label')
      .attr('text-anchor', 'end')
      .attr('x', 0)
      .attr('y', -width - 40)
      .attr('transform', 'rotate(-90)')

    points.enter().append('circle')
      .attr('class', (d) -> "player #{d.position.split('-')[0].toLowerCase()}")
      .attr('r', 2)
      .on('mouseover', (d) -> tip.attr('class', 'd3-tip animate').show(d))
      .on('mouseout', (d) -> tip.attr('class', 'd3-tip').hide())

    redraw = ->
      stats = refreshStats()

      d3.select('.js-label-y').text stats.ystat.v
      d3.select('.js-label-x').text stats.xstat.v

      xext = d3.extent data, (d) -> d[stats.xstat.k]
      yext = d3.extent data, (d) -> d[stats.ystat.k]

      x.domain xext
      y.domain yext

      xal.text stats.xstat.v
      yal.text stats.ystat.v

      transition = vis.transition().duration(300)
      transition.select('.x.axis').call(xax)
      transition.select('.y.axis').call(yax)

      points.transition().duration(500).ease('cubic-out')
        .attr('cx', (d) -> x d[stats.xstat.k])
        .attr('cy', (d) -> y d[stats.ystat.k])
        .attr('r', 4)

      points.exit().remove()

      updateTopListsForStats(stats)


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

      url = "#{document.location.origin}/interactive?y=#{ystat.k}&x=#{xstat.k}"
      d3.select('.js-url').attr 'value', url

      {xstat, ystat}

    d3.selectAll('.js-stats .js-stat').on 'change', (e) ->
      select = d3.select this
      stat = @options[@selectedIndex].value
      axis = select.attr 'data-axis'

      el.attr "data-#{axis}", stat
      redraw()


    updateTopListsForStats = (stats) ->
      xkey = stats.xstat.k
      ykey = stats.ystat.k

      topx = data.sort((a, b) -> d3.descending a[xkey], b[xkey])[0..9]
      topy = data.sort((a, b) -> d3.descending a[ykey], b[ykey])[0..9]

      d3.select('.js-top-y-label').text stats.ystat.v
      d3.select('.js-top-x-label').text stats.xstat.v

      yrow = d3.select('.js-top-y').selectAll('tr').data(topy, (d) -> d.player_id)
      xrow = d3.select('.js-top-x').selectAll('tr').data(topx, (d) -> d.player_id)

      yrow.enter().append('tr').attr('data-player', (d) -> d.player)
      xrow.enter().append('tr').attr('data-player', (d) -> d.player)

      ycells = yrow.selectAll('td')
        .data((d, i) -> ["##{i+1}", d.player, d.team_abbreviation, d[ykey].toFixed()])

      xcells = xrow.selectAll('td')
        .data((d, i) -> ["##{i+1}", d.player, d.team_abbreviation, d[xkey].toFixed()])

      ycells.enter().append('td').html((d) -> d)
      xcells.enter().append('td').html((d) -> d)

      ycells.exit().remove()
      xcells.exit().remove()
      yrow.exit().remove()
      xrow.exit().remove()



    # Main entry point
    #
    # Initialize the chart once the page and data has loaded
    redraw()


  d3.csv('players.csv')
    .row((player) ->
      for key,val of player
        str = parseFloat val
        player[key] = str if !isNaN(str)
      player)
    .get(dataLoaded)

document.addEventListener 'DOMContentLoaded', render
