import {Container, add, alias, factory, get} from '../index'

test 'test normal usage', ->
	c = new Container

	c.define 'test', ->
		'help!'

	c.add 'test_add', [
		'get'
		'noic'
	]

	expect c.get 'test'
		.toBe 'help!'

	expect c.get 'test_add'
		.toEqual ['get', 'noic']

	c.add 'test_add', 'yes'

	expect c.get 'test_add'
		.toEqual ['get', 'noic', 'yes']

	c.configure test_alias: alias 'test_add'

	expect c.get 'test_alias'
		.toEqual ['get', 'noic', 'yes']

	c.add 'test_add', 'no'

	expect c.get 'test_alias'
		.toEqual ['get', 'noic', 'yes', 'no']

	expect c.get 'test_alias'
		.toEqual c.get 'test_add'


	c.configure
		'coins.managed': add 'btc'
		'coins': true

	expect c.get 'coins.managed'
		.toEqual ['btc']

	c.configure
		'coins.managed': add 'eth'

	expect c.get 'coins.managed'
		.toEqual ['btc', 'eth']

	c.configure
		'coins.managed': ['bch']

	expect c.get 'coins.managed'
		.toEqual ['bch']

	expect c.g.coinsManaged
		.toEqual ['bch']

	expect c.g['coins.managed']
		.toEqual ['bch']


test 'factory', ->
	c = new Container
	c.define 'test', factory (c, ...args) -> args

	expect c.get 'test', 'help'
		.toEqual ['help']

	expect c.get 'test', 'yes', 'no'
		.toEqual ['yes', 'no']

test 'get', ->
	c = new Container
	c.define 'test', factory (c, ...args) -> args
	c.define 'test_get', get('test', 'yes')

	expect c.get 'test', 'help'
		.toEqual ['help']

	expect c.get 'test_get', 'help'
		.toEqual ['yes']

	expect c.get 'test', 'yes', 'no'
		.toEqual ['yes', 'no']

	expect c.get 'test_get'
		.toEqual ['yes']
