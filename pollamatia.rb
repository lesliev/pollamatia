#!/usr/bin/ruby

require 'sinatra'
require 'slim'
require_relative 'config/config'
require_relative 'models/boot'

enable :sessions
set :bind, '0.0.0.0'
set :session_secret, MyConfig.session_secret

get '/' do
  @users = User.all.map(&:name)
  @user = params[:user] || session[:user]
  session[:user] = @user
  @logs = Commit.all(order: :date.desc)
  @github = MyConfig.github

  slim :index
end

post '/reviews' do
  commit_id = params[:minus] || params[:plus]
  minus = !!params[:minus]

  name = params[:name]
  user = User.first(name: name)
  commit = Commit.first(id: commit_id)

  if minus
    review = Review.first(user: user, commit: commit)
    review.destroy if review
  else
    Review.first_or_create(user: user, commit: commit)
  end

  user_param = "?user=#{user.name}"
  redirect("/#{user_param}#log#{commit_id}")
end
