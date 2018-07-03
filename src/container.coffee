import Singleton from './definition/singleton'
import Factory from './definition/factory'
import Value from './definition/value'
import List from './definition/list'
import Definition from './definition'
import Add from './definition/add'
import Predefinition from './predefinition'

export default class Container
	definitions: new Map
	g: {}

	defineGetterProperty: (alias, name)->
		if alias of this.g
			throw new Error("alias '#{alias}' already exists in container")

		Object.defineProperty this.g, alias,
			get: =>
				@get name

	defineAliases: (name)->
		camelCaseName = @toCamelCase name

		@defineGetterProperty name, name

		if camelCaseName != name
			@defineGetterProperty camelCaseName, name

	toCamelCase: (str) ->
		str
			.replace /\s(.)/g, ($1)-> return $1.toUpperCase()
			.replace /[\.\-\_]([a-z])/g, ($1, $2)-> return $2.toUpperCase()
			.replace /\s/g, ''

	define: (name, value) ->
		if value instanceof Predefinition
			@definitions.set name, value.make this, name
		else if typeof value == 'function'
			@singleton name, value
		else if Array.isArray(value)
			@definitions.set name, (new Predefinition List, [value]).make this, name
		else
			@value name, value

	singleton: (name, factory) ->
		@definitions.set name, new Singleton new Factory factory
		@defineAliases(name)

		this

	value: (name, value) ->
		@definitions.set name, new Value value
		@defineAliases name

		this

	factory: (name, factory) ->
		@definitions.set name, new Factory factory
		@defineAliases name

		this

	add: (name, items) ->
		if not Array.isArray(items)
			items = [items]

		items = items.map (it) -> if it instanceof Definition then it else new Value it

		if not @definitions.has name
			@definitions.set name, new List items
		else
			@definitions.set name, Add.make this, @definitions.get(name), items

		this

	make: (...args) ->
		@get(args...)

	get: (name, ...args)->
		if not @definitions.has name
			throw new Error 'Instance not found: ' + name

		def = @definitions.get name
		def.get this, args

	configure: (obj) ->
		for [key, value] in Object.entries(obj)
			@define key, value

		this
