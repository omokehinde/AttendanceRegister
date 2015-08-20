require 'sinatra'
# require 'dm-core'
require 'data_mapper'
# require 'dm-migrations'
# require 'dm-sqlite-adapter'
require 'bundler'
require 'erb'
require 'bcrypt'
#require "dm-types"



Bundler.require
# require 'sinatra/reloader'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/att_app.db")

class Item
	
	include DataMapper::Resource
	include BCrypt
	property :id, Serial, :key => true
	property :email, String, :length => 50
	property :password, BCryptHash 
	# property :age, Integer
	# property :profile, String
	property :name, Text
	property :surname, Text
	property :signin_time, DateTime
	# property :login, Boolean, :required => true, :default => false
	# property :submit, Boolean, :required => true, :default => false
end
DataMapper.finalize
# DataMapper.auto_migrate!
DataMapper.auto_upgrade!
# Item.auto_migrate!

class Items < Sinatra::Base
	enable :sessions
	# register Sinatra::Flash
end


get '/' do
 
 erb :home
end

post '/profile' do
	# U = Users.find(params[:id])
	# U.name = params[:name]
	# U.save
	@Items = Item.all :order => :id.desc
	@title = 'All Notes'
end

get '/profile' do
	session[:user] = 1
	@item = Item.all()
	erb :userProfile
end

post '/login' do
	@user1 = Item.all()
	erb :userProfile
end

# get '/signup' do
# 	erb :signup_form
# end

post '/newUser' do
	# @sign_in = Time.now
	Item.create(name: params[:name], surname: params[:surname], email: params[:email], signin_time: Time.now)
	@user1 = Item.all()
	erb :userProfile
end

get '/signup' do 
	@title = "Attendance List"
	erb :signup_form
end

get '/profileCreated' do
	erb :home
end

not_found do 
	halt 404, 'Page not found'
end