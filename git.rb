#!/usr/bin/env ruby

require_relative 'models/boot'
require_relative 'config/config'

class GitLog
  def initialize(entry)
    message = ''
    entry.each_line do |l|
      @commit = l if l =~ /^commit [0-9abcdef]+$/
      @author = l if l =~ /^Author: /
      @date = l if l =~ /^Date: /
      message << l if l =~ /^  /
    end

    body = message.strip.split("\n")
    @header = body.first
    @body = body[1..-1].join("\n").strip
  end

  def author
    @author.gsub(/^Author: /, '').strip
  end

  def date
    date_string = @date.gsub(/^Date: /, '')
    Time.parse(date_string)
  end

  def commit
    @commit.split.last
  end

  def body
    @body
  end

  def header
    @header
  end
end

class Git
  def initialize(repo, repo_path, remote = 'origin', dev_branch = 'develop', master_branch = 'master')
    @repo = repo
    @dir = repo_path
    @remote, @dev_branch, @master_branch = remote, dev_branch, master_branch
  end

  def git_dir
    "#{@dir}/.git"
  end

  def work_tree
    @dir
  end

  def get_logs_n_cmd
    "git --git-dir='#{git_dir}' --work-tree=#{work_tree} log -n 15"
  end

  def get_logs_diff_cmd
    "git --git-dir='#{git_dir}' --work-tree=#{work_tree} log #{@remote}/#{@master_branch}..#{@remote}/#{@dev_branch}"
  end

  def get_logs_cmd
    get_logs_n_cmd
  end

  def get_logs_raw
    cmd = get_logs_cmd
    puts cmd
    `#{cmd}`
  end

  def get_logs
    raw = get_logs_raw

    logs = []
    memo = ''
    raw.each_line do |l|
      if l =~ /^commit [0-9abcdef]+$/
        logs << memo if memo.length > 0
        memo = l
      else
        memo << l
      end
    end
    logs << memo if memo.length > 0

    logs.map{|l| GitLog.new(l)}
  end

  def save
    puts "getting logs"
    logs = get_logs

    commits = {}
    logs.each do |l|
      commits[l.commit] = l
    end

    # find known/missing commits
    known = Commit.all(repo: @repo, ref: commits.keys).map(&:ref)
    unknown = commits.keys - known

    puts "Going to create: #{unknown.inspect}"

    # create any commits not in the database
    unknown.each do |ref|
      log = commits[ref]
      commit = Commit.new(repo: @repo, ref: ref, author: log.author, header: log.header, body: log.body, date: log.date)

      if !commit.save
        puts "Error creating #{ref}:"
        p commit.errors
        puts
        puts "trying to save:"
        puts commit.inspect
      end
    end
  end
end

if __FILE__ == $0
  Repo.all.each do |repo|
    Git.new(repo, repo.local_path).save
  end
end
