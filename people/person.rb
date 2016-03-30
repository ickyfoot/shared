require 'date'
require 'sqlite3'

class Person
	#name is derived from firstName and lastName
	@name
	@firstName
	@lastName
	
	#age derived from currentDate - birthday
	@age
	@birthday
	@currentDate
	
	attr_accessor :firstName, :lastName, :name, :age, :birthday, :currentDate, :db
	
	def initialize
	end
	
	def greet
		puts "Hello, "+@name+", how are you?"
	end
	
	def calculateAge
		@age = (@currentDate - @birthday)/365.25
		# @age = @age.floor
	end
	
	def getAge
		if @age == nil
			puts @name+" hasn't been born yet."
		else 
			puts "It appears that you are "+@age.to_s+"."
		end
	end
	
	def saveInfo
		@name = @firstName+" "+@lastName
		@birthday = DateTime.parse(@birthday)
		@currentDate = DateTime.now
		db = SQLite3::Database.new(File.expand_path("../",File.dirname(__FILE__))+'/shared.db')
		
		rows = db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='person';")
		puts rows.length
		if (rows.length == 0)
			puts '"person" table does not exist.'
			db.execute("create table person (id integer primary key, firstName varchar(20), lastName varchar(30), birthday varchar(10))")
			puts '"person" table has been created.'
		else
			puts 'Table exists'
		end
		stm = db.prepare 'insert into person (firstName, lastName, birthday) values (?, ?, ?)'
		stm.bind_param 1, @firstName
		stm.bind_param 2, @lastName
		stm.bind_param 3, @birthday.to_s
		stm.execute
	end
	
	def self.clearPeople
	db = SQLite3::Database.new(File.expand_path("../",File.dirname(__FILE__))+'/shared.db')
		rows = db.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='person';")
		if (rows.length > 0)
			db.execute('drop table person')
			puts '"person" table dropped.'
		end
	end
	
	def countPeople
		db = SQLite3::Database.new(File.expand_path("../",File.dirname(__FILE__))+'/shared.db')
		results = db.execute('select count(id) from person')
		puts "There are #{results} people in the system."
	end
end
