#!/usr/bin/ruby

require 'sinatra'
require 'slim'
require_relative 'config/config'
require_relative 'models/boot'

enable :sessions
set :bind, '0.0.0.0'
set :session_secret, MyConfig.session_secret

get '/' do
  @repo = Repo.first(name: params[:repo]) || Repo.first(order: :name)
  @users = User.all.map(&:name)
  @user = params[:user] || session[:user]

  @logs = Commit.all(repo: @repo, order: :date.desc) - Commit.all(:header.like => 'Merge%')
  @github = @repo.github_commit_url

  session[:user] = @user

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

  new_params = []
  new_params << "user=#{user.name}"
  new_params << "repo=#{params[:repo]}"
  param_string = ''
  param_string = '?' + new_params.join('&') if new_params.any?

  redirect("#{param_string}#log#{commit_id}")
end
