#= require mappings

width   = 1500
size    = 200
padding = 30

x = d3.scale.linear().range [padding / 2, size - padding / 2]
y = d3.scale.linear().range [size - padding / 2, padding / 2]
xreg = d3.scale.linear().range [padding, size - padding]
yreg = d3.scale.linear().range [size - padding, padding]
color = d3.scale.ordinal().domain(['f', 'c', 'g']).range ['green', 'dodgerblue', 'purple']

xax = d3.svg.axis().scale(x).orient('bottom').ticks(5)
yax = d3.svg.axis().scale(y).orient('left').ticks(5)

labelForKey = (key) ->
  __mappings.filter((d) -> d.k == key)?[0]?.v

dataLoaded = (error, data) ->
  data    = data.filter (d) -> d.min >= 20.0 and d.gp >= 10
  props   = []
  extents = {}

  for key,val of data[0]
    if !isNaN(parseFloat(val)) and key not in ['player_id', 'num', 'leagueid', 'season', 'teamid', 'gp']
      props.push key
      extents[key] = d3.extent data, (d) -> d[key]

  #props = props.slice(0, 15)

  len = props.length
  crossed = cross props, props

  xax.tickSize size * len
  yax.tickSize -size * len

  vis = d3.select(document.body).append('svg')
    .attr('width', size * len + padding)
    .attr('height', size * len + padding)
    .attr('class', 'matrix')
  .append('g')
    .attr('transform', "translate(#{padding},#{padding / 2})")
    .style('font', '10px "Helvetica Neue"')

  vis.selectAll('.x.axis')
    .data(props)
  .enter().append('g')
    .attr('class', 'x axis')
    .attr('transform', (d, i) -> "translate(#{(len - i - 1) * size}, 0)")
    .each((d) -> x.domain(extents[d]).nice(); d3.select(this).call(xax))

  vis.selectAll('.y.axis')
    .data(props)
  .enter().append('g')
    .attr('class', 'y axis')
    .attr('transform', (d, i) -> "translate(0, #{i * size})")
    .each((d) -> y.domain(extents[d]); d3.select(this).call(yax))

  vis.selectAll('.axis line')
    .style('stroke', '#ddd')

  plot = (p) ->
    el = d3.select this
    x.domain extents[p.x]
    y.domain extents[p.y]

    el.append('rect')
      .attr('class', 'frame')
      .attr('x', padding / 2)
      .attr('y', padding / 2)
      .attr('width', size - padding)
      .attr('height', size - padding)
      .classed('master', (d) -> d.x == d.y)
      .style('stroke', (d) -> if d.x == d.y then 'tomato' else '#999')
      .style('stroke-width', (d) -> if d.x == d.y then 2 else 1)
      .style(fill: 'none', 'shape-rendering': 'crispedges')


    if p.x != p.y
      el.selectAll('circle')
        .data(data)
      .enter().append('circle')
        .attr('cx', (d) -> x d[p.x])
        .attr('cy', (d) -> y d[p.y])
        .attr('r', 1.5)
        .style('fill', (d) -> color d.position.toLowerCase().split('-')[0])

  cell = vis.selectAll('.cell')
    .data(crossed)
  .enter().append('g')
    .attr('class', 'cell')
    .attr('transform', (d) -> "translate(#{(len - d.i - 1) * size}, #{d.j * size})")
    .each(plot)

  cell.filter((d) -> d.i == d.j).append('text')
    .attr('x', padding)
    .attr('y', padding)
    .attr('dy', 5)
    .attr('dx', -5)
    .attr('class', 'label')
    .text((d) -> labelForKey(d.x) or d.x)
    .style('font-weight', 'bold')

  vis.selectAll('.domain')
    .style(
      fill: 'none'
      'stroke-width': 0)

cross = (a, b) ->
  c = []
  for xv,i in a
    for yv,j in b
      c.push x: xv, i: i, y: yv, j: j
  c

d3.csv('players.csv')
  .row((player) ->
    for key,val of player
      str = parseFloat val
      player[key] = str if !isNaN(str)
      player[key] = 0 if val in ['', ' ', '-']
    player)
  .get(dataLoaded)
