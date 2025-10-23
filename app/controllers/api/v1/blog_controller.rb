class Api::V1::BlogController < ApplicationController
  def list
    page = params[:page].to_i > 0 ? params[:page].to_i : 1
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : 10
    offset = (page - 1) * limit
    total = Blog.count

    blogs = Blog.order(created_at: :desc).offset(offset).limit(limit)

    render json: {
      current_page: page,
      per_page: limit,
      total_records: total,
      total_pages: (total / limit.to_f).ceil,
      blogs: blogs.as_json(only: [ :id, :title, :slug, :short_description, :thumbnail, :created_at ])
    }, status: :ok
  end

  def create
    blog = Blog.create(blog_params)
    if blog.save
      render json: {
        message: "Create blog success",
        blog: {
          id: blog.id,
          title: blog.title
        }
      }
    else
      render json: {
        error: "Create success"
      }
    end
  end

  private

  def blog_params
    params.permit(:title, :slug, :description, :short_description, :thumbnail, :gallery, :user_id, :category_id)
  end
end
