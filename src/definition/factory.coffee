import Definition from '../definition'

export default class Factory extends Definition
	constructor: (@func) ->
		super()

	get: (c, args) ->
		return @func(c, args...)

	@make: (c, prev, what) ->
		new Factory(what)
