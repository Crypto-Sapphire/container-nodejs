import {Container, add, alias, factory, get} from '../index'

test 'test normal usage', ->
	c = new Container

	c.define 'test', ->
		'help!'

	c.add 'test_add', [
		'get'
		'noic'
	]

	expect await c.get 'test'
		.toBe 'help!'

	expect await c.get 'test_add'
		.toEqual ['get', 'noic']

	c.add 'test_add', 'yes'

	expect await c.get 'test_add'
		.toEqual ['get', 'noic', 'yes']

	c.configure test_alias: alias 'test_add'

	expect await c.get 'test_alias'
		.toEqual ['get', 'noic', 'yes']

	c.add 'test_add', 'no'

	expect await c.get 'test_alias'
		.toEqual ['get', 'noic', 'yes', 'no']

	expect await c.get 'test_alias'
		.toEqual await c.get 'test_add'


	c.configure
		'coins.managed': add 'btc'
		'coins': true

	expect await c.get 'coins.managed'
		.toEqual ['btc']

	c.configure
		'coins.managed': add 'eth'

	expect await c.get 'coins.managed'
		.toEqual ['btc', 'eth']

	c.configure
		'coins.managed': ['bch']

	expect await c.get 'coins.managed'
		.toEqual ['bch']

	expect await c.g.coinsManaged
		.toEqual ['bch']

	expect await c.g['coins.managed']
		.toEqual ['bch']


test 'add', ->
	c = new Container

	c.define 'test', add 'test'

	expect await c.get 'test'
		.toEqual ['test']

	c.define 'test', add 'test'

	expect await c.get 'test'
		.toEqual ['test', 'test']

test 'factory', ->
	c = new Container
	c.define 'test', factory (c, ...args) -> args

	expect await c.get 'test', 'help'
		.toEqual ['help']

	expect await c.get 'test', 'yes', 'no'
		.toEqual ['yes', 'no']

test 'get', ->
	c = new Container
	c.define 'test', factory (c, ...args) -> args
	c.define 'test_get', get('test', 'yes')

	expect await c.get 'test', 'help'
		.toEqual ['help']

	expect await c.get 'test_get', 'help'
		.toEqual ['yes']

	expect await c.get 'test', 'yes', 'no'
		.toEqual ['yes', 'no']

	expect await c.get 'test_get'
		.toEqual ['yes']
