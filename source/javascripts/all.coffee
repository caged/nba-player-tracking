width   = 1500
size    = 200
padding = 20

x = d3.scale.linear().range [padding / 2, size - padding / 2]
y = d3.scale.linear().range [size - padding / 2, padding / 2]

xax = d3.svg.axis().scale(x).orient('bottom').ticks(5)
yax = d3.svg.axis().scale(y).orient('left').ticks(5)

dataLoaded = (error, data) ->
  data    = data.filter (d) -> d.min >= 20.0 and d.gp >= 10
  props   = []
  extents = {}

  for key,val of data[0]
    if !isNaN(parseFloat(val)) and key != 'player_id'
      props.push key
      extents[key] = d3.extent data, (d) -> d[key]

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

  vis.selectAll('.x.axis')
    .data(props)
  .enter().append('g')
    .attr('class', 'x axis')
    .attr('transform', (d, i) -> "translate(#{(len - i - 1) * size}, 0)")
    .each((d) -> x.domain(extents[d]); d3.select(this).call(xax))

  vis.selectAll('.y.axis')
    .data(props)
  .enter().append('g')
    .attr('class', 'y axis')
    .attr('transform', (d, i) -> "translate(0, #{i * size})")
    .each((d) -> y.domain(extents[d]); d3.select(this).call(yax))

  console.log data[0]
  plot = (p) ->
    cell = d3.select this
    x.domain extents[p.x]
    y.domain extents[p.y]

    cell.append('rect')
      .attr('class', 'frame')
      .attr('x', padding / 2)
      .attr('y', padding / 2)
      .attr('width', size - padding)
      .attr('height', size - padding)

    cell.selectAll('circle')
      .data(data)
    .enter().append('circle')
      .attr('cx', (d) -> x d[p.x])
      .attr('cy', (d) -> y d[p.y])
      .attr('r', 2)

  cell = vis.selectAll('.cell')
    .data(crossed)
  .enter().append('g')
    .attr('class', 'cell')
    .attr('transform', (d) -> "translate(#{(len - d.i - 1) * size}, #{d.j * size})")
    #.each(plot)

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
    player)
  .get(dataLoaded)
