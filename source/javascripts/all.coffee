#= require mappings
#= require matrix
#= require interactive

document.addEventListener 'DOMContentLoaded', (e) ->
  d3.selectAll('.js-tabs li').on 'click', (e) ->
    event.preventDefault()

    d3.selectAll('.js-tabs li').classed 'selected', false

    link = d3.select(this).classed('selected', true).select('a')
    id = link.attr 'href'

    d3.selectAll('.js-tab-panel').classed('hidden', true)
    d3.select(id).classed('hidden', false)

