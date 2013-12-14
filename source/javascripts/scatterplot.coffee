render = ->
  players = null
  margin = top: 10, right: 10, bottom: 20, left: 40
  width = 1000 - margin.left - margin.right
  height = 500 - margin.top - margin.bottom

  chosen = x: 'dist_pg', y: 'catch_shoot_pts'

  x = d3.scale.linear().range [0, width]
  y = d3.scale.linear().range [height, 0]

  xax = d3.svg.axis().scale(x).orient('bottom')
  yax = d3.svg.axis().scale(y).orient('left')

  tip = d3.tip().html (d) -> d.player

  options = d3.select(document.body).append('div').selectAll('.option')
    .data(['x', 'y'])
  .enter().append('div')
    .attr('class', (d) -> "option option-#{d}")
    .text((d) -> d)

  selects = options.append('select').attr('name', (d) -> d)

  vis = d3.select(document.body).append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
  .append('g')
    .attr('transform', "translate(#{margin.left},#{margin.top})")
    .call(tip)


  dataLoaded = (error, data) ->
    data = data.filter (d) -> d.min >= 20.0 and d.gp >= 10

    update = ->
      xext = d3.max data, (d) -> d[chosen.x]
      yext = d3.max data, (d) -> d[chosen.y]

      x.domain([0, xext]).nice()
      y.domain([0, yext]).nice()

      vis.select('.y').transition().duration(500).call(yax)
      vis.select('.x').transition().duration(500).call(xax)

      players.transition().duration(500).ease('cubic-out')
        .attr('cx', (d) -> x d[chosen.x])
        .attr('cy', (d) -> y d[chosen.y])

      vis.select('.xlabel').text(chosen.x)
      vis.select('.ylabel').text(chosen.y)

    props = []
    for key,val of data[0]
      props.push(key) if !isNaN(parseFloat(val)) and key != 'player_id'

    props.sort()

    selects.on 'change', (d) ->
      chosen[d] = d3.select(@options[@selectedIndex]).text()
      update()

    xext = d3.extent data, (d) -> d[chosen.x]
    yext = d3.extent data, (d) -> d[chosen.y]

    x.domain(xext).nice()
    y.domain(yext).nice()

    selects.selectAll('option')
      .data(props)
    .enter().append('option')
      .text((d) -> d)

    vis.append('g')
      .attr('transform', "translate(0,#{height})")
      .attr('class', 'x axis')
      .call(xax)
    .append('text')
      .attr('class', 'xlabel')
      .attr('x', width)
      .attr('y', -5)
      .attr('text-anchor', 'end')
      .text(chosen.x)

    vis.append('g')
      .call(yax)
      .attr('class', 'y axis')
    .append('text')
      .attr('class', 'ylabel')
      .attr('text-anchor', 'end')
      .attr('y', 15)
      .attr('transform', 'rotate(-90)')
      .text(chosen.y)

    players = vis.selectAll('.player')
      .data(data, (d) -> d.player_id)
    .enter().append('circle')
      .attr('r', 3)
      .attr('cx', (d) -> x d[chosen.x])
      .attr('cy', (d) -> y d[chosen.y])
      .attr('class', (d) -> "player #{d.team_abbreviation.toLowerCase()}")
      .on('mouseover', tip.show)
      .on('mouseout', tip.hide)


  d3.csv('players.csv')
    .row((player) ->
      for key,val of player
        str = parseFloat val
        player[key] = str if !isNaN(str)
      player)
    .get(dataLoaded)

document.addEventListener 'DOMContentLoaded', render
