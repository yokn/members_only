# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  include PostsHelper

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save

    flash.notice = "post '#{@post.title}' Created!"

    redirect_to posts_path
  end

  def edit
    @post = Post.find(params[:id])
    unless same_user?(@post.user.id)
      flash.notice = 'This is not your post!'
      redirect_to post_path(@post) and return
    end
  end

  def update
    @post = Post.find(params[:id])

    @post.update(post_params)

    flash.notice = "Post '#{@post.title}' Updated!"

    redirect_to post_path(@post)
  end

  def destroy
    @post = Post.find(params[:id])
    unless same_user?(@post.user.id)
      flash.notice = 'This is not your post!'
      redirect_to post_path(@post) and return
    end

    @post.destroy

    flash.notice = "Post '#{@post.title}' Deleted!"

    redirect_to posts_path
  end

  def same_user?(id)
    current_user.id == id
  end
end
